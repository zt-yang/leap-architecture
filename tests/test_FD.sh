echo "Test different modes of FD"

rm -r experiments/planner_FD
mkdir experiments/planner_FD


## ----------- try other FD configurations

python run.py kitchen_extended.pddl omelette.pddl -o obj_extended.pddl -v 0 -e 'experiments/planner_FD' -po "lama-first"
python run.py kitchen_extended.pddl omelette.pddl -o obj_extended.pddl -v 0 -e 'experiments/planner_FD' -po "lama" -t 300

python run.py kitchen_extended.pddl scrambled_eggs.pddl -o obj_extended.pddl -v 0 -e 'experiments/planner_FD' -po "lama-first"
python run.py kitchen_extended.pddl scrambled_eggs.pddl -o obj_extended.pddl -v 0 -e 'experiments/planner_FD' -po "lama" -t 300

python run.py kitchen_extended.pddl sunny_side_up.pddl -o obj_extended.pddl -v 0 -e 'experiments/planner_FD' -po "lama-first"
python run.py kitchen_extended.pddl sunny_side_up.pddl -o obj_extended.pddl -v 0 -e 'experiments/planner_FD' -po "lama" -t 300

python run.py kitchen_extended.pddl egg_in_hole.pddl -o obj_extended.pddl -v 0 -e 'experiments/planner_FD' -po "lama-first"
python run.py kitchen_extended.pddl egg_in_hole.pddl -o obj_extended.pddl -v 0 -e 'experiments/planner_FD' -po "lama" -t 300

python run.py kitchen_extended.pddl poached_egg.pddl -o obj_extended.pddl -v 0 -e 'experiments/planner_FD' -po "lama-first"
python run.py kitchen_extended.pddl poached_egg.pddl -o obj_extended.pddl -v 0 -e 'experiments/planner_FD' -po "lama" -t 300

python tests/post_experiments.py experiments/planner_FD -sh tests/test_FD.sh -r
