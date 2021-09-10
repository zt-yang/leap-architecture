""" Example interface for PLOI-like pre-strategists that modifies problem files
"""

import abc
import json
from time import time
from os.path import  join, isfile, isdir
from os import listdir, mkdir
from.strategist import PreStrategist

from .influence_graph import InfluenceGraph
from .utils import get_goals, get_init, merge_pdf

import sys, os
sys.path.insert(0, os.path.abspath('..'))
from cogmen.utils import get_pred, empty

class PLOI(PreStrategist):
    """ Reduces the universe/ number of objects of a problem
    """

    name = 'PLOI'

    def __call__(self, domain_file, problem_file, timeout=10):
        """ Takes in a PDDL domain and problem file. 
            Returns a set of sequence of subproblems.
                [ [ (domain.pddl, problem.pddl) ] ]
                e.g. PLOI may sample multiple minimum object sets 
                    with incremental importance score threshold
        """

        ## objects = get_objects()
        ## make the problem file / return the objects

        raise NotImplementedError("Override me!")



class IOBIG(PreStrategist):
    """ Ignoring Object Based on Influence Graph """

    name = 'IOBIG'
    RENDER_GRAPH = True

    def __call__(self, domain_file, problem_file, expdir):
        """ Takes in a PDDL domain and problem file. 
            Return one task tuple - original domain and one reduced problem (i.e. :objects :init), along with computational time
        """

        RENDER_GRAPH = self.RENDER_GRAPH
        time_spent = 0 ## exclude the time for rendering graphs
        start = time()

        out_dir = join(expdir, 'iobig')
        if not isdir(out_dir):
            mkdir(out_dir)

        dmn_json = domain_file.replace('.pddl', '.json')
        if not isfile(dmn_json): ## in case used together with SDBIG
            dmn_json = self.task_original[0].replace('.pddl', '.json')
        prb_pddl = problem_file
        obj_json = [join(expdir,f) for f in listdir(expdir) if 'obj_' in f and '.json' in f][0]

        ## speicify output files
        graph0 = '0 domain.gv'
        graph1 = '1 goals.gv'
        graph2 = '2 goals only.gv'
        pdfs = [f"{join(out_dir, s)}.pdf" for s in [graph0, graph1, graph2]]

        ## given a domain, plot all predicates used by operators
        ig = InfluenceGraph(dmn_json, include_type=True)
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
        gg = InfluenceGraph(dic = ancestors, include_type=True)
        gg.mark_start_finish(goals, init)
        time_spent += ( time() - start )
        if RENDER_GRAPH:
            gg.get_dot().render(join(out_dir, graph2), view=False)
        start = time() 

        ## from those predicates that are negated by some operator and can' be reversed
        irreversible_types = gg.find_irreversible_types(dmn_json)

        new_prob_pddl = prb_pddl.replace('.pddl', '_iobig.pddl')
        self.reduce_obj( prb_pddl, obj_json, new_prob_pddl=new_prob_pddl, 
            except_types=irreversible_types, except_objs=gg.nodes_obj )

        time_spent += ( time() - start )
        if RENDER_GRAPH:
            name = join(out_dir, 'graphs.pdf')
            while isfile(name):
                name = name.replace('.pdf', '+.pdf')
            merge_pdf(pdfs, name)

        return [(domain_file, new_prob_pddl)], time_spent


    def reduce_obj( self, prb_pddl, obj_json, new_prob_pddl, except_types, except_objs ):
        """ generate a new problem file with reduced obj and init """

        obj_json = json.load(open(obj_json, 'r'))
        except_objs_dict = {obj_json['obj_types'][o]:o for o in except_objs}
        ignore_objects = []
        write_objects = {}
        obj_text = ''

        ## go through the objects in the world of each type
        for typ, objs in obj_json['types'].items():
            if typ in except_types: 
                write_objects[typ] = objs
            elif typ in except_objs_dict:
                ignore_objects.extend( [o for o in objs if o not in except_objs] )
                write_objects[typ] = [o for o in objs if o in except_objs]
            else:
                ignore_objects.extend( objs[1:] )
                write_objects[typ] = [objs[0]]


        ## go through the init predicate that the except_objs appeared in and add related objs
        preds = []
        for typs, objs in obj_json['objects_by_type'].items():
            for obj, preds in objs.items():
                by_type = {}
                for pred in preds:
                    parts = get_pred(pred).split(' ')
                    if parts[0] not in by_type: 
                        by_type[parts[0]] = []
                    args = parts[1:]
                    args.remove(obj)
                    by_type[parts[0]].append(args)

                for head, parts in by_type.items():
                    if len(parts[0]) == 1 and parts[0][0] in ignore_objects:
                        ignore_objects.remove(parts[0][0])
                        write_objects[obj_json['obj_types'][parts[0][0]]].append(parts[0][0])


        for typ, objs in write_objects.items():
            objs = ' '.join(objs)
            obj_text += f'    {objs} - {typ}\n'


        ## ignore init literal if obj appears in ignore_object
        new_lines = []
        lines = open(prb_pddl, 'r').readlines()
        goals = []
        found = False
        last_empty = False
        for line in lines:
            line = line.replace('( ','(').replace(' )',')')

            if ':objects' in line: 
                found = 'OBJECT'
                line += '\n' + obj_text + '\n  )\n\n'
                new_lines.append(line)
                last_empty = empty(line)

            elif ':init' in line: found = 'INIT'

            elif ':goal' in line: found = False
            
            if found == 'INIT' and '(' in line and ')' in line: 
                delete = False
                parts = line[line.index('(')+1: line.index(')')].split(' ')
                for part in parts[1:]:
                    if part in ignore_objects:
                        delete = True
                if not delete: 
                    new_lines.append(line)
                    last_empty = empty(line)

            elif found != 'OBJECT' and not (empty(line) and last_empty):
                new_lines.append(line)
                last_empty = empty(line)

        with open(new_prob_pddl, "w") as f:
            f.writelines(new_lines)



