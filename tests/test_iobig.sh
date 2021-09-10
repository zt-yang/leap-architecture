echo "Test the effectiveness of Pre-Strategist IOBIG (Ignore Object Based on Influence Graph)"

rm -r experiments/test_iobig
mkdir experiments/test_iobig


## obj_0.pddl contains the bare minimum set of objects
python run.py kitchen_1.pddl omelette_5.pddl -o obj_0.pddl -v 0 -e 'experiments/test_iobig'
python run.py kitchen_1.pddl omelette_5.pddl -o obj_0.pddl -v 0 -e 'experiments/test_iobig' -s 'iobig'

## obj_1.pddl adds 3 extranuous objects (i.e. pot/pan, bread/veggies, oliveoil/butter) 
python run.py kitchen_1.pddl omelette_5.pddl -o obj_1.pddl -v 0 -e 'experiments/test_iobig'
python run.py kitchen_1.pddl omelette_5.pddl -o obj_1.pddl -v 0 -e 'experiments/test_iobig' -s 'iobig'

## obj_2.pddl adds 3 alternative objects (i.e. knife/fork, bigbowl/smallbowl, saltedbutter/butter)
python run.py kitchen_1.pddl omelette_5.pddl -o obj_2.pddl -v 0 -e 'experiments/test_iobig'
python run.py kitchen_1.pddl omelette_5.pddl -o obj_2.pddl -v 0 -e 'experiments/test_iobig' -s 'iobig'

## obj_3.pddl contains 10 eggs and 10 veggies (the goal only mentions egg1 and veggie1)
python run.py kitchen_1.pddl omelette_5.pddl -o obj_3.pddl -v 0 -e 'experiments/test_iobig'
python run.py kitchen_1.pddl omelette_5.pddl -o obj_3.pddl -v 0 -e 'experiments/test_iobig' -s 'iobig'

## obj_4.pddl contains multiples (2) of every utensil (11) 
python run.py kitchen_1.pddl omelette_5.pddl -o obj_4.pddl -v 0 -e 'experiments/test_iobig'
python run.py kitchen_1.pddl omelette_5.pddl -o obj_4.pddl -v 0 -e 'experiments/test_iobig' -s 'iobig'

## obj_5.pddl contains multiples (10) of every utensil (11)  
python run.py kitchen_1.pddl omelette_5.pddl -o obj_5.pddl -v 0 -e 'experiments/test_iobig' -t 150
python run.py kitchen_1.pddl omelette_5.pddl -o obj_5.pddl -v 0 -e 'experiments/test_iobig' -t 150 -s 'iobig'


python tests/post_experiments.py experiments/test_iobig -sh tests/test_iobig.sh -r