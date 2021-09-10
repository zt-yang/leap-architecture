"""General interface for a planner.
"""

import abc
import numpy as np
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

from .utils import summarize_sas


def get_planner( args_planner, args_planner_option, args_timeout ):
    
    if args_planner == 'fd':
        planner = FD( args_planner_option, args_timeout )

    elif args_planner == 'pp':
        planner = PP( args_planner_option, args_timeout )

    else:
        print('unspecified planner {args_planner}')

    return planner


class Planner:
    """An abstract planner for Leap
    """
    def __init__(self, planner_option, timeout):
        self.planner_option = planner_option
        self._timeout = timeout
        self._statistics = {}

    @abc.abstractmethod
    def __call__(self, domain_file, problem_file):
        """Takes in a PDDL domain and problem file. Returns a plan.
        """
        raise NotImplementedError("Override me!")

    def reset_statistics(self):
        """Reset the internal statistics dictionary.
        """
        self._statistics = {}

    def get_statistics(self):
        """Get the internal statistics dictionary.
        """
        return self._statistics

    def run_command(self, command, expdir):

        verbose = self.verbose

        problem_index = self.problem_index

        ## run with full shell outputs
        if verbose == 2: 
            os.system(command)


        ## no shell outputs, try planner for an amout of time
        manager = multiprocessing.Manager()
        return_dict = manager.dict()
        def run_planner(command, return_dict):
            return_dict[command] = subprocess.check_output(command, shell=True)
        
        p1 = multiprocessing.Process(target=run_planner, args=(command, return_dict), name='try_planner')
        p1.start()
        p1.join(timeout=self._timeout)
        p1.terminate()
        if command in return_dict:
            output = return_dict[command]

        else: ## kill because it consumes system CPU and memory
            output = ''
            for proc in psutil.process_iter():
                if 'downward' in proc.name():
                    proc.kill()


        ## --------------- collect planner output
        plan, log, short_log, [csv_cols, csv_log] = self.process_planner_output(output, expdir)
        
        ## the only plan by LAMA-first / Pyperplan, or shortest plan by LAMA
        plan_print = '\n     '.join(plan)
        self.print(f"\n  Plan: \n     {plan_print}")
        with open(join(expdir, f"_{problem_index}_output.txt"), "w") as f:
            f.writelines('\n'.join(plan))

        ## log by LAMA-first / Pyperplan, or all logs + plans by by LAMA
        if verbose:
            log_print = '\n     '.join(log) 
            self.print(f'\n\n  Log: \n     {log_print}')
        with open(join(expdir, f"_{problem_index}_log.txt"), "w") as f:
            f.writelines('\n'.join(log))

        ## one line summary of translation and search time
        self.print(f"\n{short_log}")

        ## detailed statistics summarized about the planning process
        csv_file = join(expdir[:expdir.rfind('/')], f'{datetime.now().strftime("%m%d")}.csv')
        if not isfile(csv_file):
            with open(csv_file,'w') as f:
                f.write(','.join(csv_cols) + '\n')
        with open(csv_file,'a') as f:
            f.write(','.join(csv_log) + '\n')

        return plan, float(csv_log[9]), float(csv_log[9])
            


