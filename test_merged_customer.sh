echo "Test how hierarchies of tasks increase search complexity"

rm -r experiments/merged_customer
mkdir experiments/merged_customer

## make customer_happy option 1: lambchop and omelette
python run.py grocery_costs.pddl shop_lambchop_egg_veggie.pddl -o obj_grocery_costs.pddl -v 0 -e 'experiments/merged_customer' -t 20
python run.py kitchen_happy.pddl lambchop_omelette.pddl -o obj_happy.pddl -v 0 -e 'experiments/merged_customer' -t 20
python run.py "grocery_costs.pddl+kitchen_happy.pddl" lambchop_omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_happy2.pddl" -v 0 -e 'experiments/merged_customer' -t 20

## make customer_happy option 2: lambchop and sunny
python run.py grocery_costs.pddl shop_lambchop_egg_bread.pddl -o obj_grocery_costs.pddl -v 0 -e 'experiments/merged_customer' -t 20
python run.py kitchen_happy.pddl lambchop_hole.pddl -o obj_happy.pddl -v 0 -e 'experiments/merged_customer' -t 20
python run.py "grocery_costs.pddl+kitchen_happy.pddl" lambchop_hole_extended.pddl -o "obj_grocery_costs.pddl+obj_happy2.pddl" -v 0 -e 'experiments/merged_customer' -t 20

## make customer_happy option 3: lambchop and sunny
python run.py grocery_costs.pddl shop_lambchop_egg_pot.pddl -o obj_grocery_costs.pddl -v 0 -e 'experiments/merged_customer' -t 20
python run.py kitchen_happy.pddl lambchop_poached.pddl -o obj_happy.pddl -v 0 -e 'experiments/merged_customer' -t 20
python run.py "grocery_costs.pddl+kitchen_happy.pddl" lambchop_poached_extended.pddl -o "obj_grocery_costs.pddl+obj_happy2.pddl" -v 0 -e 'experiments/merged_customer' -t 20

## make customer_happy
python run.py kitchen_happy.pddl customer_happy.pddl -o obj_happy.pddl -v 0 -e 'experiments/merged_customer' -t 20
python run.py "grocery_costs.pddl+kitchen_happy.pddl" customer_happy_extended.pddl -o "obj_grocery_costs.pddl+obj_happy2.pddl" -v 0 -e 'experiments/merged_customer' -t 20

## make customer_pay
python run.py kitchen_happy.pddl customer_pay.pddl -o obj_happy.pddl -v 0 -e 'experiments/merged_customer' -t 20
python run.py "grocery_costs.pddl+kitchen_happy.pddl" customer_pay_extended.pddl -o "obj_grocery_costs.pddl+obj_happy2.pddl" -v 0 -e 'experiments/merged_customer' -t 20


## make customer_happy option 1: lambchop and omelette
python run.py grocery_costs.pddl shop_lambchop_egg_veggie.pddl -o obj_grocery_costs.pddl -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'
python run.py kitchen_happy.pddl lambchop_omelette.pddl -o obj_happy.pddl -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'
python run.py "grocery_costs.pddl+kitchen_happy.pddl" lambchop_omelette_extended.pddl -o "obj_grocery_costs.pddl+obj_happy2.pddl" -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'

## make customer_happy option 2: lambchop and sunny
python run.py grocery_costs.pddl shop_lambchop_egg_bread.pddl -o obj_grocery_costs.pddl -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'
python run.py kitchen_happy.pddl lambchop_hole.pddl -o obj_happy.pddl -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'
python run.py "grocery_costs.pddl+kitchen_happy.pddl" lambchop_hole_extended.pddl -o "obj_grocery_costs.pddl+obj_happy2.pddl" -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'

## make customer_happy option 3: lambchop and sunny
python run.py grocery_costs.pddl shop_lambchop_egg_pot.pddl -o obj_grocery_costs.pddl -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'
python run.py kitchen_happy.pddl lambchop_poached.pddl -o obj_happy.pddl -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'
python run.py "grocery_costs.pddl+kitchen_happy.pddl" lambchop_poached_extended.pddl -o "obj_grocery_costs.pddl+obj_happy2.pddl" -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'

## make customer_happy
python run.py kitchen_happy.pddl customer_happy.pddl -o obj_happy.pddl -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'
python run.py "grocery_costs.pddl+kitchen_happy.pddl" customer_happy_extended.pddl -o "obj_grocery_costs.pddl+obj_happy2.pddl" -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'

## make customer_pay
python run.py kitchen_happy.pddl customer_pay.pddl -o obj_happy.pddl -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'
python run.py "grocery_costs.pddl+kitchen_happy.pddl" customer_pay_extended.pddl -o "obj_grocery_costs.pddl+obj_happy2.pddl" -v 0 -e 'experiments/merged_customer' -t 300 -po 'lama'

python generators/post_experiments.py experiments/merged_customer -sh test_merged_customer.sh -r

