echo "Test the effectiveness of Pre-Strategist SDBIG (Separate Domains Based on Influence Graph)"

rm -r experiments/test_sdbig
mkdir experiments/test_sdbig


python run.py "grocery_costs.pddl+kitchen_extended.pddl" omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_extended2.pddl" -v 0 -e 'experiments/test_sdbig'
python run.py "grocery_costs.pddl+kitchen_extended.pddl" omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_extended2.pddl" -v 0 -e 'experiments/test_sdbig' -s 'sdbig'

python run.py "grocery_costs.pddl+kitchen_extended.pddl" omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_extended2.pddl" -v 0 -e 'experiments/test_sdbig' -po 'lama'
python run.py "grocery_costs.pddl+kitchen_extended.pddl" omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_extended2.pddl" -v 0 -e 'experiments/test_sdbig' -po 'lama' -s 'sdbig'

## cannot work for now because lambchop requires purchasing two ingredients
# python run.py "grocery_costs.pddl+kitchen_lambchop.pddl" omelette_lambchop.pddl -o "obj_grocery_costs.pddl+obj_lambchop2.pddl" -v 0 -e 'experiments/test_sdbig' -t 20
# python run.py "grocery_costs.pddl+kitchen_lambchop.pddl" omelette_lambchop.pddl -o "obj_grocery_costs.pddl+obj_lambchop2.pddl" -v 0 -e 'experiments/test_sdbig' -t 20 -s 'sdbig'

# python run.py "grocery_costs.pddl+kitchen_lambchop.pddl" omelette_lambchop.pddl -o "obj_grocery_costs.pddl+obj_lambchop2.pddl" -v 0 -e 'experiments/test_sdbig' -t 20 -po 'lama'
# python run.py "grocery_costs.pddl+kitchen_lambchop.pddl" omelette_lambchop.pddl -o "obj_grocery_costs.pddl+obj_lambchop2.pddl" -v 0 -e 'experiments/test_sdbig' -t 20 -po 'lama' -s 'sdbig'

python tests/post_experiments.py experiments/test_sdbig -sh tests/test_sdbig.sh -r