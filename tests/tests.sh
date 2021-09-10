
## test different modes of FD
chmod +x tests/test_FD.sh
./tests/test_FD.sh 2> /dev/null

chmod +x tests/test_logistics.sh
./tests/test_logistics.sh 2> /dev/null

## with kitchen_1.pddl and obj_1.pddl, i.e. minimum operators & objects
chmod +x tests/test_goals.sh
./tests/test_goals.sh 2> /dev/null


## with kitchen_1.pddl and omelette_5.pddl, i.e. full omelette
chmod +x tests/test_objects.sh
./tests/test_objects.sh 2> /dev/null


## with kitchen_3.pddl and obj_eggs.pddl, i.e. all operators & objects for egg recipes
chmod +x tests/test_egg_recipes.sh
./tests/test_egg_recipes.sh 2> /dev/null

chmod +x tests/test_egg_recipes_m.sh
./tests/test_egg_recipes_m.sh 2> /dev/null

chmod +x tests/test_egg_recipes_l.sh
./tests/test_egg_recipes_l.sh 2> /dev/null

chmod +x tests/test_egg_recipes_xl.sh
./tests/test_egg_recipes_xl.sh 2> /dev/null

chmod +x tests/test_egg_recipes_xxl.sh
./tests/test_egg_recipes_xxl.sh 2> /dev/null


## serve domain
chmod +x tests/test_serve_enable.sh
./tests/test_serve_enable.sh 2> /dev/null

chmod +x tests/test_serve_declare.sh
./tests/test_serve_declare.sh 2> /dev/null

chmod +x tests/test_serve_multiple.sh
./tests/test_serve_multiple.sh 2> /dev/null

chmod +x tests/test_customer_happy.sh
./tests/test_customer_happy.sh 2> /dev/null


## big complex hierarhically combined domain

chmod +x tests/test_merge.sh
./tests/test_merge.sh 2> /dev/null

chmod +x tests/test_grocery.sh
./tests/test_grocery.sh 2> /dev/null

chmod +x tests/test_merged_customer.sh
./tests/test_merged_customer.sh 2> /dev/null


## strategists

chmod +x tests/test_iobig.sh
./tests/test_iobig.sh 2> /dev/null

chmod +x tests/test_sdbig.sh
./tests/test_sdbig.sh 2> /dev/null

chmod +x tests/test_strategists.sh
./tests/test_strategists.sh 2> /dev/null