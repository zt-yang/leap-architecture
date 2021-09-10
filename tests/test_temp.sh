echo "Test the search complexity of solving a domain_merged problems and solving subproblems separately"

rm -r experiments/test_temp
mkdir experiments/test_temp

python run.py kitchen_1.pddl omelette_5_compare.pddl -v 0 -e 'experiments/test_temp'

python run.py kitchen_1.pddl omelette_5_iobig.pddl -v 0 -e 'experiments/test_temp'

python run.py kitchen_1.pddl omelette_5.pddl -o obj_5.pddl -v 0 -e 'experiments/test_temp' -t 50

python tests/post_experiments.py experiments/test_temp -sh tests/test_temp.sh -r