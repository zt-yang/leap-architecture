import json
import graphviz
import copy
import os
import operator
from os import listdir
from os.path import join
from tqdm import tqdm
from time import time

from .utils import get_goals, get_init, merge_pdf

## colors:   https://www.graphviz.org/doc/info/colors.html


class Node:
    
    def __init__(self, name):
        self.name = name
        self.parents = []
        self.children = []

        
class InfluenceGraph:
    
    def __init__(self, dmn_json=None, include_type=False, dic=None, style=None):
        
        self.nodes_op = []
        self.nodes_ax = []
        self.nodes_pred = []
        self.edges = []
        
        self.nodes_type = []
        self.nodes_obj = []
        
        self.include_type = include_type
        if dmn_json != None:
            self.init_from_json(dmn_json)
            
        elif dic != None:
            self.init_from_dict(dic)
            
        self.reset_graph()
        self.reset_style(style)
        
        
    def init_style(self, ele):
        """ return the default style of an element """
        
        default_pred = {'shape':'ellipse', 'style':'filled', 'fillcolor':'pink', 'color':'', 'penwidth':1}
        default_pred_neg = {'shape':'ellipse', 'style':'filled', 'fillcolor':'lightgrey', 'color':'', 'penwidth':1}
        default_op = {'shape':'box', 'style':'', 'fillcolor':'', 'color':'', 'penwidth':1}
        default_ax = {'shape':'diamond', 'style':'', 'fillcolor':'', 'color':'', 'penwidth':1}
        default_edge = {'color':'', 'penwidth':1}
        
        default_type = {'shape':'triangle', 'style':'filled', 'fillcolor':'mediumaquamarine', 'color':'mediumaquamarine', 'penwidth':1}
        default_obj = {'shape':'invtriangle', 'style':'filled', 'fillcolor':'coral', 'color':'coral', 'penwidth':1}
        default_type_edge = {'color':'mediumaquamarine', 'penwidth':1}
        default_obj_edge = {'color':'coral', 'penwidth':1}
        
        if not isinstance(ele, tuple):
            if ele in self.nodes_type:
                return copy.deepcopy(default_type)

            if ele in self.nodes_obj:
                return copy.deepcopy(default_obj)

            if ele in self.nodes_pred:
                if '!' in ele: return copy.deepcopy(default_pred_neg)
                else: return copy.deepcopy(default_pred)

            if ele in self.nodes_op: 
                return copy.deepcopy(default_op)

            if ele in self.nodes_ax: 
                return copy.deepcopy(default_ax)
        
        else:
            
            fr, to = ele
            if fr in self.nodes_type:
                return copy.deepcopy(default_type_edge)
            
            elif fr in self.nodes_obj:
                return copy.deepcopy(default_obj_edge)
            
            else:
                return copy.deepcopy(default_edge)
            
    def reset_style(self, style=None):
        """ assign default style to all nodes and edges """
        
        s = {} 
        
        ## style of nodes and edges
        for n in self.nodes_type + self.nodes_obj + self.nodes_pred + self.nodes_op + self.nodes_ax:
            s[n] = self.init_style(n)
        
        for fr, to in self.edges:
            s[ str( (fr, to) ) ] = self.init_style( (fr, to) )
            
            
        ## external style
        if style != None:
            for ele, sty in style.items():
                s[ele].update(sty)
        
        self.style = s
            
            
    def reset_graph(self):
        """ generate the graph before any search operation """
        
        self.nodes = {} ## dictionary of Node object
        for n in self.nodes_pred + self.nodes_op + self.nodes_ax:
            self.nodes[n] = Node(n)
            
        if self.include_type:
            for n in self.nodes_type:
                self.nodes[n] = Node(n)
            for n in self.nodes_obj:
                self.nodes[n] = Node(n)
        
        for fr, to in self.edges:
            use = fr not in self.nodes_type and fr not in self.nodes_obj
            if self.include_type or use:
                self.nodes[fr].children.append(self.nodes[to])
                self.nodes[to].parents.append(self.nodes[fr])
            
            
    def init_from_dict(self, dic):
        
        self.nodes_op = dic['nodes_op']
        self.nodes_ax = dic['nodes_ax']
        self.nodes_pred = dic['nodes_pred']
        self.edges = dic['edges']
        
        if self.include_type:
            
            if 'nodes_type' in dic:
                self.nodes_type = dic['nodes_type']
            
            if 'nodes_obj' in dic:
                self.nodes_obj = dic['nodes_obj']

        
    def init_from_json(self, dmn_json):
        
        domain = json.load(open(dmn_json, 'r'))
        self.domain = domain
            
        ## all types
        if self.include_type:
            for typ in domain['type_parents']:
                self.nodes_type.append(typ)
        
        ## all predicates
        for pred in domain['predicates']:
            self.nodes_pred.append(pred)
            self.nodes_pred.append('!'+pred)
        
        ## all operators
        for head, op in domain['operators'].items():
            self.nodes_op.append(head)
            
            for p in op['pre']:
                self.edges.append( (p[0], head) )
                if self.include_type:
                    for typ in p[1:]:
                        if typ not in op['params']:
                            if typ not in self.nodes_obj:
                                self.nodes_obj.append(typ)
                            self.edges.append( (typ, head) )
                        else:
                            self.edges.append( (op['params'][typ], head) )
            
            for p in op['eff']:
                self.edges.append( (head, p[0]) )
                
        ## all axioms
        for head, body in domain['axioms'].items():
            head = head.replace('+','')
            if head not in self.nodes_ax:
                self.nodes_ax.append(head)
            for pre in body['pre']:
                self.edges.append( (pre, head) )
        
        self.edges = list(set(self.edges))
        self.reset_style()
        
           
    def get_dot(self, hide_unused_pred = True, style=None):
        
        dot = graphviz.Digraph(comment='Influence Graph', engine='neato')
        dot.attr(size='60,60')
        dot.attr(overlap='false')
        dot.attr(fontsize='3')
        
        ## use the default style updated by the given style
        s = copy.deepcopy(self.style)
        if style != None:
            for ele, sty in style.items():
                if ele not in s: s[ele] = {}
                s[ele].update(sty)
            
        ## fine the nodes
        nodes = self.nodes_pred + self.nodes_op
        if hide_unused_pred: 
            nodes = set([item for t in self.edges for item in t])
        
        ## draw the nodes
        for n in nodes:
            if n in self.nodes:  
                dot.node(n, shape=s[n]['shape'], style=s[n]['style'], 
                    fillcolor=s[n]['fillcolor'], color=s[n]['color'], 
                    penwidth=str(s[n]['penwidth']))
        
        ## draw the edges
        for e in self.edges:
            if e[0] in self.nodes:  
                dot.edge(e[0], e[1], constraint='false', 
                    color=s[str(e)]['color'], 
                    penwidth=str(s[str(e)]['penwidth']))
        
        return dot
    
    def get_graph_from_visited(self, visited, edges):
        return {'nodes_op': [n for n in self.nodes_op if n in visited], 
                'nodes_ax': [n for n in self.nodes_ax if n in visited], 
                'nodes_pred': [n for n in self.nodes_pred if n in visited],
                'nodes_type': [n for n in self.nodes_type if n in visited], 
                'nodes_obj': [n for n in self.nodes_obj if n in visited], 
                'edges': [e for e in self.edges if e in edges] }
    
    
    def find_ancestors(self, starts, color='steelblue2'):
        
        visited = []
        edges = []
        queue = [self.nodes[s] for s in starts]
        
        while len(queue) > 0:
            top = queue[0]
            visited.append(top.name)
            queue.remove(top)
            for p in top.parents:
                if p.name not in self.nodes: continue
                edges.append((p.name, top.name))
                if p.name not in visited:
                    queue.append(p)
        
        s = copy.deepcopy(self.style)
        for n in visited:
            if n in self.nodes_type + self.nodes_obj: continue
            s[n] = {'color':color, 'penwidth':3}
            if n in starts:
                s[n]['shape'] = 'doubleoctagon'
                
        for e in edges:
            if e[0] in self.nodes_type + self.nodes_obj: continue
            s[str(e)] = {'color':color, 'penwidth':3}
            
        ancestors = self.get_graph_from_visited(visited, edges)
        ancestors['style'] = s
            
        return ancestors
    
    
    def find_offsprings(self, starts, color='lightgreen'):
        
        visited = []
        edges = []
        queue = [self.nodes[s] for s in starts]
        
        while len(queue) > 0:
            top = queue[0]
            visited.append(top.name)
            queue.remove(top)
            for p in top.children:
                if p.name not in self.nodes: continue
                edges.append((top.name, p.name))
                if p.name not in visited:
                    queue.append(p)
        
        s = copy.deepcopy(self.style)
        for n in visited:
            if n in self.nodes_type + self.nodes_obj: continue
            s[n] = {'color':color, 'penwidth':3}
            if n in starts:
                s[n]['shape'] = 'doubleoctagon'
                
        for e in edges:
            if e[0] in self.nodes_type + self.nodes_obj: continue
            s[str(e)] = {'color':color, 'penwidth':3}
        
        offsprings = self.get_graph_from_visited(visited, edges)
        offsprings['style'] = s
            
        return offsprings
    
    
    def find_family(self, starts, color='gold'):
        
        visited = []
        edges = []
        queue = [self.nodes[s] for s in starts]
        
        while len(queue) > 0:
            top = queue[0]
            visited.append(top.name)
            queue.remove(top)
            
            for p in top.children:
                if p.name not in self.nodes: continue
                edges.append((top.name, p.name))
                if p.name not in visited:
                    queue.append(p)
                    
            for p in top.parents:
                if p.name not in self.nodes: continue
                edges.append((p.name, top.name))
                if p.name not in visited:
                    queue.append(p)
        
        s = copy.deepcopy(self.style)
        for n in visited:
            if n in self.nodes_type + self.nodes_obj: continue
            s[n] = {'color':color, 'penwidth':3}
            if n in starts:
                s[n]['shape'] = 'doubleoctagon'
                
        for e in edges:
            if e[0] in self.nodes_type + self.nodes_obj: continue
            s[str(e)] = {'color':color, 'penwidth':3}
        
        family = self.get_graph_from_visited(visited, edges)
        family['style'] = s
        family['visited'] = visited
        
