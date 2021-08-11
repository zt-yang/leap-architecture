from os.path import join

def get_defined_objects():
    levels = {'#': 0, '##': 1, '###': 2, '-': 3, '\t-': 4, '\t\t-': 5, '\t\t\t-': 6}

    last_parent = {v: '' for v in levels.values()}
    types = {}
    objects = {}
    comments = {}

    for line in open(join('..', 'docs', 'objects.md'), "r+").readlines():
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
                newlines.append('\n\n')
                newlines.append(line)
                FINISHED = True
        else:
            newlines.append(line)

    with open(newfilename, "w") as f:
        f.writelines(newlines)


# get_defined_objects()