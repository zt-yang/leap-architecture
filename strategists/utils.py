import json
from os import remove
from PyPDF2 import PdfFileMerger

def get_goals(prb_file):
    lines = open(prb_file, 'r').readlines()
    goals = []
    found = False
    for line in lines:
        if ':goal' in line: found = True
        elif ':metric' in line: found = False
        elif found and '(' in line and ')' in line: 
            line = line.replace('( ','(').replace(' )',')')
            parts = line[line.index('(')+1: line.index(')')].split(' ')
            goals.append(parts)
    return goals, list(set( [g[0] for g in goals] ))

def get_init(obj_file):
    return list(set(list( json.load(open(obj_file, 'r'))['init'].keys() ) ))

def merge_pdf(pdfs, outfile):
    merger = PdfFileMerger()
    for pdf in pdfs:
        merger.append(pdf)
        remove(pdf)
        remove(pdf.replace('.pdf',''))
    merger.write(outfile)
    merger.close()