#         print(f"      nodes_op: {len(family['nodes_op'])}   |   nodes_pred: {len(family['nodes_pred'])}   |  edges: {len(family['edges'])}")
        
        return family

    
    def mark_start_finish(self, goals, inits, style=None):
        
        if style == None: style = self.style
        
        for goal in goals:
            pred = goal[0]
            style[pred]['shape'] = 'doubleoctagon'
            
            for obj in goal[1:]:
                
                if obj not in self.nodes_obj:
                    self.nodes_obj.append(obj)
                    self.edges.append( (obj, pred) )
                    
                style[obj] = self.init_style(obj)
                style[ str( (obj, pred) ) ] = self.init_style( (obj, pred) )
                    
            
        for init in inits:
            if init in style:
                style[init]['shape'] = 'doublecircle'
                
        return style

    
    def find_irreversible_types(self, dmn_json, verbose=False):
        """ find predicates 
                whose negative forms serve as preconditions 
                and can be caused to become negative,
            but whose positive forms didn't appear in any effects """
        
        predicates = json.load(open(dmn_json, 'r'))['predicates']
        
        ## pred: op
        neg_pre = {}  
        neg_eff = {} 
        pos_pre = {} 
        pos_eff = {}  
        for fr, to in self.edges:
            if fr in self.nodes_pred and '!' in fr:
                neg_pre[fr.replace('!', '')] = to
            if fr in self.nodes_pred and '!' not in fr:
                pos_pre[fr.replace('!', '')] = to
            if to in self.nodes_pred and '!' in to:
                neg_eff[fr.replace('!', '')] = to
            if to in self.nodes_pred and '!' not in to:
                pos_eff[fr.replace('!', '')] = to
                
        irreversible_pred = {k:v for k,v in neg_pre.items() if k in neg_eff and k not in pos_eff} 
        irreversible_pred.update({k:v for k,v in pos_pre.items() if k in pos_eff and k not in neg_eff} )
        
        irreversible_pred_types = []
        for k, v in irreversible_pred.items():
            if verbose: print(f'pred: {k}, opt: {v}, types: {predicates[k]}')
            irreversible_pred_types.extend( predicates[k] )
        
        return list(set(irreversible_pred_types))

    
    
    def find_islands_by_bridge(self, start, verbose=False):
        """ find the one node, which separate the graph into two when removed 
            return the node the size of subgraphs """
        
        def myprint(text):
            if verbose: print(text)
        
        start_node = self.nodes[start]
        self.nodes.pop(start)
        
        colors = [ 'gold', 'aquamarine3', 'sienna', 'navy', 'palevioletred', 
                  'tan', 'steelblue2', 'chocolate1', 'cyan4', 'maroon', 
                  'mediumpurple', 'lightsalmon' ]
        islands = {}
        styles = {}
        merged_style = {}
        
        myprint(f'      nodes_op: {len(self.nodes_op)}   |  nodes_pred: {len(self.nodes_pred)}   |  edges: {len(self.edges)}')
        
        nodes = []
        for node in start_node.parents + start_node.children:
            name = node.name
            label = None
            if node in start_node.parents: label = 'parent'
            if node in start_node.children: label = 'children'
            if node in start_node.parents and start_node.children: label = 'both'
            myprint(f'   {label}: {name}')
            island = self.find_family([name], color=colors[0])
            
            found_same = False
            for k, il in islands.items():
                island['edges'].sort()
                il['edges'].sort()
                if island['edges'] == il['edges']:
                    name = f'{k}+{name}'
                    islands[name] = il
                    styles[name] = il['style']
                    islands.pop(k)
                    styles.pop(k)
                    found_same = True
                    break
                    
            if not found_same:
                islands[name] = island
                styles[name] = island['style']
                s = {k:v for k,v in island['style'].items() if k in island['visited']+island['edges']}
                merged_style.update( s )
                colors.remove(colors[0])
                
        styles['merged'] = merged_style
        self.nodes[start] = start_node
        return islands, merged_style


    def find_articulation_point(self, out_dir, verbose=False, RENDER_GRAPH=True):

        start = time()

        nodes = list(set([item for t in self.edges for item in t]))
        g1 = Graph(len(nodes))
        for fr, to in self.edges:
            g1.addEdge(nodes.index(fr), nodes.index(to))

        AP = [nodes[i] for i in g1.AP()]
        nodes = [n for n in AP if n in self.nodes_pred]
        if verbose:print(nodes)

        all_islands = {}
        sizes = {}
        styles = {}
        for i in range(len(nodes)): 
            islands, style = self.find_islands_by_bridge(nodes[i])
            if verbose:
                print(f'\n\n..... {i}/{len(nodes)} [{nodes[i]}]')
                print('..... ', list(islands.keys()))
            
            if len(islands) > 1:
                all_islands[nodes[i]] = islands
                sizes[nodes[i]] = min([len(island['edges']) for island in islands.values()])
                styles[nodes[i]] = style
                
        ## choose the point that separate the graph the most
        found = dict( sorted(sizes.items(), key=operator.itemgetter(1),reverse=True))
        found = list(found.keys())[0]
        file_name = join(out_dir, f'3 sep by {found}.gv')
        comp_time = time() - start
        
        if RENDER_GRAPH:
            self.get_dot( style=styles[found] ).render(file_name, view=False)
        
        return found, all_islands[found], file_name+'.pdf', comp_time
    

