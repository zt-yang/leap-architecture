echo "Test the effect of increasing number of objects on search complexity"

rm -r experiments/omelette_objects
mkdir experiments/omelette_objects

python run.py kitchen.pddl omelette_3.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_objects'
python run.py kitchen.pddl omelette_3.pddl -o obj_2.pddl -v 0 -e 'experiments/omelette_objects'
python run.py kitchen.pddl omelette_3.pddl -o obj_3.pddl -v 0 -e 'experiments/omelette_objects'
python run.py kitchen.pddl omelette_3.pddl -o obj_4.pddl -v 0 -e 'experiments/omelette_objects'
python run.py kitchen.pddl omelette_3.pddl -o obj_5.pddl -v 0 -e 'experiments/omelette_objects'

python generators/post_experiments.py experiments/omelette_objects