echo "Test how hierarchies of tasks increase search complexity"

rm -r experiments/customer_happy
mkdir experiments/customer_happy

## Baselines of making one individual dish

python run.py kitchen_customer_1.pddl sunny_side_up.pddl -o obj_serve.pddl -v 0 -e 'experiments/customer_happy' 
python run.py kitchen_customer_1.pddl poached_egg.pddl -o obj_serve.pddl -v 0 -e 'experiments/customer_happy' 
python run.py kitchen_customer_1.pddl customer_happy.pddl -o obj_serve.pddl -v 0 -e 'experiments/customer_happy' 
python run.py kitchen_customer_2.pddl customer_happy.pddl -o obj_serve.pddl -v 0 -e 'experiments/customer_happy' 

python run.py kitchen_customer_3.pddl multiple_14.pddl -o obj_customer.pddl -v 0 -e 'experiments/customer_happy' 
python run.py kitchen_customer_3.pddl multiple_24.pddl -o obj_customer.pddl -v 0 -e 'experiments/customer_happy'
python run.py kitchen_customer_3.pddl customer_happier.pddl -o obj_customer.pddl -v 0 -e 'experiments/customer_happy'
python run.py kitchen_customer_4.pddl customer_happier.pddl -o obj_customer.pddl -v 0 -e 'experiments/customer_happy'

python run.py kitchen_customer_5.pddl customer_pay.pddl -o obj_customer.pddl -v 0 -e 'experiments/customer_happy'
python run.py kitchen_customer_6.pddl customer_pay.pddl -o obj_customer.pddl -v 0 -e 'experiments/customer_happy'

python tests/post_experiments.py experiments/customer_happy -sh tests/test_customer_happy.sh -r

