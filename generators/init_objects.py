from os.path import join
from time import time
import json

def warning(text):
    print(f'\n[checking consistency] {text}')

def strip(line, sub=' '):
    return line.replace(sub, '')

def empty(line):
    return len(strip(line)) == 0

def is_end(line):
    line = strip(line)
    return len(line) == 1 and len(strip(line, ')')) == 0

def count_char(line, sub):
    return len(line) - len(line.replace(sub, ''))

def is_pred(line):
    """ at most two sets, at least one set of brackets """
    lbraket = count_char(line, '(')
    rbraket = count_char(line, ')')
    return (lbraket == rbraket == 2) or (lbraket == rbraket == 4)

def get_pred(line):
    line = line[line.rfind('(')+1:line.index(')')]
    if line[0] == ' ': line = line[1:]
    if line[-1] == ' ': line = line[:-1]
    return line

def strip_paren(line): 
    """ remove the outermost sets of brackets """
    return line[line.index('(')+1:line.rfind(')')]

def strip_comment(line):
    while ';' in line: line = line[:line.rfind(';')]
    return line

def check_consistency(dmn_file, prob_file, obj_file=None, verbose=False):
    """ debug 'return non-zero exit status 12 ' by checking:
        1. consistency within domain and obj files
        2. if all obj_types exist in dmn_types 
        3. if all dmn_const exist in obj_objects 
        4. if all prob_obj exist in obj_objects
        5. if domain name in prob_file is the same as that in domain_file
    """
    start = time()

    if verbose: print(f'\n... start checking consistency of {dmn_file}, {prob_file}, {obj_file}')

    ## 1. check consistency within domain and obj files
    types, obj_types, objects = check_objects(obj_file)
    dmn_types, dmn_const, type_ancestors = check_domain(dmn_file)

    ## 2. check if all obj_types exist in dmn_types 
    type_missing = [t for t in types if t not in dmn_types]
    if len(type_missing) > 0:
        warning(f'found type {type_missing} exist in obj but not in domain')

    ## 3. check if all dmn_const exist in obj_objects 
    for const, dmn_typ in dmn_const.items():
        if const not in objects:
            warning(f'found object {const} appeared in domain but not in init')
        else:
            obj_typ = obj_types[const]
            if obj_typ != dmn_typ and obj_typ not in type_ancestors[dmn_typ] and dmn_typ not in type_ancestors[obj_typ]:
                warning(f'found object {const} defined as {obj_typ} but appeared in domain as {dmn_typ}')

    ## 4. check if all prob_obj exist in obj_objects

    ## 5. check if domain name in prob_file is the same as that in domain_file

    if verbose: print(f'... finished checking consistency in {round(time()-start, 4)} sec')

