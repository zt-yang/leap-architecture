
## test different modes of FD
chmod +x test_FD.sh
./test_FD.sh

chmod +x test_logistics.sh
./test_logistics.sh

## with kitchen_1.pddl and obj_1.pddl, i.e. minimum operators & objects
chmod +x test_goals.sh
./test_goals.sh


## with kitchen_1.pddl and omelette_5.pddl, i.e. full omelette
chmod +x test_objects.sh
./test_objects.sh


## with kitchen_3.pddl and obj_eggs.pddl, i.e. all operators & objects for egg recipes
chmod +x test_egg_recipes.sh
./test_egg_recipes.sh

chmod +x test_egg_recipes_m.sh
./test_egg_recipes_m.sh

chmod +x test_egg_recipes_l.sh
./test_egg_recipes_l.sh

chmod +x test_egg_recipes_xl.sh
./test_egg_recipes_xl.sh

chmod +x test_egg_recipes_xxl.sh
./test_egg_recipes_xxl.sh


## serve domain
chmod +x test_serve_enable.sh
./test_serve_enable.sh

chmod +x test_serve_declare.sh
./test_serve_declare.sh

chmod +x test_serve_multiple.sh
./test_serve_multiple.sh

chmod +x test_customer_happy.sh
./test_customer_happy.sh


## big complex hierarhically combined domain

chmod +x test_merge.sh
./test_merge.sh

chmod +x test_grocery.sh
./test_grocery.sh