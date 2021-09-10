echo "Test the effectiveness of combining SDBIG and IOBIG"

rm -r experiments/test_strategists
mkdir experiments/test_strategists


python run.py "grocery_costs.pddl+kitchen_extended.pddl" omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_extended2.pddl" -v 0 -e 'experiments/test_strategists'
python run.py "grocery_costs.pddl+kitchen_extended.pddl" omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_extended2.pddl" -v 0 -e 'experiments/test_strategists' -s 'sdbig'
python run.py "grocery_costs.pddl+kitchen_extended.pddl" omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_extended2.pddl" -v 0 -e 'experiments/test_strategists' -s 'iobig'
python run.py "grocery_costs.pddl+kitchen_extended.pddl" omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_extended2.pddl" -v 0 -e 'experiments/test_strategists' -s 'sdbig,iobig'


python tests/post_experiments.py experiments/test_strategists -sh tests/test_strategists.sh -r