def check_domain(filename):
    """ check if variable names are consistent in PDDL files """
    
    lines_types, lines_predicates, lines_body = merge_domains([filename])
    

    ## map each type to its parent and to all its ancestors
    type_parents = {}  
    for line in list(lines_types.values())[0]:
        if ' - ' in line: 
            sub_typs, typ = line.split(' - ')
            for sub_typ in sub_typs.split(' '):
                if empty(sub_typ): continue
                type_parents[strip(sub_typ)] = typ.replace('\n', '')

    type_ancestors = {}
    for typ, parent in type_parents.items():
        ancestors = [parent]
        while parent in type_parents:
            parent = type_parents[parent]
            ancestors.append(parent)
        type_ancestors[typ] = ancestors


    ## get the types of each param of predicates
    predicates = {}  ## 
    STARTED = None
    for line in list(lines_predicates.values())[0]:
        if '(' in line and ')' in line:
            line = strip_comment(line)
            if empty(line): continue
            line = strip_paren(line)
            line = line.split('?')
            name = strip(line[0]) 
            params = [strip(l.split(' - ')[1]) for l in line[1:]]
            predicates[name] = params


    ## check inside each operator (1) predicates types (2) var names (3) constants
    constants = {}
    operators = {}
    axoims = {}
    START = None
    name = None

    def check_pred(line):
        line = get_pred(line)
        parts = line.split(' ')
        pred = parts[0]
        params = parts[1:]
        for i in range(len(params)):
            param = params[i]
            def_type = predicates[pred][i]

            if '?' in param:
                if param in operators[name]['params']:
                    param_type = operators[name]['params'][param]
                    if def_type != param_type and def_type not in type_ancestors[param_type] and param_type not in type_ancestors[def_type]:
                        warning(f'in operator {name}, predicate ({line}), \n  param {i} is defined to be of type {def_type} \n  but specified here to be of type {param_type}')
                else:
                    warning(f'in operator {name}, unknown var {param}')
            else:
                constants[param] = def_type

        return parts

    for line in list(lines_body.values())[0]:
        line = strip_comment(line).replace('\n','')
        if empty(line): continue
        
        if ':action' in line:
            START = 'ACTION'
            name = strip(line[line.index(':action')+7:])
            operators[name] = {
                'params':{},
                'pre': [],
                'eff': [],
                'cost': 1
            }

        if ':parameters' in line and START == 'ACTION':
            for param in strip_paren(line).split('?'):
                if ' - ' not in param: continue
                var, typ = param.split(' - ')
                var = strip(var)
                if var[0] != '?': var = '?'+var
                operators[name]['params'][var] = strip(typ)

        elif ':precondition' in line and START == 'ACTION':
            START = 'PRE'

        elif ':effect' in line and START == 'PRE':
            START = 'EFF'

        elif ':derived' in line:
            START = 'DER'

        elif START == 'PRE':
            if is_pred(line): 
                operators[name]['pre'].append(check_pred(line))
        
        elif START == 'EFF':
            if 'increase ' in line and 'total-cost' in line:
                operators[name]['cost'] = int(strip(line[line.index(')')+1:line.rfind(')')]))
            elif is_pred(line): 
                operators[name]['eff'].append(check_pred(line))

    with open(join('generators', 'check_domain.json'), 'w') as f:
        json.dump({
            'type_parents': type_parents,
            'type_ancestors': type_ancestors,
            'predicates': predicates,
            'operators': operators,
            }, f, indent=4)

    return type_parents, constants, type_ancestors

def check_objects(filename):
    """ summarize all occurance of object instances in obj PDDL files """
    types = {}  ## list objects of each type
    obj_types = {}  ## map each object to its type
    objects = {}  ## list the initial predicates where each obj exists in
    lines = open(filename, "r+").readlines()

    STARTED = None
    for line in lines:
        line = line.replace('\n', '')
        end = (len(line.replace(' ', '').replace(')', '')) == 0) and (len(line.replace(' ', '')) != 0)

        if ':objects' in line: 
            STARTED = 'OBJECTS'

        elif ':init' in line: 
            STARTED = 'INIT'

        elif STARTED == 'OBJECTS' and not end:

            if ' - ' in line:
                objs, typ = line.split(' - ')
                typ = strip(typ)

                if typ not in types: 
                    types[typ] = []

                for obj in objs.split(' '):
                    obj = strip(obj)
                    if empty(obj): continue
                    objects[obj] = []
                    types[typ].append(obj)
                    obj_types[obj] = typ

        elif STARTED == 'INIT' and not end:
            
            if '(' in line and ')' in line:
                line = line[line.index('(')+1:line.index(')')]
                parts = line.split(' ')
                for arg in parts[1:]:
                    if len(arg.replace(' ','')) == 0: continue
                    predicate = f"({line})"
                    if arg in objects:
                        objects[arg].append(predicate)
                    else:
                        warning(f'Unknown object instance {arg} in {predicate}')

    objects_by_type = {}
    newlines = []
    newlines.append('\n\n')
    for typ, objs in types.items():
        objects_by_type[typ] = {}
        newlines.append(f'\n\ntype = {typ}')
        for obj in objs:
            objects_by_type[typ][obj] = [len(objects[obj])]
            newlines.append(f'\n   obj = {obj} ({len(objects[obj])})')
            for pred in objects[obj]:
                objects_by_type[typ][obj].append(pred)
                newlines.append(f'\n       {pred}')

    with open(join('generators', 'check_objects.json'), 'w') as f:
        json.dump({
            'types': types,
            'obj_types': obj_types,
            'objects_by_type': objects_by_type,
            }, f, indent=4)

    # with open(join('generators', 'check_objects.txt'), "w") as f:
    #     f.writelines(newlines)

    return types, obj_types, objects

