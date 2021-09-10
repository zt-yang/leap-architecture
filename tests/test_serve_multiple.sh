echo "Test how hierarchies of tasks increase search complexity"

rm -r experiments/serve_multiple
mkdir experiments/serve_multiple

## Baselines of making one individual dish

python run.py kitchen_extended.pddl omelette.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15
python run.py kitchen_extended.pddl egg_in_hole.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15
python run.py kitchen_extended.pddl multiple_14.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15

python run.py kitchen_extended.pddl omelette.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15 -po 'lama'
python run.py kitchen_extended.pddl egg_in_hole.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15 -po 'lama'
python run.py kitchen_extended.pddl multiple_14.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15 -po 'lama'

python run.py kitchen_extended.pddl scrambled_eggs.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15
python run.py kitchen_extended.pddl egg_in_hole.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15
python run.py kitchen_extended.pddl multiple_24.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15

python run.py kitchen_extended.pddl scrambled_eggs.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15 -po 'lama'
python run.py kitchen_extended.pddl egg_in_hole.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15 -po 'lama'
python run.py kitchen_extended.pddl multiple_24.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' -t 15 -po 'lama'

## doens't work

# python run.py kitchen_extended.pddl scrambled_eggs.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple'
# python run.py kitchen_extended.pddl omelette.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' 
# python run.py kitchen_extended.pddl multiple_12.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple' 

# python run.py kitchen_extended.pddl sunny_side_up.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple'
# python run.py kitchen_extended.pddl egg_in_hole.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple'
# python run.py kitchen_extended.pddl poached_egg.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple'
# python run.py kitchen_extended.pddl multiple_345.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_multiple'

python tests/post_experiments.py experiments/serve_multiple -sh tests/test_serve_multiple.sh -r

