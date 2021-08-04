from os.path import join

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

			if '—' not in last_text:
				temp = types
				if '[' in last_text:
					temp = objects
					
				if last_text not in types:
					temp[last_text] = []
				temp[last_text].append(text)

			else:
				comment = ";" + text.replace('-','')
				comments[last_text] = comment

		last_parent[level] = text

for temp in [types, objects]:
	print()
	for k, v in temp.items():
		v = ' '.join(v)
		line = f"{v} - {k}"
		print(line)