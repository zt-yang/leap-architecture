echo "Test the effect of increasing the number of operators on search complexity"

rm -r experiments/kitchen_operators
mkdir experiments/kitchen_operators

## kitchen_1.pddl contains all operators for omelette recipe
python run.py kitchen_1.pddl omelette_5.pddl -o obj_1.pddl -v 0 -e 'experiments/kitchen_operators'

## kitchen_2.pddl contains all operators for omelette + maintanance goals
python run.py kitchen_2.pddl omelette.pddl -o obj_1.pddl -v 0 -e 'experiments/kitchen_operators'

## kitchen_3.pddl contains all operators for 10 egg recipes
python run.py kitchen_egg_4.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/kitchen_operators'

## kitchen_4.pddl contains all operators for egg and baking recipes
# python run.py kitchen_4.pddl omelette.pddl -o obj_1.pddl -v 0 -e 'experiments/kitchen_operators'

python generators/post_experiments.py experiments/kitchen_operators -sh test_operators.sh