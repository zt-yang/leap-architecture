
## test different modes of FD
chmod +x tests/test_FD.sh
./tests/test_FD.sh

chmod +x tests/test_logistics.sh
./tests/test_logistics.sh

## with kitchen_1.pddl and obj_1.pddl, i.e. minimum operators & objects
chmod +x tests/test_goals.sh
./tests/test_goals.sh


## with kitchen_1.pddl and omelette_5.pddl, i.e. full omelette
chmod +x tests/test_objects.sh
./tests/test_objects.sh


## with kitchen_3.pddl and obj_eggs.pddl, i.e. all operators & objects for egg recipes
chmod +x tests/test_egg_recipes.sh
./tests/test_egg_recipes.sh

chmod +x tests/test_egg_recipes_m.sh
./tests/test_egg_recipes_m.sh

chmod +x tests/test_egg_recipes_l.sh
./tests/test_egg_recipes_l.sh

chmod +x tests/test_egg_recipes_xl.sh
./tests/test_egg_recipes_xl.sh

chmod +x tests/test_egg_recipes_xxl.sh
./tests/test_egg_recipes_xxl.sh


## serve domain
chmod +x tests/test_serve_enable.sh
./tests/test_serve_enable.sh

chmod +x tests/test_serve_declare.sh
./tests/test_serve_declare.sh

chmod +x tests/test_serve_multiple.sh
./tests/test_serve_multiple.sh

chmod +x tests/test_customer_happy.sh
./tests/test_customer_happy.sh


## big complex hierarhically combined domain

chmod +x tests/test_merge.sh
./tests/test_merge.sh

chmod +x tests/test_grocery.sh
./tests/test_grocery.sh

chmod +x tests/test_merged_customer.sh
./tests/test_merged_customer.sh


## strategists

chmod +x tests/test_iobig.sh
./tests/test_iobig.sh

chmod +x tests/test_sdbig.sh
./tests/test_sdbig.sh