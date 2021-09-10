echo "Test the grocery shopping domain"

rm -r experiments/grocery_shopping
mkdir experiments/grocery_shopping

## basic operators and minimum objects
# python run.py grocery_0.pddl shop_omelette_0.pddl -o obj_grocery_0.pddl -v 0 -e 'experiments/grocery_shopping'

## with different action costs, redundant objects (locations)
# python run.py grocery_costs.pddl drive_costs.pddl -o obj_grocery_costs.pddl -v 3 -e 'experiments/grocery_shopping'
# python run.py grocery_costs.pddl drive_costs.pddl -o obj_grocery_costs.pddl -v 3 -e 'experiments/grocery_shopping' -po 'lama'

python run.py grocery_costs.pddl shop_veggies.pddl -o obj_grocery_costs.pddl -v 3 -e 'experiments/grocery_shopping'
python run.py grocery_costs.pddl shop_veggies.pddl -o obj_grocery_costs.pddl -v 3 -e 'experiments/grocery_shopping' -po 'lama'

python run.py grocery_costs.pddl shop_omelette.pddl -o obj_grocery_costs.pddl -v 3 -e 'experiments/grocery_shopping'
python run.py grocery_costs.pddl shop_omelette.pddl -o obj_grocery_costs.pddl -v 3 -e 'experiments/grocery_shopping' -po 'lama'

python run.py grocery_costs.pddl shop_lambchop.pddl -o obj_grocery_costs.pddl -v 3 -e 'experiments/grocery_shopping'
python run.py grocery_costs.pddl shop_lambchop.pddl -o obj_grocery_costs.pddl -v 3 -e 'experiments/grocery_shopping' -po 'lama'

python tests/post_experiments.py experiments/grocery_shopping -sh tests/test_grocery.sh -r