# More goal predicates -> Search time increases more than linearly

`test_goals.sh` tests the effect of increasing the number of goal predicates on search complexity, with the same `kitchen_1`.pddl and `obj_1`.pddl, i.e. minimum operators & objects:

* omelette_1.pddl has fried buttery eggs
* omelette_2.pddl has the egg beaten and folded
* omelette_3.pddl adds veggies
* omelette_4.pddl adds salt and pepper
* omelette_5.pddl adds nutmilk and chives --> Optimizing LAMA failed
* omelette_5a.pddl contains nutmilk and chives and no salt and pepper
* omelette_5b.pddl contains (exist-omelette)
* omelette_6.pddl contains one negative goal predicate --> Optimizing LAMA failed
* omelette_7.pddl contains two negative goal predicates --> Optimizing LAMA failed

```
     t  run_name                       var    op    axiom  plan    cost      parse  search      state
------  ---------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
110303  omelette_1, pln=lama_first      34   742       10  20      20        1.221  0.00202162  68
110313  omelette_1, pln=lama            34   742       10  16      16        1.336  0.03793621  (>8.71)
------  ---------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
110314  omelette_2, pln=lama_first      38   745       13  31      31        1.183  0.00387042  140
110324  omelette_2, pln=lama            38   745       13  21      21        1.403  0.04361057  (>8.64)
------  ---------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
110326  omelette_3, pln=lama_first      39   749       13  42      42        1.182  0.00434013  165
110336  omelette_3, pln=lama            39   749       13  25      25        1.333  0.04825091  (>8.71)
------  ---------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
110338  omelette_4, pln=lama_first      53   947       13  63      63        1.192  0.0119063   433
110348  omelette_4, pln=lama            53   947       13  48      48        1.449  0.05891371  (>8.60)
------  ---------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
110349  omelette_5, pln=lama_first      61  1199       13  55      55        1.199  0.0126142   348
110359  omelette_5, pln=lama            61  1199       13  -       -         1.308  (>8.75)     -
------  ---------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
110401  omelette_5a, pln=lama_first     47  1001       13  43      43        1.219  0.00722862  215
110411  omelette_5a, pln=lama           47  1001       13  38      38        1.299  0.05087042  (>8.75)
------  ---------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
110413  omelette_5b, pln=lama_first     58  1199       14  54      54        1.257  0.0210328   590
110423  omelette_5b, pln=lama           58  1199       14  50      50        1.322  0.06957221  (>8.72)
------  ---------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
110425  omelette_6, pln=lama_first      63  1199       15  55      55        1.183  0.0127868   348
110435  omelette_6, pln=lama            63  1199       15  -       -         1.343  (>8.70)     -
------  ---------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
110436  omelette_7, pln=lama_first      63  1199       15  55      55        1.184  0.0125673   348
110446  omelette_7, pln=lama            63  1199       15  -       -         1.302  (>8.74)     -
```

We want to investigate:

* why omelette_4 and omelette_5a were successful but omelette_5 wasn't
* why omelette_5b was successful but omelette_5 wasn't, when speicifying the same goal
* why omelette_6 and omelette_7 weren't successful