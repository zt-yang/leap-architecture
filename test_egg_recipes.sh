echo "Test the search complexity of 10 different egg-related recipes"

rm -r experiments/egg_recipes
mkdir experiments/egg_recipes

## scrambled_eggs.pddl specifies beaten, scrambled eggs
python run.py kitchen_3.pddl scrambled_eggs.pddl -o obj_eggs.pddl -v 0 -e 'experiments/egg_recipes'

## omelette.pddl specifies beaten, folded eggs with veggies
python run.py kitchen_3.pddl omelette.pddl -o obj_eggs.pddl -v 0 -e 'experiments/egg_recipes'

## sunny_side_up.pddl specifies fried, steamed eggs on frypan
python run.py kitchen_3.pddl sunny_side_up.pddl -o obj_eggs.pddl -v 0 -e 'experiments/egg_recipes'

## egg_in_hole.pddl specifies fried egg in the hole of a bread
# python run.py kitchen_3.pddl egg_in_hole.pddl -o obj_eggs.pddl -v 0 -e 'experiments/egg_recipes'

python generators/post_experiments.py experiments/egg_recipes