def get_defined_objects():
    """ create PDDL file for objects and types from Markdown drafts """

    levels = {'#': 0, '##': 1, '###': 2, '-': 3, '\t-': 4, '\t\t-': 5, '\t\t\t-': 6}

    last_parent = {v: '' for v in levels.values()}
    types = {}
    objects = {}
    comments = {}

    for line in open(join('..', 'generators', 'objects.md'), "r+").readlines():
        if line != '\n':
            level = line[:line.index(' ')]
            text = line.replace(level+' ', '').replace('\n', '')
            level = levels[level]
            print(level, text)

            if level != 0:
                last_level = level - 1
                last_text = last_parent[last_level]

                if '~~' not in text:
                    temp = types
                    if '[' in text:
                        temp = objects
                        text = text.replace('[ ','').replace(' ]','').replace('[','').replace(']','')
                        
                    if last_text not in temp:
                        temp[last_text] = []
                    temp[last_text].append(text)

                else:
                    comment = " ;" + text.replace('~~','')
                    comments[last_text] = comment

            last_parent[level] = text

    lines_types = ['  (:types']
    lines_objects = ['  (:objects']
    for temp, lines in [(types, lines_types), (objects, lines_objects)]:
        for k, v in temp.items():
            v = ' '.join(v)
            line = f"{v} - {k}"
            if k in comments:
                line += comments[k]
            lines.append('    '+line)
        lines.append('  )')
        lines = [l+'\n' for l in lines]
        print(lines)
        print()
    return lines_types, lines_objects

def replace_lines(filename, startkey, endkey, text, newfilename):
    newlines = []
    lines = open(filename, "r+").readlines()
    STARTED = False
    FINISHED = False
    for line in lines:
        if not STARTED and startkey in line:
            STARTED = True
            for l in text:
                newlines.append(l)

        if STARTED and not FINISHED: 
            if endkey in line:
                if not "don't delete this line" in line:
                    newlines.append('\n\n')
                newlines.append(line)
                FINISHED = True
        else:
            newlines.append(line)

    with open(newfilename, "w") as f:
        f.writelines(newlines)

def comment_line(filename, startkey, findtext, newfilename):
    newlines = []
    lines = open(filename, "r+").readlines()
    STARTED = False
    FOUND = False
    for line in lines:
        if not STARTED and startkey in line:
            STARTED = True

        if STARTED and findtext in line: 
            newlines.append(f';{line}')
        else:
            newlines.append(line)

    with open(newfilename, "w") as f:
        f.writelines(newlines)

def get_action_by_name(new_action_name, action_pddl):
    definition = []
    lines = open(action_pddl, "r+").readlines()
    STARTED = False
    for line in lines:
        if not STARTED and f':action {new_action_name}' in line:
            STARTED = True
            definition.append(line)

        elif STARTED:
            if ':action' in line: 
                definition = definition[:-1]
                break
            definition.append(line)
            
    return definition

def merge_objects(found_objects, expdir):
    names = [d[d.rfind('/')+1:d.rfind('.')] for d in found_objects]
    name = '+'.join(names)
    newfilename = join(expdir, name+'.pddl')

    ## storing relevant lines if different domains
    lines_objs = {n:[] for n in names}
    lines_inits = {n:[] for n in names} 

    for i in range(len(found_objects)):
        n = names[i]
        lines = open(found_objects[i], "r+").readlines()

        STARTED = None
        for line in lines:

            empty = (len(line.replace('\n', '').replace(' ', '')) == 0)
            end = (len(line.replace(' ', '').replace('\n', '').replace(')', '')) == 0) and not empty

            if ':objects' in line: 
                STARTED = 'OBJECTS'

            elif ':init' in line: 
                STARTED = 'INIT'

            elif STARTED == 'OBJECTS' and not end:

                exist = False ## may decide which one to keep
                if not empty:
                    for n2 in names:
                        if n2 != n:
                            if line in lines_objs[n2]:
                                exist = True
                                ## print(f'\n .. found {line} in {n} but it already exist in {n2}')
                
                if not exist:
                    lines_objs[n].append(line)

            elif STARTED == 'INIT' and not end:
                lines_inits[n].append(line)

    new_lines = ['  (:objects\n\n']
    for n in names:
        new_lines.append(f'    ;; ------------------------------\n')
        new_lines.append(f'    ;; --- objects from {n} domain\n')
        new_lines.append(f'    ;; ------------------------------\n')
        new_lines.extend(lines_objs[n])
        new_lines.append('\n')
    new_lines.append('  )\n\n')

    new_lines.append('  (:init\n\n')
    for n in names:
        new_lines.append(f'    ;; ------------------------------\n')
        new_lines.append(f'    ;; --- init from {n} domain\n')
        new_lines.append(f'    ;; ------------------------------\n')
        new_lines.extend(lines_inits[n])
        new_lines.append('\n')
    new_lines.append('  )\n\n')

    with open(newfilename, "w") as f:
        f.writelines(new_lines)

    return newfilename


