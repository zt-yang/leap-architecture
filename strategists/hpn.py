""" Example interface for HPN-like pre-strategists that breaks down a task into sub-tasks
"""

import abc
import json
import random
from time import time
from os.path import  join
from os import listdir, mkdir
from.strategist import PreStrategist

from .influence_graph import InfluenceGraph
from .utils import get_goals, get_init, merge_pdf, count_char

import sys, os
sys.path.insert(0, os.path.abspath('..'))
from cogmen.utils import get_pred, empty

class HPN(PreStrategist):
    """ Reduces the universe/ number of objects of a problem
    """

    name = 'HPN'

    def __call__(self, domain_file, problem_file, timeout=10):
        """ Takes in a PDDL domain and problem file. 
            Returns a set of sequence of subproblems.
                [ [ (domain.pddl, problem.pddl) ] ]
                e.g. PLOI may sample multiple minimum object sets 
                    with incremental importance score threshold
        """


        raise NotImplementedError("Override me!")



class SDBIG(PreStrategist):
    """ Separate Domains Based on Influence Graph """

    name = 'SDBIG'
    RENDER_GRAPH = False
    DEBUG = False
    
    def __init__(self):
        self.proposed_subgoals = {}
        self.proposed_tasks = {} 


    def __call__(self, domain_file, problem_file, expdir):
        """ Takes in a PDDL domain and problem file. 
            Return the reduced domains and corresponding sub-problems
        """

        ## if samples have been generated for a task, just extract
        if (domain_file, problem_file) in self.proposed_tasks:
            return self.get_proposed_task((domain_file, problem_file)), 0
        self.proposed_subgoals[(domain_file, problem_file)] = [None]

        RENDER_GRAPH = self.RENDER_GRAPH
        time_spent = 0 ## exclude the time for rendering graphs
        start = time()

        out_dir = join(expdir, 'sdbig')
        mkdir(out_dir)

        dmn_json = domain_file.replace('.pddl', '.json')
        prb_pddl = problem_file
        obj_json = [join(expdir,f) for f in listdir(expdir) if 'obj_' in f and '.json' in f][0]

        ## speicify output files
        graph0 = '0 domain.gv'
        graph1 = '1 goals.gv'
        graph2 = '2 goals only.gv'
        pdfs = [f"{join(out_dir, s)}.pdf" for s in [graph0, graph1, graph2]]

        ## given a domain, plot all predicates used by operators
        ig = InfluenceGraph(dmn_json)
        time_spent += ( time() - start )
        if RENDER_GRAPH: 
            ig.get_dot().render(join(out_dir, graph0), view=False)
        start = time() 

        ## given a problem, plot all init and goal predicates
        goals, goal_preds = get_goals(prb_pddl)
        init = get_init(obj_json)
        ancestors = ig.find_ancestors(starts=goal_preds)
        ancestors['style'] = ig.mark_start_finish(goals, init, ancestors['style'])
        time_spent += ( time() - start )
        if RENDER_GRAPH:
            ig.get_dot( style=ancestors['style'] ).render(join(out_dir, graph1), view=False)
        start = time() 

        ## retain only predicates that are ancestors of the goal
        gg = InfluenceGraph(dic = ancestors)
        gg.mark_start_finish(goals, init)
        time_spent += ( time() - start )
        if RENDER_GRAPH:
            gg.get_dot().render(join(out_dir, graph2), view=False)

        ## from the predicate that, when removed, separate the graph
        point, islands, sep_pdf, comp_time = gg.find_articulation_point(out_dir)
        pdfs.append(sep_pdf)
        time_spent += comp_time
        start = time() 

        ## generate a set of sequences of two new dmn files 
        tasks = self.reduce_dmn( domain_file, problem_file, 
            dmn_json, obj_json, point, islands, gg, goals, init, expdir )
        time_spent += ( time() - start )

        if RENDER_GRAPH:
            merge_pdf(pdfs, join(out_dir, 'graphs.pdf'))

        return tasks, time_spent


    def reduce_dmn( self, domain_file, problem_file, dmn_json, obj_json, point, islands, gg, goals, init_preds, expdir, n_trials=12, verbose=False ):

        DEBUG = self.DEBUG
        task = (domain_file, problem_file)

        obj_json = json.load(open(obj_json, 'r'))
        dmn_json = json.load(open(dmn_json, 'r'))
        goal_preds = list(set( [g[0] for g in goals] ))

        ## propose a grounded goal predicate
        types = dmn_json['predicates'][point]
        # objs = [obj_json['types'][t] for t in types]
        # print(point, objs)
        parents = [n.name for n in gg.nodes[point].parents]
        children = [n.name for n in gg.nodes[point].children]


        for name, island in islands.items():
            IS_PRE = False
            IS_EFF = False
            HAS_GOAL = False
            if '+' in name:
                names = name.split('+') 
            else:
                names = [name]

            for n in names:
                if n in parents and not IS_PRE: 
                    IS_PRE = True
                if n in children and not IS_EFF: 
                    IS_EFF = True
            found_goals = [p for p in goal_preds if p in island['nodes_pred']]
            found_init = [p for p in init_preds if p in island['nodes_pred']]
            if len(found_goals) > 0: HAS_GOAL = True
            if len(found_init) > 0: HAS_INIT = True
            
            if verbose: 
                print(f'\n\n\n   {name}  |  IS_PRE = {IS_PRE}, IS_EFF = {IS_EFF}, HAS_GOAL: {found_goals}, HAS_INIT: {found_init}')
                for k in ['nodes_pred', 'nodes_op', 'nodes_ax']:
                    print('\n      ', k)
                    print(island[k])
                    print('-------------------')

            if IS_PRE and HAS_INIT and not HAS_GOAL:
                dmn_1 = name
                dmn_2 = [n for n in islands.keys() if n != name][0]
                if verbose: print(f'dmn_1 = {dmn_1} , dmn_2 = {dmn_2}')
                objects = self.find_obj(obj_json, dmn_json, types, island['nodes_pred'], DEBUG=DEBUG)
                for k in range(n_trials):
                    self.propose_subgoal(point, objects, task, DEBUG=DEBUG )
                break

        self.proposed_subgoals[task].remove(None)
        if verbose or self.verbose: 
            print(f'\n  {len(self.proposed_subgoals[task])} subgoals sampled by SDBIG: {self.proposed_subgoals[task]}')
            print(f'\n   ... using subgoal: {self.proposed_subgoals[task][0]}')

        ## return a set of sequences of two sub-problems
        tasks = []
        expdir = join(expdir, 'sdbig')
        for i in range(len(self.proposed_subgoals[task])):

            prefix = f'sdbig_trial{i+1}'
            subgoal = self.proposed_subgoals[task][i]
            island_1 = islands[dmn_1]
            island_2 = islands[dmn_2]
            dmn_file_1 = join(expdir, f'{prefix}_dmn1.pddl')
            prb_file_1 = join(expdir, f'{prefix}_prb1.pddl')
            dmn_file_2 = join(expdir, f'{prefix}_dmn2.pddl')
            prb_file_2 = join(expdir, f'{prefix}_prb2.pddl')

            ## dmn_1 has the original types and preds, with op and ax in island_1
            self.reduce_op(domain_file, dmn_json, dmn_file_1, island_1['nodes_op'], island_1['nodes_ax'])

            ## prb_1 has the original objs and init, with the goal of sugboal
            self.reduce_goal(problem_file, prb_file_1, subgoal)

            ## dmn_2 has the original types and preds, with op and ax in island_2
            self.reduce_op(domain_file, dmn_json, dmn_file_2, island_2['nodes_op'], island_2['nodes_ax'])

            ## prb_2 has the original objs and goal, but init + the goal of sugboal
            self.add_init(problem_file, prb_file_2, subgoal)

            tasks.append([(dmn_file_2, prb_file_2), (dmn_file_1, prb_file_1)])

        self.proposed_tasks[(domain_file, problem_file)] = tasks[1:]
        return tasks[0] ## [(domain_file, problem_file)]


    def get_proposed_task(self, task):
        proposed = self.proposed_tasks[task][0]
        if self.verbose:
            i = len(self.proposed_subgoals[task]) - len(self.proposed_tasks[task])
            print(f'\n   ... using subgoal: {self.proposed_subgoals[task][i]}')
        self.proposed_tasks[task] = self.proposed_tasks[task][1:]
        return proposed


    def find_obj(self, obj_json, dmn_json, types, nodes_pred, verbose=False, DEBUG=False):

        objects = {}
        appeared = []
        for pred, lst in obj_json['init'].items():
            if pred in nodes_pred:
                for objs in lst:
                    appeared.extend(objs)

        appeared = list(set(appeared))
        
        for typ in types:
            types = [typ]
            if typ in dmn_json['type_offsprings']:
                types.extend(dmn_json['type_offsprings'][typ])

            all_obj = []
            for ty in types:
                if ty in obj_json['types']:
                    all_obj.extend(obj_json['types'][ty])
                
            appeared_obj = [o for o in all_obj if o in appeared]
            if verbose:
                print(typ)
                print(len(all_obj), all_obj)
                print(len(appeared_obj), appeared_obj)

            if DEBUG and 'veggies1' in appeared_obj: 
                appeared_obj = ['veggies1', 'egg1'] ## Hack for testing

            objects[typ] = {'possible': all_obj, 'appeared': appeared_obj}

        return objects

    def propose_subgoal(self, point, objects, task, DEBUG=False):
        """ randomly sample a goal that hasn't been tried """

        goal_literal = None
        while goal_literal in self.proposed_subgoals[task] and not (DEBUG and goal_literal != None):
            goal_literal = f"( {point} "
            for typ, objs in objects.items():
                if len(objs['possible']) > 5:
                    goal_literal += random.choice(objs['appeared']) + ' '
                else:
                    goal_literal += random.choice(objs['possible']) + ' '
            goal_literal += ')'
            
        self.proposed_subgoals[task].append(goal_literal)

        return goal_literal

    def reduce_op(self, dmn_file, dmn_json, new_dmn_file, ops, axioms):

        new_lines = []
        START = False
        for line in open(dmn_file, 'r').readlines():
            if ':action ' in line: break
            new_lines.append(line)

        for op in ops:
            new_lines.append(dmn_json['operators'][op]['lines'])
        
        for ax in axioms:
            new_lines.append(dmn_json['axioms'][ax]['lines'])

        new_lines.append(')\n')

        with open(new_dmn_file, "w") as f:
            f.writelines(new_lines)

    def reduce_goal(self, prb_file, new_prb_file, subgoal):

        new_lines = []
        START = False
        for line in open(prb_file, 'r').readlines():
            if ':goal' in line: 
                START = True
                new_lines.append(f'  (:goal\n    {subgoal}; added subgoal\n  )\n\n')
            if ':metric ' in line: 
                START = False
            if not START: 
                new_lines.append(line)

        with open(new_prb_file, "w") as f:
            f.writelines(new_lines)

    def add_init(self, prb_file, new_prb_file, subgoal):

        new_lines = []
        START = False
        for line in open(prb_file, 'r').readlines():

            if ':init' in line: START = True
            elif ':goal' in line: START = False

            end = (count_char(line, ')') == 1) and (count_char(line, '(') == 0)
            if START and end:
                line = f'    {subgoal} ; added init\n' + line
            
            new_lines.append(line)

        with open(new_prb_file, "w") as f:
            f.writelines(new_lines)


