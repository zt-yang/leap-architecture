echo "Test how hierarchies of tasks increase search complexity"

rm -r experiments/serve_declare
mkdir experiments/serve_declare

## Baselines of making one individual dish
python run.py kitchen_serve_declare.pddl scrambled_eggs.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_declare'
python run.py kitchen_serve_declare.pddl two_scrambled_eggs.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_declare'

python run.py kitchen_serve_declare.pddl omelette.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_declare' 
python run.py kitchen_serve_declare.pddl two_omelette.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_declare' 

python run.py kitchen_serve_declare.pddl sunny_side_up.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_declare'
python run.py kitchen_serve_declare.pddl two_sunny_side_up.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_declare'

python run.py kitchen_serve_declare.pddl egg_in_hole.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_declare'
python run.py kitchen_serve_declare.pddl two_egg_in_hole.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_declare'

python run.py kitchen_serve_declare.pddl poached_egg.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_declare'
python run.py kitchen_serve_declare.pddl two_poached_egg.pddl -o obj_serve.pddl -v 0 -e 'experiments/serve_declare'



python tests/post_experiments.py experiments/serve_declare -sh tests/test_serve_declare.sh -r

