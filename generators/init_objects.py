from os.path import join

def get_defined_objects():
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


def merge_domains(found_domains, expdir):

    names = [d[d.rfind('/')+1:d.rfind('.')] for d in found_domains]
    name = '+'.join(names)
    newfilename = join(expdir, name+'.pddl')

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

    with open(newfilename, "w") as f:
        f.writelines(new_lines)

    return newfilename


if __name__ == "__main__":
    get_defined_objects()