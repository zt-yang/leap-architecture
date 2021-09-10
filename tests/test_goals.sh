echo "Test the effect of increasing the number of goal predicates on search complexity"

rm -r experiments/omelette_goals
mkdir experiments/omelette_goals

## omelette_1.pddl has fried buttery eggs
python run.py kitchen_1.pddl omelette_1.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama-first'
python run.py kitchen_1.pddl omelette_1.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama'

## omelette_2.pddl has the egg beaten and folded
python run.py kitchen_1.pddl omelette_2.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama-first'
python run.py kitchen_1.pddl omelette_2.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama'

## omelette_3.pddl adds veggies
python run.py kitchen_1.pddl omelette_3.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama-first'
python run.py kitchen_1.pddl omelette_3.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama'

## omelette_4.pddl adds salt and pepper
python run.py kitchen_1.pddl omelette_4.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama-first'
python run.py kitchen_1.pddl omelette_4.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama'

## omelette_5.pddl adds nutmilk and chives
python run.py kitchen_1.pddl omelette_5.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama-first'
python run.py kitchen_1.pddl omelette_5.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama'


## omelette_5a.pddl contains nutmilk and chives and no salt and pepper
python run.py kitchen_1.pddl omelette_5a.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama-first'
python run.py kitchen_1.pddl omelette_5a.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama'

## reduce four to three -- works
python run.py kitchen_1.pddl omelette_5a3.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama-first'
python run.py kitchen_1.pddl omelette_5a3.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama'

## remove salt -- works if given more time
python run.py kitchen_1.pddl omelette_5a4.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama-first'
python run.py kitchen_1.pddl omelette_5a4.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama' -t 30


## omelette_5b.pddl contains (exist-omelette)
python run.py kitchen_1.pddl omelette_5b.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama-first'
python run.py kitchen_1.pddl omelette_5b.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama'

## omelette_6.pddl contains one negative goal predicate
python run.py kitchen_1.pddl omelette_6.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama-first'
python run.py kitchen_1.pddl omelette_6.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama'

## omelette_7.pddl contains two negative goal predicates
python run.py kitchen_1.pddl omelette_7.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama-first'
python run.py kitchen_1.pddl omelette_7.pddl -o obj_1.pddl -v 0 -e 'experiments/omelette_goals' -po 'lama'

python tests/post_experiments.py experiments/omelette_goals -sh tests/test_goals.sh -r