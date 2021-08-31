echo "Test the search complexity of solving a domain_merged problems and solving subproblems separately"

rm -r experiments/domain_merge
mkdir experiments/domain_merge

## two subproblems and one merged problem, by LAMA-First
python run.py grocery_costs.pddl shop_veggies.pddl -o obj_grocery_costs.pddl -v 0 -e 'experiments/domain_merge'
python run.py kitchen_extended.pddl omelette.pddl -o obj_extended.pddl -v 0 -e 'experiments/domain_merge'
python run.py "grocery_costs.pddl+kitchen_extended.pddl" omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_extended2.pddl" -v 0 -e 'experiments/domain_merge'

## two subproblems and one merged problem, by LAMA
python run.py grocery_costs.pddl shop_veggies.pddl -o obj_grocery_costs.pddl -v 0 -e 'experiments/domain_merge' -po 'lama'
python run.py kitchen_extended.pddl omelette.pddl -o obj_extended.pddl -v 0 -e 'experiments/domain_merge' -po 'lama'
python run.py "grocery_costs.pddl+kitchen_extended.pddl" omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_extended2.pddl" -v 0 -e 'experiments/domain_merge' -po 'lama'

## ---------------------------------
## make omelette and lambchop
## ---------------------------------

## two subproblems and one merged problem, by LAMA-First
python run.py grocery_costs.pddl shop_lambchop.pddl -o obj_grocery_costs.pddl -v 0 -e 'experiments/domain_merge'
python run.py kitchen_lambchop.pddl omelette.pddl -o obj_lambchop.pddl -v 0 -e 'experiments/domain_merge'
python run.py kitchen_lambchop.pddl lambchop.pddl -o obj_lambchop.pddl -v 0 -e 'experiments/domain_merge'
python run.py "grocery_costs.pddl+kitchen_lambchop.pddl" omelette_lambchop.pddl -o "obj_grocery_costs.pddl+obj_lambchop2.pddl" -v 0 -e 'experiments/domain_merge' -t 20

## two subproblems and one merged problem, by LAMA
python run.py grocery_costs.pddl shop_lambchop.pddl -o obj_grocery_costs.pddl -v 0 -e 'experiments/domain_merge' -po 'lama'
python run.py kitchen_lambchop.pddl omelette.pddl -o obj_lambchop.pddl -v 0 -e 'experiments/domain_merge' -po 'lama'
python run.py kitchen_lambchop.pddl lambchop.pddl -o obj_lambchop.pddl -v 0 -e 'experiments/domain_merge' -po 'lama'
python run.py "grocery_costs.pddl+kitchen_lambchop.pddl" omelette_lambchop.pddl -o "obj_grocery_costs.pddl+obj_lambchop2.pddl" -v 0 -e 'experiments/domain_merge' -t 20 -po 'lama'

python generators/post_experiments.py experiments/domain_merge -sh test_merge.sh -r