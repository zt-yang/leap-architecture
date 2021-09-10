echo "Test the search complexity of 5 different egg-related recipes with 10 eggs and 10 veggies"

rm -r experiments/egg_recipes_m
mkdir experiments/egg_recipes_m

## omelette.pddl specifies beaten, folded eggs with veggies
python run.py kitchen_egg_1.pddl omelette.pddl -o obj_3.pddl -v 0 -e 'experiments/egg_recipes_m'
python run.py kitchen_egg_2.pddl omelette.pddl -o obj_3.pddl -v 0 -e 'experiments/egg_recipes_m'
python run.py kitchen_egg_3.pddl omelette.pddl -o obj_3.pddl -v 0 -e 'experiments/egg_recipes_m'
python run.py kitchen_egg_4.pddl omelette.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m'
python run.py kitchen_egg_5.pddl omelette.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m' -t 300 ## FAIL
# python run.py kitchen_egg_5.pddl omelette.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m' -g 'is-buttery' # 7s

## scrambled_eggs.pddl specifies beaten, scrambled eggs
python run.py kitchen_egg_2.pddl scrambled_eggs.pddl -o obj_3.pddl -v 0 -e 'experiments/egg_recipes_m'
python run.py kitchen_egg_3.pddl scrambled_eggs.pddl -o obj_3.pddl -v 0 -e 'experiments/egg_recipes_m'
python run.py kitchen_egg_4.pddl scrambled_eggs.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m' # 41s
python run.py kitchen_egg_5.pddl scrambled_eggs.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m' -t 300 ## FAIL
# python run.py kitchen_egg_5.pddl scrambled_eggs.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m' -g 'is-buttery' # 3s

## sunny_side_up.pddl specifies fried, steamed eggs on frypan
python run.py kitchen_egg_3.pddl sunny_side_up.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m'
python run.py kitchen_egg_4.pddl sunny_side_up.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m'
python run.py kitchen_egg_5.pddl sunny_side_up.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m'

## egg_in_hole.pddl specifies fried egg in the hole of a bread
python run.py kitchen_egg_4.pddl egg_in_hole.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m' # 3s
python run.py kitchen_egg_5.pddl egg_in_hole.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m' -t 300 ## FAIL
# python run.py kitchen_egg_5.pddl egg_in_hole.pddl -o obj_egg_4_m.pddl -v 0 -e 'experiments/egg_recipes_m' -t 300 -g 'is-buttery' # 108s/120s

## poached_egg.pddl specifies boiled egg with vinegar
python run.py kitchen_egg_5.pddl poached_egg.pddl -o obj_egg_5_m.pddl -v 0 -e 'experiments/egg_recipes_m'

python tests/post_experiments.py experiments/egg_recipes_m -sh tests/test_egg_recipes_m.sh