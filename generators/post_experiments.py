import argparse
from os import listdir
from os.path import join, isfile, isdir, getsize
from csv import reader
from tabulate import tabulate
import shutil
from datetime import datetime

parser = argparse.ArgumentParser()
parser.add_argument(dest="exp_dir", type=str, default='experiments')
parser.add_argument('-sh',dest="exp_sh", type=str, default=None)
parser.add_argument('-r',dest="replace", action='store_true')
args = parser.parse_args()

def summarize_csv(exp_dir):
    csv_file = [join(exp_dir, f) for f in listdir(exp_dir) if '.csv' in f][0]
    with open(csv_file, 'r') as f:
        rows = list(reader(f))

        if len(rows) > 2:

            ## make header shorter
            headers = [s.replace('timestamp', 't').replace('problem_name', 'run_name').replace('_count', '').replace('_time', '').replace('_length', '').replace('plan_cost', 'cost').replace('translation', 'parse').replace('_expanded', '') for s in rows[0]]
            rows = rows[1:]

            ## for problem_name, print only the difference
            keys = []
            for row in rows:
                key = row[1]
                key = key[key.index('/')+1:]
                key = key[:key.index('/')]
                keys.append(key.split('-'))

            ## pad optional fields like action_sub and goal_ignore with ''
            max_len = max([len(key) for key in keys])
            for key in keys:
                while len(key) < max_len:
                    key.append('')

            new_keys = ['' for i in range(len(keys))]
            for i in range(len(keys[0])):
                col = [key[i] for key in keys]
                if not all(elem == col[0] for elem in col):
                    new_keys = [new_keys[j]+'-'+col[j] for j in range(len(new_keys))]

            row_names = []
            for line in new_keys:
                line = line[1:]
                key = line[line.index('-')+1:]
                key = key.replace('.pddl','').replace('-',', ')
                key = key.replace('dmn=','').replace('prb=','').replace('obj=','')
                row_names.append(key)        
            
            for i in range(len(rows)):
                rows[i][1] = row_names[i]

            print()
            print(tabulate(rows, headers=headers))
            print()

def save_copy(exp_dir, save_dir):
    """ if all commands are run successfully, 
            copy the whole folder into '_saved' subdir, 
            replacing the previous successful save if there exists,
        also copy the test shell script """

    if args.exp_sh == None: return
    exp_name = exp_dir[exp_dir.rfind('/')+1:]

    ## delete all previous experiments with this name
    if args.replace:
        previous_dirs = [join(save_dir, f) for f in listdir(save_dir) if f"{exp_name}-" in f]
        for each in previous_dirs:
            shutil.rmtree(each)
            
    dt = datetime.now().strftime("%m%d-%H%M%S")
    save_dir = join(save_dir, f'{exp_name}-{dt}')

    runs = [join(exp_dir, f) for f in listdir(exp_dir) if isdir(join(exp_dir, f))]
    failed_runs = len(runs)
    for run in runs:
        plan_file = join(run, '_output_1.txt')
        if isfile(plan_file) and getsize(plan_file) > 0:
            failed_runs -= 1
    
    if failed_runs == 0 or True:
        shutil.copytree(exp_dir, save_dir) 
        if args.exp_sh != None:
            shutil.copy(args.exp_sh, join(save_dir, args.exp_sh))

if __name__ == "__main__":
    exp_dir = args.exp_dir
    
    summarize_csv(exp_dir)
    save_copy(exp_dir, join('experiments', '_saved'))