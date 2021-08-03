import argparse
import os
import subprocess
import glob

parser = argparse.ArgumentParser()
parser.add_argument(dest="domain")
parser.add_argument(dest="problem")
parser.add_argument('-p', dest="planner", type=str, default='fd')
parser.add_argument('-s', dest="strategists", type=str, default='hpn')
parser.add_argument('-v', dest="verbose", action="store_true", default=True)
args = parser.parse_args()

planner_names = {'fd': 'FastDownward', 'pp': 'PyperPlan'}

def myprint(text = ''):
	if args.verbose: print(text)


def get_output_name():
	return f"{args.domain.replace('.pddl','')}_{args.problem.replace('.pddl','')}_{args.planner}"


def get_pddl(path = "domains"):
	""" search for the domain and problem file in all sub-directories of domains/ """
	domains = glob.glob(path + f"/**/{args.domain}", recursive = True)
	problems = glob.glob(path + f"/**/{args.problem}", recursive = True)
	myprint(f'\nStep 1: Take input problem \n  Found domain: {domains} \n  Found problem: {problems}')
	return domains[0], problems[0]


def get_problems(domain, problem):
	""" map a big problem into a sequence of smaller ones """
	problems = [(domain, problem)]
	strategists = args.strategists.split(',')
	myprint(f'\nStep 2: Abstract with {len(strategists)} strategists: {strategists}')

	while len(strategists) != 0:
		strategist = strategists[0]
		new_problems = []
		for subproblem in problems:
			new_domain, new_problem = run_strategist(strategist, domain, problem)
			new_problems.append([new_domain, new_problem])
		myprint(f'  {strategist}: turns {len(problems)} problems into {len(new_problems)} problems')
		problems = new_problems
		strategists.pop(0)
	return problems


def run_strategist(strategist, domain, problem):
	if strategist == 'hpn' or strategist == 'c2s2':
		return domain, problem
	else:
		print('unknown strategist')
	return None, None


def get_planner_command(domain, problem):
	if args.planner == 'fd':
		return f"downward/fast-downward.py --alias lama-first {domain} {problem}"
	elif args.planner == 'pp':
		return f"pyperplan/src/run.py -H hff -s gbf {domain} {problem}"
	else:
		print(f'unknown planner {args.planner}')


def process_planner_output(output, problem, keywords=[]):
	output = ''.join(output.decode()).split('\n')

	if args.planner == 'pp':
		keywords = ['parsed', 'removed', 'created', 'expanded', 'Search time', 'Plan length']
		solution_file = problem + '.soln'
		solution = open(solution_file, "r+").readlines()
		plan = [op.replace('\n', '') for op in solution]
		os.remove(solution_file)

	elif args.planner == 'fd':
		keywords = ['removed', 'necessary', 'Translator', 'Done!']
		plan = []
		start = False

	log = []
	for line in output:
		
		if args.planner == 'pp':
			if 'INFO' in line:
				line = line[line.index('INFO')+9:]
		
		elif args.planner == 'fd':
			if 'KB]' in line:
				line = line[line.index('KB]')+2:]
			elif start:
				plan.append(line)
				line = ''
				if 'Solution found.' in line:
					start = False
			elif 'reasonable' in line:
				start = True

		## select terminal outputs to be logged
		for keyword in keywords:
			if keyword in line:
				log.append(line)

	return plan, log


def get_plan(problems, output_name):
	index = 0
	myprint(f'\nStep 3: Plan with {planner_names[args.planner]}')
	for subproblem in problems:
		index += 1
		myprint(f'---------------- Subproblem {index} ----------------')

		domain, problem = subproblem
		command = get_planner_command(domain, problem)
		output = subprocess.check_output(command, shell=True)
		plan, log = process_planner_output(output, problem)
		
		plan_print, log_print = '\n     '.join(plan), '\n     '.join(log)
		myprint(f"\n  Plan: \n     {plan_print}\n\n  Log: \n     {log_print}")

		file1 = open(os.path.join('outputs', f"{output_name}.txt"), "w")
		file1.writelines('\n'.join(plan))
		file1.close()

		file2 = open(os.path.join('outputs', f"{output_name}.log"), "w")
		file2.writelines('\n'.join(log))
		file2.close()


if __name__ == "__main__":
    domain, problem = get_pddl()
    problems = get_problems(domain, problem)
    plan = get_plan(problems, output_name = get_output_name())

