echo "Test the effect of increasing the number of objects on search complexity"

rm -r experiments/omelette_objects
mkdir experiments/omelette_objects

## obj_0.pddl contains the bare minimum set of objects
python run.py kitchen_1.pddl omelette_5.pddl -o obj_0.pddl -v 0 -e 'experiments/omelette_objects'

## obj_1.pddl adds 3 extranuous objects (i.e. pot/pan, bread/veggies, oliveoil/butter) 
python run.py kitchen_1.pddl omelette_5.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_objects'

## obj_2.pddl adds 3 alternative objects (i.e. knife/fork, bigbowl/smallbowl, saltedbutter/butter)
python run.py kitchen_1.pddl omelette_5.pddl -o obj_2.pddl -v 0 -e 'experiments/omelette_objects'

## obj_3.pddl contains 10 eggs and 10 veggies (the goal only mentions egg1 and veggie1)
python run.py kitchen_1.pddl omelette_5.pddl -o obj_3.pddl -v 0 -e 'experiments/omelette_objects'

## obj_4.pddl contains multiples (2) of every utensil (11) 
python run.py kitchen_1.pddl omelette_5.pddl -o obj_4.pddl -v 0 -e 'experiments/omelette_objects'

## obj_5.pddl contains multiples (10) of every utensil (11)  
python run.py kitchen_1.pddl omelette_5.pddl -o obj_5.pddl -v 0 -e 'experiments/omelette_objects' -t 150

## obj_eggs.pddl contains all objects for making 10 egg recipes
# python run.py kitchen_1.pddl omelette_5.pddl -o obj_eggs.pddl -v 0 -e 'experiments/omelette_objects'

python generators/post_experiments.py experiments/omelette_objects -sh test_objects.sh -r