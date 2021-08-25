echo "Test different modes of FD"

rm -r experiments/planner_FD
mkdir experiments/planner_FD

## ----------- try sunny_side_up

# python run.py kitchen_FD_ssu.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' 

# python run.py kitchen_FD_ssu.pddl sunny_side_up_buttery.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' 

# python run.py kitchen_FD_ssu_buttery.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' 

# python run.py kitchen_FD_ssu_buttery.pddl sunny_side_up_buttery.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' 


# python run.py kitchen_FD_ssu.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' -po 'v1'

## ----------- try omelette

python run.py kitchen_FD_ssu.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD'

python run.py kitchen_FD_ssu.pddl omelette_buttery.pddl -o obj_0.pddl -v 0 -e 'experiments/planner_FD'

python run.py kitchen_FD_ssu_buttery.pddl omelette.pddl -o obj_0.pddl -v 0 -e 'experiments/planner_FD'

python run.py kitchen_FD_ssu_buttery.pddl omelette_buttery.pddl -o obj_0.pddl -v 0 -e 'experiments/planner_FD'

python run.py kitchen_FD_ssu.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' 

python run.py kitchen_FD_ssu.pddl omelette_buttery.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' 

python run.py kitchen_FD_ssu_buttery.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' 

python run.py kitchen_FD_ssu_buttery.pddl omelette_buttery.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' 

## ----------- try other FD configurations

python run.py kitchen_FD_ssu.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' -po "lama"

python run.py kitchen_FD_ssu.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' -po "seq-sat-lama-2011"

python run.py kitchen_FD_ssu.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' -po "seq-sat-fd-autotune-1"

python run.py kitchen_FD_ssu.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' -po "seq-sat-fd-autotune-2"

python run.py kitchen_FD_ssu.pddl omelette.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' -po 'v1'

python generators/post_experiments.py experiments/planner_FD -sh test_FD.sh -r

## ----------- failed trials


## can't find the solution in 20 sec
# python run.py kitchen_FD_ssu.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' -po "lama"
# python run.py kitchen_FD_ssu.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' -po "seq-sat-lama-2011"
# python run.py kitchen_FD_ssu.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' -po "seq-sat-fd-autotune-1"
# python run.py kitchen_FD_ssu.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' -po "seq-sat-fd-autotune-2"

## cost partitioning does not support axioms
# python run.py kitchen_FD_ssu.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 0 -e 'experiments/planner_FD' -po "seq-opt-bjolp"

## This configuration does not support axioms!
# python run.py kitchen_FD_ssu.pddl sunny_side_up.pddl -o obj_egg_4.pddl -v 2 -e 'experiments/planner_FD' -po "seq-opt-lmcut"