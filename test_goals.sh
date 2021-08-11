echo "Test the effect of increasing the number of goal predicates on search complexity"

rm -r experiments/omelette_goals
mkdir experiments/omelette_goals

## omelette_1.pddl has only eggs
python run.py kitchen_1.pddl omelette_1.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals'

## omelette_2.pddl adds veggies
python run.py kitchen_1.pddl omelette_2.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals'

## omelette_3.pddl adds salt and pepper
python run.py kitchen_1.pddl omelette_3.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals'

## omelette_4.pddl adds nutmilk and chives
python run.py kitchen_1.pddl omelette_4.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals'

## omelette_5.pddl contains all positive goal predicates without any use of axioms
python run.py kitchen_1.pddl omelette_5.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals'

## omelette_6.pddl contains one negative goal predicate
python run.py kitchen_1.pddl omelette_6.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals'

## omelette_7.pddl contains two negative goal predicates
python run.py kitchen_1.pddl omelette_7.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals'

python generators/post_experiments.py experiments/omelette_goals