class FD(Planner):

    name = 'FastDownward'

    def __call__(self, domain_file, problem_file, problem_index, expdir):

        self.t_started = time.time()
        self.task = (domain_file, problem_file)
        self.problem_index = problem_index

        command = self.get_command(domain_file, problem_file)
        plan, trans_t, search_t = self.run_command(command, expdir)

        ## delete all plan files sas_plan.x and translated file outpur.sas 
        for f in [f for f in listdir('./') if 'sas_plan' in f or '.sas' in f]:
            os.remove(f)

        return plan, trans_t, search_t


    def get_command(self, domain, problem):
        aliases = ["seq-opt-bjolp", "seq-opt-lmcut", "seq-sat-lama-2011", 
                    "lama", "lama-first"]
        customized_options = {}
        customized_options['v1'] = [
            '--evaluator',
                '"hlm=lmcount(lm_factory=lm_reasonable_orders_hps(lm_rhw()),pref=false)"',
            "--evaluator", 
                '"hff=ff()"',
            "--search", 
                '"lazy_greedy([hff,hlm],preferred=[hff,hlm], reopen_closed=false)"'
        ]

        if self.planner_option in aliases:
            # if args.planner_option == "lama": args.timeout = 30
            command = f"planners/downward/fast-downward.py --keep-sas-file --alias {self.planner_option} {domain} {problem}"

        else: ## customized search options
            planner_option = ' '.join( planner_options[self.planner_option] )
            command = f"planners/downward/fast-downward.py --keep-sas-file {domain} {problem} {planner_option}"

        return command


    def process_planner_output(self, output, expdir):

        domain, problem = self.task
        domain_json = join(expdir, domain[domain.rfind('/')+1:].replace('.pddl','.json'))
        problem_index = self.problem_index

        if isinstance(output, bytes): 
            output = output.decode()
            output = ''.join(output).split('\n')
        
        log = []
        short_log = ''
        csv_columns = ['timestamp', 'problem_name', 'var_count', 'op_count', 'axiom_count', 'plan_length', 'plan_cost', 'prep_time', 'parse_time', 'search_time', 'state_expanded']
        csv_log = [ datetime.now().strftime("%H%M%S"), problem[problem.index('/')+1:] ]
        csv_log.extend(['']*len(csv_columns[2:]))

        keywords = ['removed', 'necessary', 'Translator derived', 'Translator facts', 'Translator goal facts', 'Done!', 'Plan length', 'Plan cost', 'Expanded', 'Generated', 'Search time', 'Total time', 'keep searching']
        csv_mapping = ['variables necessary', 'operators necessary', 'rules necessary', 'Plan length', 'Plan cost', 'LEAP-prep', 'Translation time', 'Search time', 'Expanded']
        plans = []  ## some modes may return multiple plans
        plans_costs = []  ## costs of multiple plans
        plan = []  ## contain the optimal plan
        PLAN_PART = False


        for line in output:

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


        ## there must be 'output.sas', get translation time
        exp_sas = join(expdir, 'output.sas')
        t_translated = os.path.getmtime("output.sas")
        t_translate = f'{t_translated-self.t_started:.3f}'
        t_cutoff = f'(>{time.time()-t_translated:.2f})'
        t_prep = f"{sum(list(self.time_spent['prep'].values())):.3f}"
        csv_log[7] = t_prep

        shutil.copy('output.sas', exp_sas)
        count_var, count_op, count_ax = summarize_sas(exp_sas)
    
        ## if the planner failed but translation was successful, still able to get # of var, op, axiom from output.sas
        if output == '':
            csv_log[2:] = str(count_var), str(count_op), str(count_ax), '-', '-', t_prep, t_translate, t_cutoff, '-'


        ## 'LAMA-first' returned one solution
        if self.planner_option == 'lama-first':
            plan = plans[0]


        ## there may also be plans computed
        elif self.planner_option == 'lama':
            outputs = [f for f in listdir('./') if 'sas_plan' in f]
            outputs.sort()
            
            if len(outputs) > 0 and output == '':
                t_plans = [os.path.getmtime(f)-t_translated for f in outputs]
                t_search = t_plans[-1]

                plans = []
                plans_costs = []
                lines_plans = []
                ops_costs = json.load(open(domain_json, "r+"))['operators']
                for f in outputs:
                    ops = [l.replace('\n', '').replace('(', '').replace(')', '') for l in open(f, "r+").readlines()[:-1]]
                    costs = [ops_costs[l[0:l.index(' ')]]['cost'] for l in ops]
                    ops = [f'{ops[i]} ({costs[i]})' for i in range(len(ops))]
                    plans.append(ops)
                    plans_costs.append(sum(costs))

                ## save all plans
                for i in range(len(plans)):
                    with open(join(expdir, f"_{problem_index}_plan_{i}.txt"), "w") as f:
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
                csv_log[10] = csv_log[9]
                csv_log[9] = f'{t_plans[index]:.8f}' ## t_search

                ## rename the chosen optimal plan
                i = indices[index]
                os.rename( join(expdir, f"_{problem_index}_plan_{i}.txt"), 
                    join(expdir, f"_{problem_index}_plan_{i}_opt.txt") )

            ## returned no solution
            if len(plans) == 0:
                plan = []


        return plan, log, short_log, [csv_columns, csv_log]


class PP(Planner):

    name = 'PyperPlan'

    def __call__(self, domain, problem, expdir):
        command = f"planners/pyperplan/src/run.py -H hff -s gbf {domain} {problem}"
        self.run_command(command, problem_path, problem_index, expdir)

    def process_planner_output(self, output, problem_path, problem_index, expdir):

        log = []

        keywords = ['parsed', 'removed', 'created', 'expanded', 'Search time', 'Plan length']
        solution_file = problem + '.soln'
        solution = open(solution_file, "r+").readlines()
        plan = [op.replace('\n', '') for op in solution]
        os.remove(solution_file)

        for line in output:
            if 'INFO' in line:
                line = line[line.index('INFO')+9:]

            ## select terminal outputs to be logged
            for keyword in keywords:
                if keyword in line:
                    log.append(line)

        return None, log, None, [None, None]


     