# by Neelam Yadav, find articulation points in an undirected graph
# https://www.geeksforgeeks.org/articulation-points-or-cut-vertices-in-a-graph/

from collections import defaultdict

# This class represents an undirected graph
# using adjacency list representation
class Graph:

    def __init__(self, vertices):
        self.V = vertices # No. of vertices
        self.graph = defaultdict(list) # default dictionary to store graph
        self.Time = 0

    # function to add an edge to graph
    def addEdge(self, u, v):
        self.graph[u].append(v)
        self.graph[v].append(u)

    '''A recursive function that find articulation points
    using DFS traversal
    u --> The vertex to be visited next
    visited[] --> keeps tract of visited vertices
    disc[] --> Stores discovery times of visited vertices
    parent[] --> Stores parent vertices in DFS tree
    ap[] --> Store articulation points'''
    def APUtil(self, u, visited, ap, parent, low, disc):

        # Count of children in current node
        children = 0

        # Mark the current node as visited and print it
        visited[u]= True

        # Initialize discovery time and low value
        disc[u] = self.Time
        low[u] = self.Time
        self.Time += 1

        # Recur for all the vertices adjacent to this vertex
        for v in self.graph[u]:
            # If v is not visited yet, then make it a child of u
            # in DFS tree and recur for it
            if visited[v] == False :
                parent[v] = u
                children += 1
                self.APUtil(v, visited, ap, parent, low, disc)

                # Check if the subtree rooted with v has a connection to
                # one of the ancestors of u
                low[u] = min(low[u], low[v])

                # u is an articulation point in following cases
                # (1) u is root of DFS tree and has two or more chilren.
                if parent[u] == -1 and children > 1:
                    ap[u] = True

                #(2) If u is not root and low value of one of its child is more
                # than discovery value of u.
                if parent[u] != -1 and low[v] >= disc[u]:
                    ap[u] = True    
                    
                # Update low value of u for parent function calls   
            elif v != parent[u]:
                low[u] = min(low[u], disc[v])


    # The function to do DFS traversal. It uses recursive APUtil()
    def AP(self):
        
        ans = []

        # Mark all the vertices as not visited
        # and Initialize parent and visited,
        # and ap(articulation point) arrays
        visited = [False] * (self.V)
        disc = [float("Inf")] * (self.V)
        low = [float("Inf")] * (self.V)
        parent = [-1] * (self.V)
        ap = [False] * (self.V) # To store articulation points

        # Call the recursive helper function
        # to find articulation points
        # in DFS tree rooted with vertex 'i'
        for i in range(self.V):
            if visited[i] == False:
                self.APUtil(i, visited, ap, parent, low, disc)

        for index, value in enumerate (ap):
            if value == True: 
                ans.append(index)
        
        return ans


