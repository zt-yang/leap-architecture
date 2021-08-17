# More objects -> Search time increases linearly

`test_objects.sh` tests the effect of increasing the number of objects on search complexity, with the same `kitchen_1.pddl` and `omelette_5.pddl`, i.e. full omelette:
* obj_1.pddl contains the bare minimum set of objects
* obj_2.pddl contains some alternative objects 
* obj_3.pddl contains 12 eggs
* obj_4.pddl contains multiples (two) of every object
* obj_5.pddl contains multiples (ten) of every object
* obj_eggs.pddl contains all objects for making 10 egg recipes

```
     t  problem_name      var    op    axiom    plan    parse     search    state
------  --------------  -----  ----  -------  ------  -------  ---------  -------
085837  obj_1.pddl         66  1004       11      48    0.61   0.0164124      243
085839  obj_2.pddl         72  1626       14      53    1.448  0.0181531      215
085843  obj_3.pddl        102  3086       44      53    3.889  0.0320748      215
085855  obj_4.pddl        116  9510       46      50   11.723  0.0407923      219
085909  obj_eggs.pddl     115  5416      102      50   13.549  0.031977       219
```