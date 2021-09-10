echo "Test how hierarchies of tasks increase search complexity"

rm -r experiments/serve_enable
mkdir experiments/serve_enable

## Baselines of making one individual dish
python run.py kitchen_serve_enable.pddl scrambled_eggs.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_enable'
python run.py kitchen_serve_enable.pddl two_scrambled_eggs.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_enable'

python run.py kitchen_serve_enable.pddl omelette.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_enable' 
python run.py kitchen_serve_enable.pddl two_omelette.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_enable' 

python run.py kitchen_serve_enable.pddl sunny_side_up.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_enable'
python run.py kitchen_serve_enable.pddl two_sunny_side_up.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_enable'

python run.py kitchen_serve_enable.pddl egg_in_hole.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_enable'
python run.py kitchen_serve_enable.pddl two_egg_in_hole.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_enable'

python run.py kitchen_serve_enable.pddl poached_egg.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_enable'
python run.py kitchen_serve_enable.pddl two_poached_egg.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_enable'


python tests/post_experiments.py experiments/serve_enable -sh tests/test_serve_enable.sh -r