def test_ignore_obj():

    path = join('experiments', 'omelette_objects', 
                '0907-175831-dmn=kitchen_1-prb=omelette_5-obj=obj_5-pln=lama_first')

    dmn_json = join(path, 'kitchen_1.json')
    prb_file = join(path, 'omelette_5.pddl')
    obj_file = join(path, 'obj_5.json')

    ## speicify output files
    graph0 = '0 domain.gv'
    graph1 = '1 goals.gv'
    graph2 = '2 goals only.gv'
    pdfs = [f"{join('outputs', s)}.pdf" for s in [graph0, graph1, graph2]]

    ## given a domain, plot all predicates used by operators
    ig = InfluenceGraph(dmn_json, include_type=True)
    ig.get_dot().render(join('outputs', graph0), view=False)

    ## given a problem, plot all init and goal predicates
    goals, goal_preds = get_goals(prb_file)
    init = get_init(obj_file)
    ancestors = ig.find_ancestors(starts=goal_preds)
    ancestors['style'] = ig.mark_start_finish(goals, init, ancestors['style'])
    ig.get_dot( style=ancestors['style'] ).render(join('outputs', graph1), view=False)

    ## retain only predicates that are ancestors of the goal
    gg = InfluenceGraph(dic = ancestors, include_type=True)
    gg.mark_start_finish(goals, init)
    gg.get_dot().render(join('outputs', graph2), view=False)

    ## from those predicates that are negated by some operator and can' be reversed
    irreversible_types = gg.find_irreversible_types(dmn_json)
    print(irreversible_types)

    merge_pdf(pdfs, 'graphs.pdf')

  
if __name__ == "__main__":      
    test_ignore_obj()


    