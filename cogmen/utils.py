from os.path import join
from time import time
import json
import shutil
import glob
import copy

domain_dir = join('domains')

def find_files(file, path=domain_dir):
    return glob.glob(path + f"/**/{file}", recursive = True)

def get_pddl(args_domain, args_problem, expdir, args_use_objects = None, verbose=False):

    ## prepare to copy them to one of experiments/ subdirectory
    domain = join(expdir, args_domain)
    problem = join(expdir, args_problem)

    ## find the domain and problem file in all sub-directories of domains/
    given_domains = args_domain.split('+')
    found_domains = [find_files(d, domain_dir)[0] for d in given_domains]
    found_problem = find_files(args_problem, domain_dir)[0]

    if verbose: print(f'\nStep 1: Prepare input pddl files in experiment directory {domain_dir}\n  Found domain: {found_domains} \n  Found problem: {found_problem}')


    ## if given multiple domain files, merge parts into one and copy to expdir
    if len(found_domains) > 1:
        domain = merge_domains(found_domains, expdir)
    else:
        shutil.copy(found_domains[0], domain)


    ## replace (:types in domain and (:objects in problem 
    if args_use_objects != None:

        ## with those defined in generators/objects.md
        if '.md' in args_use_objects:
            new_types, new_objects = get_defined_objects()
            replace_lines(domain, '(:types', '(:predicates', new_types, domain)
            replace_lines(found_problem, '(:objects', '(:init', new_objects, problem)
        
        ## with those pddl subfiles in domains/../objects
        elif '.pddl' in args_use_objects:

            given_objects = args_use_objects.split('+')
            found_objects = [find_files(d, domain_dir)[0] for d in given_objects]

            ## if given multiple object files, merge files and copy to expdir
            if len(found_objects) > 1:
                obj_file = merge_objects(found_objects, expdir)
            else:
                obj_file = found_objects[0]

            new_objects_env = open(obj_file, "r+").readlines()
            replace_lines(found_problem, '(:objects', '(:goal', new_objects_env, problem)

        ## check_consistency and copy the files to expdir
        check_consistency(found_domains, obj_file, found_problem, expdir=expdir)

    else:
        shutil.copy(found_problem, problem)

    # ## replace (:action in domain
    # if args_action_sub != None:

    #     ## find the action name and file with all its variations
    #     new_action_name = args_action_sub
    #     action_name = new_action_name[:new_action_name.rfind('-')]
    #     action_pddl = glob.glob(domain_dir + f"/**/{action_name}.pddl", recursive = True)[0]

    #     ## find the action definition in action file
    #     new_action = get_action_by_name(new_action_name, action_pddl)

    #     ## replace the action definition in domain file
    #     startkey = f":action {action_name}"
    #     endkey = f"; don't delete this line: for substituting {action_name} effects"
    #     replace_lines(domain, startkey, endkey, new_action, domain)

    # ## delete all lines with the specified goal predicate in domain after a start key
    # if args_goal_ignore != None:
    #     comment_line(domain, '; -------- recipes',  args_goal_ignore, domain)
    
    return domain, problem


def warning(text):
    print(f'\n[checking consistency] {text}')

def strip(line, sub=' '):
    return line.replace(sub, '')

def empty(line):
    return len(strip(strip(line), '\n')) == 0

def is_end(line):
    line = strip(line)
    return len(line) == 1 and len(strip(line, ')')) == 0

def count_char(line, sub):
    return len(line) - len(line.replace(sub, ''))


def is_pred(line):
    """ at most two sets, at least one set of brackets """
    lbraket = count_char(line, '(')
    rbraket = count_char(line, ')')
    
    if '=' in line: return False ## TODO fix this exception
    if (lbraket == rbraket == 2) and 'not' in line: return 2
    if (lbraket == rbraket == 1): return 1
    return False

def get_pred(line):

    line = line[line.index('('):]
    if line.startswith(f'(not '):
        line = line.replace('(not (','(!')
    line = line[line.rfind('(')+1:line.index(')')]

    return line

def sep_paren(line):
    returns = []
    when = [0,0]
    j = 0
    for i in range(len(line)):
        if line[i] == '(': when[0] += 1
        if line[i] == ')': when[1] += 1
        if when[0] == when[1] and when != [0,0]:
            returns.append(line[j:i+1].lstrip())
            j = i+1
            when = [0,0]
    return returns

