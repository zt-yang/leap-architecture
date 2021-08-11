
## with kitchen_1.pddl and obj_1.pddl, i.e. minimum operators & objects
chmod +x test_goals.sh
./test_goals.sh

## with kitchen_1.pddl and omelette_5.pddl, i.e. full omelette
chmod +x test_objects.sh
./test_objects.sh

## with kitchen_2.pddl and obj_eggs.pddl, i.e. with maintanance goals and all objects for egg recipes
chmod +x test_egg_recipes.sh
./test_egg_recipes.sh

## with the same omelette.pddl and obj_1.pddl, i.e. minimum objects
chmod +x test_operators.sh
./test_operators.sh