import argparse
import re
import errno
import signal
import functools
import os
import time
from os import listdir
from os.path import join, isfile, isdir
import subprocess
import glob
from datetime import datetime
import shutil
import multiprocessing
import json
import psutil

from generators.init_objects import get_defined_objects, replace_lines, comment_line, get_action_by_name, merge_domains, merge_objects, check_consistency, summarize_sas


parser = argparse.ArgumentParser()
parser.add_argument(dest="domain")
parser.add_argument(dest="problem")
parser.add_argument('-p', dest="planner", type=str, default='fd')
parser.add_argument('-po', dest="planner_option", type=str, default="lama-first")
parser.add_argument('-o', dest="use_objects", type=str, default=None)
parser.add_argument('-s', dest="strategists", type=str, default=None)
parser.add_argument('-v', dest="verbose", type=int, default=1)
parser.add_argument('-e', dest="exp_dir", type=str, default='experiments')
parser.add_argument('-a', dest="action_sub", type=str, default=None)
parser.add_argument('-g', dest="goal_ignore", type=str, default=None)
parser.add_argument('-t', dest="timeout", type=int, default=10)
args = parser.parse_args()
t_started = time.time()

planner_names = {'fd': 'FastDownward', 'pp': 'PyperPlan'}


def myprint(text = ''):
    """ verbose = 0: print input file names 
        verbose = 1: print plan 
        verbose = 2: print planner output 
        verbose = 3: print test name and plan for comparing plans """
    if args.verbose == 1: 
        print(text)

    elif args.verbose == 3 and ('Plan:' in text or text.endswith(')')):
        print(text)


def get_output_name():
    dt = datetime.now().strftime("%H%M%S")
    to_print = f' {dt}  dmn={args.domain}\tprb={args.problem}'
    name = f"dmn={args.domain.replace('.pddl','')}-prb={args.problem.replace('.pddl','')}"

    if args.planner == 'fd':
        planner_option = args.planner_option.replace('-','_')
        name += f'-pln={planner_option}'
        to_print += f'\tpln={planner_option}'
    else:
        name += f'-pln={args.planner}'
        to_print += f'\tpln={args.planner}'


    if args.use_objects != None: 
        name += f'-obj={args.use_objects}'
        to_print += f'\tobj={args.use_objects}'

    if args.action_sub != None: 
        action_sub = args.action_sub.replace('-','_')
        name += f'-op={action_sub}'
        to_print += f'\top={action_sub}'

    if args.goal_ignore != None: 
        goal_ignore = args.goal_ignore.replace('-','_')
        name += f'-gi={goal_ignore}'
        to_print += f'\tgi={goal_ignore}'

    if args.verbose == 0: print(to_print)
    if args.verbose == 3: print('\n'+to_print)
    return name


