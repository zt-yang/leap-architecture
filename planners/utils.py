import re
import json

def count_char(line, sub):
    return len(line) - len(line.replace(sub, ''))

def summarize_sas(sas='output.sas'):

    count_var, count_op, count_ax = 0, 0, 0
    atoms = {}
    variables = {}
    operators = {}  ## operator instances
    actions = {}  ## operators summarized by head
    name = None
    START = None

    for line in open(sas, "r+").readlines():
        line = line.replace('\n', '')

        if 'end_' in line:

            ## summarize all positive atoms to compare with other sas
            if START == 'VARIABLE':
                for atom in variables[name]['values']:
                    if 'NegatedAtom' in atom: continue
                    atoms[atom] = variables[name]['values']
            START = None

        ## ----------------------
        ## summarize atoms
        ## ----------------------
        elif 'begin_variable' in line:
            START = 'VARIABLE'
            count_var += 1

        elif START == 'VARIABLE':
            
            if line.startswith('var'):
                name = line
                variables[name] = {'values':[], 'transitions':[]}

            elif 'Atom' in line or '<none of those>' in line:
                variables[name]['values'].append(line)

        ## ----------------------
        ## summarize operators that change variables
        ## ----------------------
        elif 'begin_operator' in line:
            START = 'OPERATOR'
            count_op += 1

        elif START == 'OPERATOR':

            if len(re.sub(r'\d', '', line).replace(' ', '').replace('-','')) != 0:
                name = line
                operators[name] = {
                    'cost': [], 'pre': [], 'eff': []
                }

            elif count_char(line, ' ') == 0: ## numbers
                if len(operators[name]['cost']) == 2:
                    operators[name]['cost'] = line
                else:
                    operators[name]['cost'].append(line)

            elif count_char(line, ' ') == 1: ## pre
                v, d = line.split(' ')
                v = 'var'+v
                d = variables[v]['values'][int(d)]
                operators[name]['pre'].append((v, d))

            else: ## eff
                parts = line.split(' ')
                n_cond = parts[0]
                v, d, dp = parts[-3:]

                parts = parts[1:-3]
                v_cond = None
                conds = []
                for p in parts:
                    if v_cond == None: 
                        v_cond = 'var'+p
                    else: 
                        d_cond = variables[v_cond]['values'][int(p)]
                        conds.append((v_cond, d_cond))
                        v_cond = None

                v = 'var'+v
                d = variables[v]['values'][int(d)]
                dp = variables[v]['values'][int(dp)]
                operators[name]['eff'].append((conds, v, d, dp))

                conds.extend(operators[name]['pre'])
                variables[v]['transitions'].append({
                    'from': d, 'to': dp, 'cond': conds, 'label': name,
                })


        ## ----------------------
        ## summarize rules that change variables
        ## ----------------------
        elif 'begin_rule' in line:
            START = 'RULE'
            count_ax += 1

        elif START == 'RULE':

            if count_char(line, ' ') == 1: ## pre
                v, d = line.split(' ')
                v = 'var'+v
                d = variables[v]['values'][int(d)]
                name = (v, d)

            elif count_char(line, ' ') == 2: ## eff
                v, d, dp = line.split(' ')
                v = 'var'+v
                d = variables[v]['values'][int(d)]
                dp = variables[v]['values'][int(dp)]
                variables[v]['transitions'].append({
                    'from': d, 'to': dp, 'cond': name, 'label': 'rule',
                })

    for operator in operators.keys():
        head = operator.split(' ')[0]
        if head not in actions: actions[head] = []
        actions[head].append(operator)

    output_sas = {
        'count_var': count_var, 
        'count_op': count_op, 
        'count_ax': count_ax, 
        'atoms': atoms,
        'variables': variables,
        'operators': actions,
        'operator_counts': {k:len(v) for k, v in actions.items()},
        'operator_instances': operators,
    }
    with open(sas.replace('sas', 'json'), 'w') as f:
        json.dump(output_sas, f, indent=4)

    return count_var, count_op, count_ax