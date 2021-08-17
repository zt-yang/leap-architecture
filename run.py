import argparse
import re
import errno
import signal
import functools
import os
from os.path import join, isfile, isdir
import subprocess
import glob
from datetime import datetime
import shutil
import multiprocessing

from generators.init_objects import get_defined_objects, replace_lines, get_action_by_name

parser = argparse.ArgumentParser()
parser.add_argument(dest="domain")
parser.add_argument(dest="problem")
parser.add_argument('-p', dest="planner", type=str, default='fd')
parser.add_argument('-o', dest="use_objects", type=str, default=None)
parser.add_argument('-s', dest="strategists", type=str, default=None)
parser.add_argument('-v', dest="verbose", type=int, default=1)
parser.add_argument('-e', dest="exp_dir", type=str, default='experiments')
parser.add_argument('-a', dest="action_sub", type=str, default=None)
args = parser.parse_args()

planner_names = {'fd': 'FastDownward', 'pp': 'PyperPlan'}


def myprint(text = ''):
    """ verbose = 0: print input file names 
        verbose = 1: print plan 
        verbose = 2: print planner output """
    if args.verbose == 1: print(text)


def get_output_name():
    to_print = f'   dmn={args.domain}\tprb={args.problem}'
    name = f"{args.domain.replace('.pddl','')}-{args.problem.replace('.pddl','')}-{args.planner}"
    if args.use_objects != None: 
        name += f'-{args.use_objects}'
        to_print += f'\tobj={args.use_objects}'
    if args.action_sub != None: 
        name += f'-{args.action_sub}'
        to_print += f'\topt+{args.action_sub}'
    if args.verbose == 0: print(to_print)
    return name


def get_pddl(expdir, parentdir = "domains"):
    """ prepare the domain and problem pddl files of original task """

    ## find the domain and problem file in all sub-directories of domains/
    domains = glob.glob(parentdir + f"/**/{args.domain}", recursive = True)
    problems = glob.glob(parentdir + f"/**/{args.problem}", recursive = True)
    myprint(f'\nStep 1: Prepare input pddl files in experiment directory {parentdir}\n  Found domain: {domains} \n  Found problem: {problems}')

    ## prepare to copy them to one of experiments/ subdirectory
    domain = join(expdir, args.domain)
    problem = join(expdir, args.problem)

    ## replace (:types in domain and (:objects in problem 
    if args.use_objects != None:

        ## with those defined in generators/objects.md
        if '.md' in args.use_objects:
            new_types, new_objects = get_defined_objects()
            replace_lines(domains[0], '(:types', '(:predicates', new_types, domain)
            replace_lines(problems[0], '(:objects', '(:init', new_objects, problem)
        
        ## with those pddl subfiles in domains/../objects
        elif '.pddl' in args.use_objects:
            files = glob.glob(parentdir + f"/**/{args.use_objects}", recursive = True)
            new_objects_env = open(files[0], "r+").readlines()
            replace_lines(problems[0], '(:objects', '(:goal', new_objects_env, problem)
            shutil.copy(domains[0], domain)
    else:
        shutil.copy(domains[0], domain)
        shutil.copy(problems[0], problem)

    ## replace (:action in domain
    if args.action_sub != None:

        ## find the action name and file with all its variations
        new_action_name = args.action_sub
        action_name = new_action_name[:new_action_name.rfind('-')]
        action_pddl = glob.glob(parentdir + f"/**/{action_name}.pddl", recursive = True)[0]

        ## find the action definition in action file
        new_action = get_action_by_name(new_action_name, action_pddl)

        ## replace the action definition in domain file
        startkey = f":action {action_name}"
        endkey = f"; don't delete this line: for substituting {action_name} effects"
        replace_lines(domain, startkey, endkey, new_action, domain)
    
    return domain, problem


def get_problems(domain, problem):
    """ map a big problem into a sequence of smaller ones """
    problems = [(domain, problem)]
    strategists = []
    if args.strategists != None:
        strategists = args.strategists.split(',')

    myprint(f'\nStep 2: Abstract with {len(strategists)} strategists: {strategists}')

    while len(strategists) != 0:
        strategist = strategists[0]
        new_problems = []
        for subproblem in problems:
            new_domain, new_problem = run_strategist(strategist, domain, problem)
            new_problems.append([new_domain, new_problem])
        myprint(f'  {strategist}: turns {len(problems)} problems into {len(new_problems)} problems')
        problems = new_problems
        strategists.pop(0)
    return problems


def run_strategist(strategist, domain, problem):
    if strategist == 'hpn' or strategist == 'c2s2':
        return domain, problem
    else:
        print('unknown strategist')
    return None, None


## planners/downward/fast-downward.py --alias lama-first experiments/omelette_objects/0810-100058-omelette_3+/kitchen.pddl experiments/omelette_objects/0810-100058-omelette_3+/omelette_3.pddl
def get_planner_command(domain, problem):
    if args.planner == 'fd':
        return f"planners/downward/fast-downward.py --alias lama-first {domain} {problem}"
    elif args.planner == 'pp':
        return f"planners/pyperplan/src/run.py -H hff -s gbf {domain} {problem}"
    else:
        print(f'unknown planner {args.planner}')