def get_pddl(expdir, parentdir = "domains"):
    """ prepare the domain and problem pddl files of original task """

    ## prepare to copy them to one of experiments/ subdirectory
    domain = join(expdir, args.domain)
    problem = join(expdir, args.problem)

    ## find the domain and problem file in all sub-directories of domains/
    given_domains = args.domain.split('+')
    found_domains = [glob.glob(parentdir + f"/**/{d}", recursive = True)[0] for d in given_domains]
    found_problem = glob.glob(parentdir + f"/**/{args.problem}", recursive = True)[0]
    myprint(f'\nStep 1: Prepare input pddl files in experiment directory {parentdir}\n  Found domain: {found_domains} \n  Found problem: {found_problem}')


    ## if given multiple domain files, merge parts into one and copy to expdir
    if len(found_domains) > 1:
        domain = merge_domains(found_domains, expdir)
    else:
        shutil.copy(found_domains[0], domain)


    ## replace (:types in domain and (:objects in problem 
    if args.use_objects != None:

        ## with those defined in generators/objects.md
        if '.md' in args.use_objects:
            new_types, new_objects = get_defined_objects()
            replace_lines(domain, '(:types', '(:predicates', new_types, domain)
            replace_lines(found_problem, '(:objects', '(:init', new_objects, problem)
        
        ## with those pddl subfiles in domains/../objects
        elif '.pddl' in args.use_objects:

            given_objects = args.use_objects.split('+')
            found_objects = [glob.glob(parentdir + f"/**/{d}", recursive = True)[0] for d in given_objects]

            ## if given multiple object files, merge files and copy to expdir
            if len(found_objects) > 1:
                obj_file = merge_objects(found_objects, expdir)
            else:
                obj_file = found_objects[0]

            new_objects_env = open(obj_file, "r+").readlines()
            replace_lines(found_problem, '(:objects', '(:goal', new_objects_env, problem)

        ## check_consistency
        check_consistency(found_domains, found_problem, obj_file)

    else:
        shutil.copy(found_problem, problem)

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

    ## delete all lines with the specified goal predicate in domain after a start key
    if args.goal_ignore != None:
        comment_line(domain, '; -------- recipes',  args.goal_ignore, domain)
    
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

    aliases = ["seq-sat-fd-autotune-1", "seq-sat-fd-autotune-2", 
                "seq-sat-lama-2011", "lama", "lama-first", 
                "seq-opt-bjolp", "seq-opt-lmcut"]
    if args.planner == 'fd':
        if args.planner_option in aliases:
            # if args.planner_option == "lama": args.timeout = 30
            return f"planners/downward/fast-downward.py --keep-sas-file --alias {args.planner_option} {domain} {problem}"

        else: ## customer search options
            planner_options = {}
            planner_options['v1'] = [
                '--evaluator',
                    '"hlm=lmcount(lm_factory=lm_reasonable_orders_hps(lm_rhw()),pref=false)"',
                "--evaluator", 
                    '"hff=ff()"',
                "--search", 
                    '"lazy_greedy([hff,hlm],preferred=[hff,hlm], reopen_closed=false)"'
            ]
            planner_option = ' '.join( planner_options[args.planner_option] )
            return f"planners/downward/fast-downward.py --keep-sas-file {domain} {problem} {planner_option}"
    
    elif args.planner == 'pp':
        return f"planners/pyperplan/src/run.py -H hff -s gbf {domain} {problem}"
    
    else:
        print(f'unknown planner {args.planner}')


