echo "Test the effect of increasing the number of objects on search complexity"

rm -r experiments/omelette_objects
mkdir experiments/omelette_objects

## obj_1.pddl contains the bare minimum set of objects
python run.py kitchen_1.pddl omelette_5.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_objects'

## obj_2.pddl contains some alternative objects 
python run.py kitchen_1.pddl omelette_5.pddl -o obj_2.pddl -v 0 -e 'experiments/omelette_objects'

## obj_3.pddl contains 12 eggs
python run.py kitchen_1.pddl omelette_5.pddl -o obj_3.pddl -v 0 -e 'experiments/omelette_objects'

## obj_4.pddl contains multiples of every object
python run.py kitchen_1.pddl omelette_5.pddl -o obj_4.pddl -v 0 -e 'experiments/omelette_objects'

## obj_eggs.pddl contains all objects for making 10 egg recipes
python run.py kitchen_1.pddl omelette_5.pddl -o obj_eggs.pddl -v 0 -e 'experiments/omelette_objects'

python generators/post_experiments.py experiments/omelette_objects -sh test_objects.sh