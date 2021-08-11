echo "Test the effect of increasing number of goal predicates on search complexity"

rm -r experiments/omelette_goals
mkdir experiments/omelette_goals

python run.py kitchen.pddl omelette_1.pddl -o kitchen_obj.pddl -v 0 -e 'experiments/omelette_goals'
# python run.py kitchen.pddl omelette_2.pddl -o kitchen_obj.pddl -v 0 -e 'experiments/omelette_goals'
python run.py kitchen.pddl omelette_3.pddl -o kitchen_obj.pddl -v 0 -e 'experiments/omelette_goals'
python run.py kitchen.pddl omelette_4.pddl -o kitchen_obj.pddl -v 0 -e 'experiments/omelette_goals'
python run.py kitchen.pddl omelette_5.pddl -o kitchen_obj.pddl -v 0 -e 'experiments/omelette_goals'
python run.py kitchen.pddl omelette_6.pddl -o kitchen_obj.pddl -v 0 -e 'experiments/omelette_goals'

python generators/post_experiments.py experiments/omelette_goals