def process_planner_output(output, problem, expdir):

    if isinstance(output, bytes): 
        output = output.decode()
        output = ''.join(output).split('\n')
    log = []
    short_log = ''
    csv_columns = ['timestamp', 'problem_name', 'var_count', 'op_count', 'axiom_count', 'plan_length', 'plan_cost', 'translation_time', 'search_time', 'state_expanded']
    csv_log = [ datetime.now().strftime("%H%M%S"), problem[problem.index('/')+1:] ]
    csv_log.extend(['']*len(csv_columns[2:]))

    if args.planner == 'pp':
        keywords = ['parsed', 'removed', 'created', 'expanded', 'Search time', 'Plan length']
        solution_file = problem + '.soln'
        solution = open(solution_file, "r+").readlines()
        plan = [op.replace('\n', '') for op in solution]
        os.remove(solution_file)

    elif args.planner == 'fd':
        keywords = ['removed', 'necessary', 'Translator derived', 'Translator facts', 'Translator goal facts', 'Done!', 'Plan length', 'Plan cost', 'Expanded', 'Generated', 'Search time', 'Total time', 'keep searching']
        csv_mapping = ['variables necessary', 'operators necessary', 'rules necessary', 'Plan length', 'Plan cost', 'Translation time', 'Search time', 'Expanded']
        plans = []  ## some modes may return multiple plans
        plans_costs = []  ## costs of multiple plans
        plan = []  ## contain the optimal plan
        PLAN_PART = False


    for line in output:
        
        if args.planner == 'pp':
            if 'INFO' in line:
                line = line[line.index('INFO')+9:]
        
        elif args.planner == 'fd':
            if 'KB]' in line:
                line = line[line.index('KB]')+4:]
            
            elif PLAN_PART and ' (' in line:
                plan.append(line)
                log.append(line)

            if 'Solution found!' in line:
                PLAN_PART = True

            if 'Plan cost' in line:
                plans_costs.append(int(line[line.rfind(' ')+1:]))

            if 'Plan length:' in line:
                PLAN_PART = False
                plans.append(plan)
                plan = []

        ## select terminal outputs to be logged
        for keyword in keywords:
            if keyword in line: ## and line not in log:
                
                if keyword == 'Done!': line += '\n' ## finished translating
                if keyword == 'Generated': line += '\n' ## finished summarizing this plan
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

    t_translate = '-'
    t_plans = None
    if args.planner == 'fd': ## isfile('output.sas'):

        ## there must be 'output.sas', get translation time
        exp_sas = join(expdir, 'output.sas')
        t_translated = os.path.getmtime("output.sas")
        t_translate = f'{t_translated-t_started:.3f}'
        t_cutoff = f'(>{time.time()-t_translated:.2f})'

        shutil.copy('output.sas', exp_sas)
        count_var, count_op, count_ax = summarize_sas(exp_sas)
    
        ## if the planner failed but translation was successful, still able to get # of var, op, axiom from output.sas
        if output == '':
            csv_log[2:] = str(count_var), str(count_op), str(count_ax), '-', '-', t_translate, t_cutoff, '-'

            ## there may also be plans computed
            if args.planner_option == 'lama':
                outputs = [f for f in listdir('./') if 'sas_plan' in f]
                outputs.sort()
                if len(outputs) > 0:
                    t_plans = [os.path.getmtime(f)-t_translated for f in outputs]
                    t_search = t_plans[-1]

                    plans_costs = []
                    lines_plans = []
                    ops_costs = json.load(open(join('generators', 'check_domain.json'), "r+"))['operators']
                    for f in outputs:
                        ops = [l.replace('\n', '').replace('(', '').replace(')', '') for l in open(f, "r+").readlines()[:-1]]
                        costs = [ops_costs[l[0:l.index(' ')]]['cost'] for l in ops]
                        ops = [f'{ops[i]} ({costs[i]})' for i in range(len(ops))]
                        plans.append(ops)
                        plans_costs.append(sum(costs))

    ## must be 'fd' and 'lama'
    if t_plans != None:

        ## save all plans
        for i in range(len(plans)):
            with open(join(expdir, f"_plan_{i}.txt"), "w") as f:
                f.writelines('\n'.join(plans[i]))
                f.writelines(f'\n; cost = {plans_costs[i]}')

        ## among plans with min cost, choose one plan with the min len
        min_cost = min(plans_costs)
        indices = [i for i, cost in enumerate(plans_costs) if cost == min_cost]
        plans = [plans[i] for i in indices]
        plans_lens = [len(p) for p in plans]
        min_len = min(plans_lens)
        index = [i for i, lens in enumerate(plans_lens) if lens == min_len][0]
        plan = plans[index]

        csv_log[5:7] = str(len(plan)), str(min_cost)
        csv_log[9] = csv_log[8]
        csv_log[8] = f'{t_plans[index]:.8f}' ## t_search

        ## rename the chosen optimal plan
        i = indices[index]
        os.rename(join(expdir, f"_plan_{i}.txt"), join(expdir, f"_plan_{i}_opt.txt"))

    ## must be 'fd'
    elif len(plans) == 0:
        plan = []

    else:
        plan = plans[0]


    return plan, log, short_log, [csv_columns, csv_log]


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
        p1.join(timeout=args.timeout)
        p1.terminate()
        if command in return_dict:
            output = return_dict[command]
        else:
            output = ''
            ## kill the process in case it consumes system CPU and memory
            for proc in psutil.process_iter():
                if 'downward' in proc.name():
                    proc.kill()
                    # os.system('pkill -9 downward')

        ## --------------- collect planner output
        plan, log, short_log, csv_log = process_planner_output(output, problem, expdir)
        
        ## the only plan by LAMA-first / Pyperplan, or shortest plan by LAMA
        plan_print = '\n     '.join(plan)
        myprint(f"\n  Plan: \n     {plan_print}")
        with open(join(expdir, f"_output_{index}.txt"), "w") as f:
            f.writelines('\n'.join(plan))

        ## log by LAMA-first / Pyperplan, or all logs + plans by by LAMA
        if verbose:
            log_print = '\n     '.join(log) 
            myprint(f'\n\n  Log: \n     {log_print}')
        with open(join(expdir, f"_{args.planner}_{index}.log"), "w") as f:
            f.writelines('\n'.join(log))

        ## one line summary of translation and search time
        myprint(f"\n{short_log}")

        ## detailed statistics summarized about the planning process
        csv_file = join(args.exp_dir, f'{datetime.now().strftime("%m%d")}.csv')
        if not isfile(csv_file):
            with open(csv_file,'w') as f:
                f.write(','.join(csv_log[0]) + '\n')
        with open(csv_file,'a') as f:
            f.write(','.join(csv_log[1]) + '\n')

        ## delete all sas_plan files because they contain no cost info
        if args.planner == 'fd': ## and isfile('sas_plan'): 
            for f in [f for f in listdir('./') if 'sas_plan' in f]:
                os.remove(f)
                # f = f.replace('sas_plan. ','')
                # shutil.move(f, join(expdir, f'_plans_{index}_{f}.txt'))

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

