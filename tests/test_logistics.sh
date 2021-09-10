echo "Test logistics domain"

rm -r experiments/logistics
mkdir experiments/logistics

## ----------- try logistic domain small problem

python run.py logistics.pddl order.pddl -v 0 -e 'experiments/logistics' 

python run.py logistics.pddl order.pddl -v 0 -e 'experiments/logistics' -po "lama" 

python run.py logistics.pddl order.pddl -v 0 -e 'experiments/logistics' -po "seq-sat-lama-2011" 

python run.py logistics.pddl order.pddl -v 0 -e 'experiments/logistics' -po "seq-sat-fd-autotune-1"

python run.py logistics.pddl order.pddl -v 0 -e 'experiments/logistics' -po "seq-sat-fd-autotune-2"

python run.py logistics.pddl order.pddl -v 0 -e 'experiments/logistics' -po "seq-opt-bjolp"

python run.py logistics.pddl order.pddl -v 0 -e 'experiments/logistics' -po "seq-opt-lmcut"

python run.py logistics.pddl order.pddl -v 0 -e 'experiments/logistics' -po "v1"

python tests/post_experiments.py experiments/logistics -sh tests/test_logistics.sh -r
