# Merged domains

`test_merge.sh` tests the increase in planning time when multiple domains are merged together.


## Two separate domains + minimum objects

* timeout is 10 sec
* `shop_veggies.pddl` has the goal of `(in fridge veggie1)`
* `shop_lambchop.pddl` has the goal of `(in fridge veggie1)` and `(in fridge lambchop)`
* the initial state of combined domain is the initial state of both domains minus the goal of the grocery domain (`obj_grocery_costs+obj_extended2` and `obj_grocery_costs+obj_lambchop2`)


```python
     t  run_name                                                            var    op    axiom    plan    cost    parse       search  state
------  -------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
222715  grocery_costs, shop_veggies, lama_first, obj_grocery_costs       148   392      170       8      75    0.09   0.000394     11
222720  kitchen_extended, omelette, lama_first, obj_extended             187  2149       97      45      71    4.96   0.0258232    225
222727  grocery_costs+kitchen_extended, omelette_extended, lama_first    366  2616      272      58     155    5.823  0.0427716    305
------  -------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
222727  grocery_costs, shop_veggies, lama, obj_grocery_costs             148   392      170      18      67    0.093  0.0977727    3191
222738  kitchen_extended, omelette, lama, obj_extended                   187  2149       97      45      64    5.057  0.137848     (>4.99)
222748  grocery_costs+kitchen_extended, omelette_extended, lama          366  2616      272      58     155    5.816  0.177432     (>4.24)
------  -------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
222748  grocery_costs, shop_lambchop, lama_first, obj_grocery_costs      154   395      172      22     310    0.09   0.000909792  28
222758  kitchen_lambchop, omelette, lama_first, obj_lambchop             211  2924      110      45      71    9.227  0.0303339    225
222808  kitchen_lambchop, lambchop, lama_first, obj_lambchop             268  3556      113      71     117    9.06   0.0622388    384
222818  grocery_costs+kitchen_lambchop, omelette_lambchop, lama_first    445  3964      285      89     417    9.191  0.149499     942
------  -------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
222819  grocery_costs, shop_lambchop, lama, obj_grocery_costs            154   395      172      27     122    0.093  0.445976     12599
222829  kitchen_lambchop, omelette, lama, obj_lambchop                   211  2924      110      45      64    9.736  0.186976     (>0.32)
222839  kitchen_lambchop, lambchop, lama, obj_lambchop                   268  3556      113      67      98    9.154  0.26242      (>0.90)
222900  grocery_costs+kitchen_lambchop, omelette_lambchop, lama          445  3964      285     100     233    9.925  0.429303     (>10.13)
```


## Two interdependent domains + minimum objects

There're 2 ways to Make Customer Pay, each of which involves 3 combo meals, each of which includes 2 egg or lamb dishes, each of which requires purchase of different ingredients.

* timeout is 30 sec (`lama` can't finish search even when timeout is 300 sec)
* for simplifying the table, `grocery` is short for `grocery_costs.pddl`, `kitchen` is short for `kitchen.pddl`, 
* `shop_lambchop.pddl` has the goal of `(in fridge veggie1)` and `(in fridge lambchop)`
* the initial state of combined domain is the initial state of both domains minus the goal of the grocery domain (`obj_grocery_costs+obj_happy2` for all problems)


```python
     t  run_name                                                            var    op    axiom    plan    cost    parse       search  state
------  ----------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
011917  grocery, shop_lambchop_egg_veggie, lama_first, obj_grocery_costs    165   408      172      24     341    0.095   0.00105371  32
011927  kitchen, lambchop_omelette, lama_first, obj_happy                   290  3793      123      76     126    9.48    0.103596    601
011937  grocery+kitchen, lambchop_omelette_extended, lama_first             506  4224      299      97     458    9.657   0.170804    1042
------  ----------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
011938  grocery, shop_lambchop_egg_bread, lama_first, obj_grocery_costs     164   403      176      34     493    0.095   0.00176229  55
011948  kitchen, lambchop_hole, lama_first, obj_happy                       202  2670      117      54      88    9.519   0.0303301   217
011958  grocery+kitchen, lambchop_hole_extended, lama_first                 418  3101      293      92     613    9.594   0.103603    675
------  ----------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
011959  grocery, shop_lambchop_egg_pot, lama_first, obj_grocery_costs       160   403      172      28     401    0.093   0.00122154  38
012009  kitchen, lambchop_poached, lama_first, obj_happy                    264  3428      123      56      93    9.563   0.0663781   446
012019  grocery+kitchen, lambchop_poached_extended, lama_first              480  3859      299      91     501    9.551   0.224359    1247
------  ----------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
012029  kitchen, customer_happy, lama_first, obj_happy                      356  4397      136      63      99    9.508   0.0676363   392
012040  grocery+kitchen, customer_happy_extended, lama_first                572  4828      312      92     505    9.793   0.340019    1788
------  ----------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
012051  kitchen, customer_pay, lama_first, obj_happy                        364  4401      143      55      92    9.554   0.0931746   552
012101  grocery+kitchen, customer_pay_extended, lama_first                  580  4832      319      90     506    9.687   0.219314    1432
------  ----------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
------  ----------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
012116  grocery, shop_lambchop_egg_veggie, lama, obj_grocery_costs          165   408      172      29     133    0.098  14.2988      399417
012147  kitchen, lambchop_omelette, lama, obj_happy                         290  3793      123      67     100    9.801   0.299012    (>20.25)
012217  grocery+kitchen, lambchop_omelette_extended, lama                   506  4224      299     110     247    9.727   0.38173     (>20.33)
------  ----------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
012246  grocery, shop_lambchop_egg_bread, lama, obj_grocery_costs           164   403      176      36     157    0.095  27.7832      815333
012316  kitchen, lambchop_hole, lama, obj_happy                             202  2670      117      54      88    9.729   0.183835    (>20.33)
012346  grocery+kitchen, lambchop_hole_extended, lama                       418  3101      293     100     252    9.828   0.273357    (>20.23)
------  ----------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
012357  grocery, shop_lambchop_egg_pot, lama, obj_grocery_costs             160   403      172      30     137    0.094  10.4946      321486
012427  kitchen, lambchop_poached, lama, obj_happy                          264  3428      123      53      84    9.673   0.242294    (>20.38)
012458  grocery+kitchen, lambchop_poached_extended, lama                    480  3859      299      92     231    9.853   0.40539     (>20.21)
------  ----------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
012528  kitchen, customer_happy, lama, obj_happy                            356  4397      136      56      84    9.631   0.278214    (>20.42)
012559  grocery+kitchen, customer_happy_extended, lama                      572  4828      312     108     245    9.658   0.501497    (>20.40)
------  ----------------------------------------------------------------  -----  ----  -------  ------  ------  -------  -----------  --------
012629  kitchen, customer_pay, lama, obj_happy                              364  4401      143      54      78    9.563   0.243385    (>20.49)
012700  grocery+kitchen, customer_pay_extended, lama                        580  4832      319     121     307    9.944   0.360204    (>20.12)
```