def get_pred_when(line, verbose=False):

    ## first separate pres and effs
    line = line[line.index('when')+5: line.rfind(')')]
    returns = sep_paren(line)
    return_preds = []
    for line in returns:
        if line.startswith('(and'):
            line = line[line.index('and')+4: line.rfind(')')]
            return_preds.append(sep_paren(line)) 
        else:
            return_preds.append([line]) 

    ## effect may be conditional effect
    for pred in copy.deepcopy(return_preds[1]):
        if pred.startswith('(when'):
            line = pred[pred.index('when')+5: pred.rfind(')')]
            returns = sep_paren(line)
            return_preds[0].append(returns[0])
            return_preds[1].append(returns[1])
            return_preds[1].remove(pred)

    ## extract predicates
    return_preds = [[p for p in preds if '=' not in p] for preds in return_preds]
    if verbose:
        print('1', return_preds[0])
        print('2', return_preds[1])
        print('------------')
    return return_preds


def strip_paren(line): 
    """ remove the outermost sets of brackets """
    return line[line.index('(')+1:line.rfind(')')]

def strip_comment(line):
    while ';' in line: line = line[:line.rfind(';')]
    return line

def check_consistency(dmn_files, obj_file, prob_file=None, expdir=None, verbose=False):
    """ debug 'return non-zero exit status 12 ' by checking:
        1. consistency within domain and obj files
        2. if all obj_types exist in dmn_types 
        3. if all dmn_const exist in obj_objects 
        4. if all prob_obj exist in obj_objects
        5. if domain name in prob_file is the same as that in domain_file
    """
    start = time()

    if verbose: print(f'\n... start checking consistency of {dmn_files}, {prob_file}, {obj_file}')

    ## 1. check consistency within obj files
    types, obj_types, objects = check_objects(obj_file, expdir)

    ## 1b. check consistency within domain files
    domain_summary = None
    # for dmn_file in dmn_files:
    domain_summary = check_domain(dmn_files, domain_summary, expdir)
    dmn_types = domain_summary['type_parents'] 
    dmn_const = domain_summary['constants'] 
    type_ancestors = domain_summary['type_ancestors']  

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

