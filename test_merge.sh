echo "Test the search complexity of solving a domain_merged problems and solving subproblems separately"

rm -r experiments/domain_merge
mkdir experiments/domain_merge

## sub-problem 1: grocery shopping
python run.py grocery_0.pddl shop_omelette_0.pddl -o obj_grocery_0.pddl -v 0 -e 'experiments/domain_merge'

## sub-problem 2: omelette making (with minimum number of objects)
python run.py kitchen_extended.pddl omelette.pddl -o obj_extended.pddl -v 0 -e 'experiments/domain_merge'

## sub-problem 3: kitchen cleaning
# python run.py housework.pddl clean_kitchen.pddl -o obj_house.pddl -v 0 -e 'experiments/domain_merge'

## merged problem: making an omelette while keeping kitchen clean
python run.py "grocery_0.pddl+kitchen_extended.pddl" omelette_extended.pddl -o "obj_grocery_0.pddl+obj_extended2.pddl" -v 0 -e 'experiments/domain_merge'

python generators/post_experiments.py experiments/domain_merge -sh test_merge.sh -r