def process_planner_output(output, problem, keywords=[]):

    if isinstance(output, bytes): 
        output = output.decode()
        output = ''.join(output).split('\n')
    log = []
    short_log = ''
    csv_columns = ['timestamp', 'problem_name', 'var_count', 'op_count', 'axiom_count', 'plan_length', 'translation_time', 'search_time', 'state_expanded']
    csv_log = [ datetime.now().strftime("%H%M%S"), problem[problem.index('/')+1:] ]
    csv_log.extend(['']*len(csv_columns[2:]))

    if args.planner == 'pp':
        keywords = ['parsed', 'removed', 'created', 'expanded', 'Search time', 'Plan length']
        solution_file = problem + '.soln'
        solution = open(solution_file, "r+").readlines()
        plan = [op.replace('\n', '') for op in solution]
        os.remove(solution_file)

    elif args.planner == 'fd':
        keywords = ['removed', 'necessary', 'Translator derived', 'Translator facts', 'Translator goal facts', 'Done!', 'Plan length', 'Expanded', 'Generated', 'Search time', 'Total time']
        csv_mapping = ['variables necessary', 'operators necessary', 'rules necessary', 'Plan length', 'Translation time', 'Search time', 'Expanded']
        plan = []
        start = False

    for line in output:
        
        if args.planner == 'pp':
            if 'INFO' in line:
                line = line[line.index('INFO')+9:]
        
        elif args.planner == 'fd':
            if 'KB]' in line:
                line = line[line.index('KB]')+4:]
            elif start and ' (' in line:
                plan.append(line)
                line = ''
            elif 'reasonable' in line:
                start = True

        ## select terminal outputs to be logged
        for keyword in keywords:
            if keyword in line and line not in log:
                
                log.append(line)

                if 'Plan length' in line or ' time' in line or 'wall-clock' in line:
                    if 'CPU,' in line: 
                        line = "Translation time: " + line[line.index('CPU,')+5:line.index('wall-clock')]
                    short_log += line + ' | '

                for k in csv_mapping:
                    if k in line:
                        if 'time' in k:
                            number = '.'.join(re.findall(r'\d+', line))
                        else:   
                            number = re.search(r'\d+', line).group()
                        csv_log[csv_mapping.index(k)+2] = number

    ## if the planner failed but translation was successful, still able to get # of var, op, axiom from output.sas
    if output == '' and isfile('output.sas'):
        lines = open('output.sas', "r+").readlines()
        count_var, count_op, count_ax = 0, 0, 0
        for line in lines:
            if 'begin_variable' in line:
                count_var += 1
            elif 'begin_operator' in line:
                count_op += 1
            elif 'begin_rule' in line:
                count_ax += 1
        csv_log[2:] = str(count_var), str(count_op), str(count_ax), '-', '-', '-', '-'

    return plan, log, short_log, [csv_columns, csv_log]

# class TimeoutError(Exception):
#     pass

# def timeout(seconds=10, error_message=os.strerror(errno.ETIME)):
#     def decorator(func):
#         def _handle_timeout(signum, frame):
#             raise TimeoutError(error_message)

#         @functools.wraps(func)
#         def wrapper(*args, **kwargs):
#             signal.signal(signal.SIGALRM, _handle_timeout)
#             signal.alarm(seconds)
#             try:
#                 result = func(*args, **kwargs)
#             finally:
#                 signal.alarm(0)
#             return result

#         return wrapper

#     return decorator

# @timeout(20) ## , os.strerror(errno.ETIMEDOUT)
def get_plan(problems, expdir, verbose=False):

    manager = multiprocessing.Manager()
    return_dict = manager.dict()
    def run_planner(command, return_dict):
        return_dict[command] = subprocess.check_output(command, shell=True)

    index = 0
    planner_name = planner_names[args.planner]
    myprint(f'\nStep 3: Plan with {planner_name}')

    for subproblem in problems:
        index += 1
        if len(problems) > 1:
            myprint(f'\n---------------- Subproblem {index} ----------------')

        domain, problem = subproblem
        command = get_planner_command(domain, problem)

        if args.verbose == 2: 
            os.system(command)

        ## try planner for an amout of time
        p1 = multiprocessing.Process(target=run_planner, args=(command, return_dict), name='try_planner')
        p1.start()
        p1.join(timeout=20)
        p1.terminate()
        p1.join()
        if command in return_dict:
            output = return_dict[command]
        else:
            output = ''

        # output = subprocess.check_output(command, shell=True)
        plan, log, short_log, csv_log = process_planner_output(output, problem)
        
        plan_print = '\n     '.join(plan)
        myprint(f"\n  Plan: \n     {plan_print}")
        if verbose:
            log_print = '\n     '.join(log) 
            myprint(f'\n\n  Log: \n     {log_print}')
        myprint(f"\n{short_log}")

        with open(join(expdir, f"_output_{index}.txt"), "w") as f:
            f.writelines('\n'.join(plan))

        with open(join(expdir, f"_{args.planner}_{index}.log"), "w") as f:
            f.writelines('\n'.join(log))

        csv_file = join(args.exp_dir, f'{datetime.now().strftime("%m%d")}.csv')
        if not isfile(csv_file):
            with open(csv_file,'w') as f:
                f.write(','.join(csv_log[0]) + '\n')
        with open(csv_file,'a') as f:
            f.write(','.join(csv_log[1]) + '\n')

    if args.planner == 'fd' and isfile('sas_plan'): os.remove('sas_plan')

def start_single_experiment(output_name):
    """ make a new directory in experiments/ by the timestamp"""
    expdir = join(args.exp_dir, datetime.now().strftime("%m%d-%H%M%S")+'-'+output_name)
    while isdir(expdir):
        expdir += '+'
    os.mkdir(expdir)
    return expdir

if __name__ == "__main__":
    output_name = get_output_name()
    expdir = start_single_experiment(output_name=output_name)
    domain, problem = get_pddl(expdir)
    problems = get_problems(domain, problem)
    plan = get_plan(problems, expdir=expdir)

