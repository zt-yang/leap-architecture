import argparse
from os import listdir
from os.path import join
from csv import reader
from tabulate import tabulate

parser = argparse.ArgumentParser()
parser.add_argument(dest="exp_dir", type=str, default='experiments')
columns = []

if __name__ == "__main__":
    print()
    exp_dir = parser.parse_args().exp_dir
    csv_file = [join(exp_dir, f) for f in listdir(exp_dir) if '.csv' in f][0]
    with open(csv_file, 'r') as f:
        rows = list(reader(f))

        ## make header shorter
        headers = [s.replace('timestamp', 't').replace('_count', '').replace('_time', '').replace('_length', '').replace('translation', 'parse').replace('_expanded', '') for s in rows[0]]

        ## for problem_name, print only the difference
        rows = rows[1:]
        keys = [row[1].replace('/', '-').split('-') for row in rows]
        new_keys = ['' for i in range(len(keys))]
        for i in range(len(keys[0])):
            col = [key[i] for key in keys]
            if not all(elem == col[0] for elem in col):
                new_keys = [new_keys[j]+'-'+col[j] for j in range(len(new_keys))]
        new_keys = [line[1:] for line in new_keys]
        new_keys = [line[line.index('-')+1:] for line in new_keys]
        
        for i in range(len(rows)):
            rows[i][1] = new_keys[i]

        print(tabulate(rows, headers=headers))
    print()