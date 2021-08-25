echo "Test anything temperarily with printed summary table"

rm -r experiments/test_temp
mkdir experiments/test_temp

python run.py kitchen_egg_1.pddl omelette.pddl -o obj_0.pddl -v 0 -e 'experiments/test_temp'
python run.py kitchen_egg_2.pddl omelette.pddl -o obj_0.pddl -v 0 -e 'experiments/test_temp'
python run.py kitchen_egg_3.pddl omelette.pddl -o obj_0.pddl -v 0 -e 'experiments/test_temp'
python run.py kitchen_egg_2.pddl scrambled_eggs.pddl -o obj_0.pddl -v 0 -e 'experiments/test_temp'
python run.py kitchen_egg_3.pddl scrambled_eggs.pddl -o obj_0.pddl -v 0 -e 'experiments/test_temp'

python generators/post_experiments.py experiments/test_temp -sh test_temp.sh -r