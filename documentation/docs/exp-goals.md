# More goal predicates -> Search time increases more than linearly

`test_goals.sh` tests the effect of increasing the number of goal predicates on search complexity, with the same `kitchen_1`.pddl and `obj_1`.pddl, i.e. minimum operators & objects:

* omelette_1.pddl has only eggs
* omelette_2.pddl adds veggies
* omelette_3.pddl adds salt and pepper
* omelette_4.pddl adds nutmilk and chives
* omelette_5.pddl contains all positive goal predicates without any use of axioms
* omelette_6.pddl contains one negative goal predicate
* omelette_7.pddl contains two negative goal predicates

```
     t  problem_name       var    op    axiom    plan    parse      search    state
------  ---------------  -----  ----  -------  ------  -------  ----------  -------
085529  omelette_1.pddl     39   700        8      16    0.632  0.0016525        29
085530  omelette_2.pddl     43   702       11      20    0.618  0.00334604       40
085531  omelette_3.pddl     44   703       11      24    0.666  0.00299829       48
085532  omelette_4.pddl     58   843       11      50    0.675  0.0119693       246
085533  omelette_5.pddl     66  1004       11      48    0.598  0.0155517       243
085534  omelette_6.pddl     68  1004       13      64    0.579  0.0691776      1134
085535  omelette_7.pddl     68  1004       13      64    0.592  0.0721683      1134
```