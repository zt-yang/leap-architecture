"""General interface for a cognitive manager.
"""

import abc
from os import mkdir
from os.path import join, isdir
from datetime import datetime

from .cogman import CogMan
from .utils import get_pddl

class LEAP(CogMan):
    
    """An abstract cognitive manager for Leap
        initialization doesn't require specific domain and problem file
    """

    def __init__(self, expdir=None, verbose=2):

        if expdir == None:
            expdir = join('..', 'experiments', 'dev')
        self.expdir = expdir

        self.verbose = verbose
        self.time_spent = {}


    def __call__(self, domain_name, problem_name, objectset_name=None):

        ## get specific task name as a subdirectory in the main directory
        expdir = self.get_exp_name(domain_name, problem_name, objectset_name)

        ## debug, merge, and copy files to expdir
        self.task = get_pddl(domain_name, problem_name, expdir, objectset_name, verbose=(self.verbose==1))
        self._planner.task_original = self.task
        
        ## leap.run_pre_strategists()
        tasks = self.run_pre_strategists(self.task, expdir)

        ## run the planner on each subtask
        outputs = self.run_planner(tasks, expdir)

        ## refines the subplans, may involve solving the problem again
        outputs = self.run_post_strategists(outputs, expdir)

        ## concatnate or select from outputs
        plan = self.get_plan(outputs)

        return plan


    def init_planner(self, planner):

        self._planner = planner
        self._planner.verbose = self.verbose
        self._planner.print = self.print
        self._planner.time_spent = self.time_spent


    def init_pre_strategists(self, pre_strategists=[]):

        self._pre_strategists = pre_strategists
        for strategist in pre_strategists:
            strategist.expdir = self.expdir
            strategist.verbose = self.verbose
        

    def init_post_strategists(self, post_strategists=[]):

        self._post_strategists = post_strategists
        for strategist in post_strategists:
            strategist.expdir = self.expdir
            strategist.verbose = self.verbose
            strategist.leap = self


    def get_exp_name(self, domain_name, problem_name, objectset_name):

        dt = datetime.now().strftime("%H%M%S")
        name = f"dmn={domain_name}-prb={problem_name}"
        to_print = f' {dt}  dmn={domain_name}\tprb={problem_name}'

        if objectset_name != None: 
            name += f'-obj={objectset_name}'
            to_print += f'\tobj={objectset_name}'

        if self._planner.planner_option != None: 
            planner_option = self._planner.planner_option.replace('-','_')
            name += f'-pln={planner_option}'
            to_print += f'\tpln={planner_option}'
        else:
            name += f'-pln={planner}'
            to_print += f'\tpln={planner}'

        if len(self._pre_strategists) > 0: 
            n = '+'.join([s.name for s in self._pre_strategists])
            name += f'-prep={n}'
            to_print += f'\tprep={n}'

        ## make a new directory in experiments/ by the timestamp
        expdir = join(self.expdir, datetime.now().strftime("%m%d-%H%M%S")+'-'+name.replace('.pddl',''))
        while isdir(expdir):
            expdir += '+'
        mkdir(expdir)

        if self.verbose == 0: print(to_print)
        if self.verbose == 3: print('\n'+to_print)

        return expdir


    def run_pre_strategists(self, task, expdir):

        tasks = [task]
        count = 0

        self.print(f'\nStep 2: Abstract with {len(self._pre_strategists)} strategists: {[s.name for s in self._pre_strategists]}')

        comp_times = {}
        while count < len(self._pre_strategists):
            strategist = self._pre_strategists[count]
            strategist.init_task(task)

            new_tasks = []
            comp_time = 0
            for subtask in tasks:
                domain, problem = subtask
                out_tasks, comp_t = strategist(domain, problem, expdir)
                new_tasks.extend( out_tasks )
                comp_time += comp_t
            
            tasks = new_tasks
            count += 1
            comp_times[strategist.name] = comp_time

        self.time_spent['prep'] = comp_times
        return tasks


    def run_planner(self, tasks, expdir):

        self.print(f'\nStep 3: Plan with {self._planner.name}')
        self.print(f'\n  expdir: {expdir}')

        outputs = []
        trans_times = {}
        search_times = {}

        for i in range(len(tasks)):
            if len(tasks) > 1:
                self.print(f'\n---------------- Subproblem {i} ----------------')
                self.print(f'  Sub-domain: {tasks[i][0].replace(expdir, "")}')
                self.print(f'  Sub-problem: {tasks[i][1].replace(expdir, "")}')
            
            domain, problem = tasks[i]
            output, trans_t, search_t = self._planner(domain, problem, i, expdir)
            trans_times[i] = trans_t
            search_times[i] = search_t
            outputs.append(output)
            if output == False: break  ## no need to solve the rest when one subproblem fails

        self.time_spent['trans'] = trans_times
        self.time_spent['search'] = search_times

        return outputs


    def run_post_strategists(self, outputs, expdir):
        
        count = 0
        comp_times = {}
        while count < len(self._post_strategists):
            strategist = self._post_strategists[count]
            outputs, comp_t = strategist(outputs, expdir)
            count += 1
            if strategist.name not in comp_times:
                comp_times[strategist.name] = 0
            comp_times[strategist.name] += comp_t

        self.time_spent['post'] = comp_times
        return outputs


    def get_plan(self, outputs):

        self.report_time()

        return outputs ## just return the plan 


    def report_time(self):

        line = '\n'
        for key, value in self.time_spent.items():
            t = sum(list(value.values()))
            line += f'{key}: {str(round(t, 4))}\t'
        # print(line)
        self.print(line)


    def print(self, text):
        """ verbose = 0: print input file names 
            verbose = 1: print plan 
            verbose = 2: print planner output 
            verbose = 3: print test name and plan for comparing plans """

        if self.verbose == 1: 
            print(text)

        elif self.verbose == 3 and ('Plan:' in text or text.endswith(')')):
            print(text)
         
