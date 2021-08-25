# More operators -> Search time increases linearly

`test_operators` tests the effect of increasing the number of operators (for multiple recipes) on search complexity, with the same `omelette.pddl` and `obj_1.pddl`, i.e. minimum plan length & objects:

* kitchen_1.pddl contains all operators for omelette recipe
* kitchen_2.pddl contains all operators for omelette + maintanance goals
* kitchen_3.pddl contains all operators & definitions for 10 egg recipes
* kitchen_4.pddl contains all operators & definitions for 10 egg recipes, with different action costs that reflect time costs
* kitchen_5.pddl contains all operators & definitions for egg & baking recipes, with different action costs that reflect time costs

```
     t  problem_name                                           var    op    axiom    plan    parse     search    state
------  ---------------------------------------------------  -----  ----  -------  ------  -------  ---------  -------
090721  kitchen_1-omelette_5-obj_1.pddl-omelette_5.pddl         66  1004       11      48    0.659  0.0181792      243
090722  kitchen_2-omelette-obj_1.pddl-omelette.pddl             70  1004       27      64    0.61   0.0349843      519
090733  kitchen_egg_4-omelette-obj_egg_4.pddl-omelette.pddl    350  6680      161      52   10.058  0.115542       711
```

> TODO: change the `obj_1.pddl` here to `obj_4`.pddl and `obj_eggs.pddl` to make the problem combinatorially complicated