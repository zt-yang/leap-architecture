""" Example interface for HPN-like pre-strategists that breaks down a task into sub-tasks
"""

import abc
import json
from time import time
from os.path import  join
from os import listdir, mkdir
from.strategist import PreStrategist

from .influence_graph import InfluenceGraph
from .utils import get_goals, get_init, merge_pdf

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

    def __call__(self, domain_file, problem_file, expdir, RENDER_GRAPH=True):
        """ Takes in a PDDL domain and problem file. 
            Return the reduced domains and corresponding sub-problems
        """

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

        ## generate two new dmn files 
        tasks = self.reduce_dmn( domain_file, problem_file, 
            dmn_json, obj_json, point, islands, gg, goals, init )
        time_spent += ( time() - start )

        if RENDER_GRAPH:
            merge_pdf(pdfs, join(out_dir, 'graphs.pdf'))

        return tasks, time_spent


    def reduce_dmn( self, domain_file, problem_file, dmn_json, obj_json, point, islands, gg, goals, init_preds ):

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
            
            print(f'\n\n\n   {name}  |  IS_PRE = {IS_PRE}, IS_EFF = {IS_EFF}, HAS_GOAL: {found_goals}, HAS_INIT: {found_init}')

            for k in ['nodes_pred', 'nodes_op', 'nodes_ax']:
                print('\n      ', k)
                print(island[k])
                print('-------------------')


            if IS_PRE and HAS_INIT:
                params = self.find_obj(obj_json, types, island['nodes_pred'])
            break

        return [(domain_file, problem_file)]

    def find_obj(self, obj_json, types, nodes_pred):

        appeared = []
        for pred, lst in obj_json['init'].items():
            if pred in nodes_pred:
                for objs in lst:
                    appeared.extend(objs)

        appeared = list(set(appeared))
        print('appeared', appeared)
        
        for typ in types:
            if typ in obj_json['types']:
                all_obj = obj_json['types'][typ]
                appeared_obj = [o for o in all_obj if o in appeared]
                print(typ)
                print(len(all_obj), all_obj)
                print(len(appeared_obj), appeared_obj)
