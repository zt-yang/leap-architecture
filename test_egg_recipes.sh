echo "Test the search complexity of 10 different egg-related recipes"

rm -r experiments/egg_recipes
mkdir experiments/egg_recipes

## ------- no longer need those -g 'is-buttery'

## omelette.pddl specifies beaten, folded eggs with veggies
python run.py kitchen_egg_1.pddl omelette.pddl -o obj_0.pddl -v 0 -e 'experiments/egg_recipes'
python run.py kitchen_egg_2.pddl omelette.pddl -o obj_0.pddl -v 0 -e 'experiments/egg_recipes'
python run.py kitchen_egg_3.pddl omelette.pddl -o obj_0.pddl -v 0 -e 'experiments/egg_recipes'
python run.py kitchen_egg_4.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes'
python run.py kitchen_egg_5.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' -t 300 ## FAIL

python run.py kitchen_egg_1.pddl omelette.pddl -o obj_0.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'
python run.py kitchen_egg_2.pddl omelette.pddl -o obj_0.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'
python run.py kitchen_egg_3.pddl omelette.pddl -o obj_0.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'
python run.py kitchen_egg_4.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'
python run.py kitchen_egg_5.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'


## scrambled_eggs.pddl specifies beaten, scrambled eggs
python run.py kitchen_egg_2.pddl scrambled_eggs.pddl -o obj_0.pddl -v 0 -e 'experiments/egg_recipes'
python run.py kitchen_egg_3.pddl scrambled_eggs.pddl -o obj_0.pddl -v 0 -e 'experiments/egg_recipes'
python run.py kitchen_egg_4.pddl scrambled_eggs.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' 
python run.py kitchen_egg_5.pddl scrambled_eggs.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes'

python run.py kitchen_egg_2.pddl scrambled_eggs.pddl -o obj_0.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'
python run.py kitchen_egg_3.pddl scrambled_eggs.pddl -o obj_0.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'
python run.py kitchen_egg_4.pddl scrambled_eggs.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'
python run.py kitchen_egg_5.pddl scrambled_eggs.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'



## sunny_side_up.pddl specifies fried, steamed eggs on frypan
python run.py kitchen_egg_3.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes'
python run.py kitchen_egg_4.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes'
python run.py kitchen_egg_5.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes'

python run.py kitchen_egg_3.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'
python run.py kitchen_egg_4.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'
python run.py kitchen_egg_5.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'


## egg_in_hole.pddl specifies fried egg in the hole of a bread
python run.py kitchen_egg_4.pddl egg_in_hole.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes'
python run.py kitchen_egg_5.pddl egg_in_hole.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' 

python run.py kitchen_egg_4.pddl egg_in_hole.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'
python run.py kitchen_egg_5.pddl egg_in_hole.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'

## poached_egg.pddl specifies boiled egg with vinegar
python run.py kitchen_egg_5.pddl poached_egg.pddl -o obj_egg_5.pddl -v 0 -e 'experiments/egg_recipes'

python run.py kitchen_egg_5.pddl poached_egg.pddl -o obj_egg_5.pddl -v 0 -e 'experiments/egg_recipes' -po 'lama'

python generators/post_experiments.py experiments/egg_recipes -sh test_egg_recipes.sh