def check_domain(filenames, domain_summary=None, expdir='cogmen'):
    """ check if variable names are consistent in PDDL files """

    type_parents = {}  
    type_children = {}  
    type_ancestors = {'object':[]}
    type_offsprings = {}
    predicates = {}  ##{'=': ['object', 'object'], 'either': ['object', 'object']}  ## 
    constants = {}
    operators = {}
    axioms = {}
    name = None

    def check_pred(line):
        line = get_pred(line)
        parts = line.split(' ')
        pred = parts[0]
        params = parts[1:]
        for i in range(len(params)):
            param = params[i]
            def_type = predicates[pred.replace('!','')][i]

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

    lines_types, lines_predicates, lines_body = merge_domains(filenames)
    filename = '+'.join([f[f.rfind('/')+1:].replace('.pddl','') for f in filenames]) + '.json'

    ## for n domain files
    for n in lines_types:

        ## map each type to its parent and to all its ancestors
        for line in lines_types[n]:
            if ' - ' in line: 
                sub_typs, typ = line.replace('\n', '').split(' - ')
                for sub_typ in sub_typs.split(' '):
                    if empty(sub_typ): continue

                    type_parents[strip(sub_typ)] = typ

                    if typ not in type_children:
                        type_children[typ] = []
                    type_children[typ].append(strip(sub_typ))

        for typ, parent in type_parents.items():
            
            ancestors = [parent]
            while parent in type_parents:
                parent = type_parents[parent]
                ancestors.append(parent)
            type_ancestors[typ] = ancestors

        for typ, children in type_children.items():
            checked = []
            offsprings = children
            while set(checked) != set(offsprings):
                for offspring in offsprings:
                    checked.append(offspring)
                    if offspring in type_children:
                        offsprings.extend([oo for oo in type_children[offspring] if oo not in offsprings and oo not in checked])
            type_offsprings[typ] = list(set(checked))

        ## get the types of each param of predicates
        for line in lines_predicates[n]:
            if '(' in line and ')' in line:
                line = strip_comment(line)
                if empty(line): continue
                line = strip_paren(line)
                line = line.split('?')
                name = strip(line[0]) 

                ## there may be either
                for i in range(1, len(line)):
                    param = line[i].split(' - ')[1]
                    if 'either' in param:
                        param = strip_paren(param)
                        A, B = param.split(' ')[1:]
                        A_ans = type_ancestors[A]
                        B_ans = type_ancestors[B]
                        for a in A_ans:
                            if a in B_ans:
                                line[i] = line[i].split(' - ')[0] + ' - ' + a

                params = [strip(l.split(' - ')[1]) for l in line[1:]]
                predicates[name] = params


        ## check inside each operator (1) predicates types (2) var names (3) constants
        START = None
        STARTED = None
        when = [0, 0]
        when_lines = ''
        last_part = ''
        derived = []
        for line in lines_body[n]:
            line = strip_comment(line).replace('\n','')
            if empty(line): continue
            
            if ':action' in line:
                START = 'ACTION'

                if len(last_part) > 0:
                    operators[name]['lines'] = last_part
                    last_part = ''

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

                if len(derived) > 0:
                    name = derived[0]
                    while name in axioms: name += '+'
                    axioms[name] = {'pre': list(set(derived[1:]))}
                    derived = []

                    axioms[name]['lines'] = last_part
                    last_part = ''

                elif len(last_part) > 0:
                    operators[name]['lines'] = last_part
                    last_part = ''

            if START in ['PRE', 'EFF']:
                line = line.replace('( ','(').replace(' )',')')

                ## add new var
                if ' - ' in line and '?' in line:
                    A, B = line.split(' - ')
                    A = strip(A[A.rfind('(')+1:])
                    B = strip(B[:B.index(')')])
                    operators[name]['params'][A] = B

                elif 'increase ' in line and 'total-cost' in line:
                    operators[name]['cost'] = int(strip(line[line.index(')')+1:line.rfind(')')]))

                elif 'when' in line or when != [0, 0]:
                    when[0] += count_char(line, '(')
                    when[1] += count_char(line, ')')
                    when_lines += ' ' + line.lstrip().rstrip() + ' '
                    if when[0] == when[1]:
                        pres, effs = get_pred_when(when_lines)
                        operators[name]['pre'].extend([check_pred(p) for p in pres])
                        operators[name]['eff'].extend([check_pred(p) for p in effs])
                        when = [0, 0]
                        when_lines = ''

                elif is_pred(line): 
                    operators[name][START.lower()].append(check_pred(line))

            if START == 'DER':
                part = line.replace(':derived (', '').replace(')',' )').replace('(','( ').replace('  ', ' ').replace('not ( ', '!')
                pred = [p for p in part.split(' ') if p.replace('!','') in predicates]
                derived.extend(pred)
                
            last_part += line+'\n'

    last_part = last_part[:last_part.rfind(')')]

    ## the last derivative
    if START == 'DER' and len(derived) > 0:
        name = derived[0]
        while name in axioms: name += '+'
        axioms[name] = {'pre': list(set(derived[1:]))}

        axioms[name]['lines'] = last_part
        last_part = ''

    elif START == 'EFF' and len(last_part) > 0:
        operators[name]['lines'] = last_part
        last_part = ''

    ## a merged domain
    if domain_summary != None:
        domain_summary['type_parents'].update(type_parents)
        domain_summary['type_ancestors'].update(type_ancestors)
        domain_summary['predicates'].update(predicates)
        domain_summary['operators'].update(operators)
        domain_summary['constants'].update(constants)
    
    ## a single domain
    else:
        domain_summary = {
            'type_parents': type_parents,
            'type_ancestors': type_ancestors,
            'type_offsprings': type_offsprings,
            'predicates': predicates,
            'operators': operators,
            'axioms': axioms,
            'constants': constants,
        }

    with open(join(expdir, filename), 'w') as f:
        json.dump(domain_summary, f, indent=4)

    return domain_summary

def check_objects(filename, expdir):
    """ summarize all occurance of object instances in obj PDDL files """
    types = {}  ## list objects of each type
    obj_types = {}  ## map each object to its type
    objects = {}  ## list the initial predicates where each obj exists in
    init_pred = {}
    lines = open(filename, "r+").readlines()

    STARTED = None
    for line in lines:
        line = strip_comment(line).replace('\n', '')
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
                predicate = f"({line})"
                parts = line.split(' ')

                ## add to pred head count
                head = parts[0]
                if head not in init_pred: 
                    init_pred[head] = []
                init_pred[head].append(parts[1:])

                ## add to object count
                for arg in parts[1:]:
                    if len(arg.replace(' ','')) == 0 or 'total-cost' in arg: continue
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
            objects_by_type[typ][obj] = []
            newlines.append(f'\n   obj = {obj} ({len(objects[obj])})')
            for pred in objects[obj]:
                objects_by_type[typ][obj].append(pred)
                newlines.append(f'\n       {pred}')

    filename = filename[filename.rfind('/')+1:].replace('pddl+','+').replace('.pddl','.json')
    with open(join(expdir, filename), 'w') as f:
        json.dump({
            'types': types,
            'obj_types': obj_types,
            'objects_by_type': objects_by_type,
            'init': init_pred,
            }, f, indent=4)

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

    dmn_file = find_files('kitchen_1.pddl')
    check_domain(dmn_file)

