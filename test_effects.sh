echo "Test how the complexity of operator effects affects the length of plan"

rm -r experiments/egg_effects
mkdir experiments/egg_effects

## scrambled_eggs.pddl + crack-egg-1
python run.py kitchen_egg_4.pddl scrambled_eggs.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_effects' -a 'crack-egg-1'

## omelette.pddl + crack-egg-1
python run.py kitchen_egg_4.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_effects' -a 'crack-egg-1'

## sunny_side_up.pddl + crack-egg-1
python run.py kitchen_egg_4.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_effects' -a 'crack-egg-1'

## sunny_side_up.pddl + crack-egg-2 = FAIL
python run.py kitchen_egg_4.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_effects' -a 'crack-egg-2'

## egg_in_hole.pddl + crack-egg-3
python run.py kitchen_egg_4.pddl egg_in_hole.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_effects' -a 'crack-egg-3'

## egg_in_hole.pddl + crack-egg-4 = LONGER
python run.py kitchen_egg_4.pddl egg_in_hole.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/egg_effects' -a 'crack-egg-4'

python generators/post_experiments.py experiments/egg_effects -sh test_egg_effects.sh -r