def merge_domains(found_domains, expdir=None):
    """ merge multiple domain files into one, 
        or return the separated contents if expdir is None """

    names = [d[d.rfind('/')+1:d.rfind('.')] for d in found_domains]
    name = '+'.join(names)

    line_name = 'AND'.join(names)
    line_name = f'(define (domain {line_name})\n'

    ## storing relevant lines if different domains
    lines_reqs = {n:'' for n in names}
    lines_types = {n:[] for n in names} 
    lines_predicates = {n:[] for n in names} 
    lines_body = {n:[] for n in names} 

    for i in range(len(found_domains)):
        n = names[i]
        lines = open(found_domains[i], "r+").readlines()

        STARTED = None
        for line in lines:

            end = (len(line.replace(' ', '').replace('\n', '').replace(')', '')) == 0) and (len(line.replace('\n', '').replace(' ', '')) != 0)

            if ':requirements ' in line:
                lines_reqs[n] = line

            ## excluding the line with '(:types'
            elif ':types' in line: 
                STARTED = 'TYPES'

            ## excluding the line with '(:types'
            elif ':predicates' in line: 
                STARTED = 'PREDICATES'

            ## '(:actions' and '(:derived'
            elif ':action' in line and STARTED != 'ACTIONS': 
                STARTED = 'ACTIONS'

            elif STARTED == 'TYPES' and not end:
                lines_types[n].append(line)

            elif STARTED == 'PREDICATES' and not end:
                lines_predicates[n].append(line)

            if STARTED == 'ACTIONS':
                lines_body[n].append(line)

        lines_body[n] = lines_body[n][:-1]

    lines_req = lines_reqs[max(lines_reqs, key=len)]
    new_lines = [line_name, '\n', lines_req, '\n', '  (:types\n\n']
    for n in names:
        new_lines.append(f'    ;; ------------------------------\n')
        new_lines.append(f'    ;; --- types from {n} domain\n')
        new_lines.append(f'    ;; ------------------------------\n')
        new_lines.extend(lines_types[n])
        new_lines.append('\n')
    new_lines.append('  )\n\n')

    new_lines.append('  (:predicates\n\n')
    for n in names:
        new_lines.append(f'    ;; ------------------------------\n')
        new_lines.append(f'    ;; --- predicates from {n} domain\n')
        new_lines.append(f'    ;; ------------------------------\n')
        new_lines.extend(lines_predicates[n])
        new_lines.append('\n')
    new_lines.append('  )\n\n')

    for n in names:
        new_lines.append(f'    ;; ------------------------------\n')
        new_lines.append(f'    ;; --- body from {n} domain\n')
        new_lines.append(f'    ;; ------------------------------\n')
        new_lines.extend(lines_body[n])
        new_lines.append('\n')
    new_lines.append(')\n')

    ## just want to separate the contents
    if expdir == None:
        return lines_types, lines_predicates, lines_body

    ## merge the contents into a new file
    newfilename = join(expdir, name+'.pddl')
    with open(newfilename, "w") as f:
        f.writelines(new_lines)
        return newfilename


if __name__ == "__main__":

    dmn_file = join('domains', 'grocery', 'costs', 'grocery_costs.pddl')
    obj_file = join('domains', 'grocery', 'costs', 'obj_grocery_costs.pddl')
    check_consistency(dmn_file, obj_file)

    # get_defined_objects()