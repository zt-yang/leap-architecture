# Different egg recipes -> Search time corresponds to # of axioms and depth of search, instead of # of operators or length of plan

## Experiment Design

`test_egg_recipes_*.sh` tests the search complexity of 5 different egg-related recipes, with increasingly large domain (i.e. types, predicates, operators, axioms) and environments (i.e. objects). 

The five recipes include:

* `omelette.pddl` specifies beaten, folded eggs with veggies
* `scrambled_eggs.pddl` specifies beaten, scrambled eggs
* `sunny_side_up.pddl` specifies fried, steamed eggs on frypan
* `egg_in_hole.pddl` specifies fried egg in the hole of a bread
* `poached_egg.pddl` specifies boiled egg with vinegar

The five domains include:

* `kitchen_egg_1` contains the minumum of knowledge for making omelette
* `kitchen_egg_2` contains the minumum of knowledge for making omelette, scrambled_eggs
* `kitchen_egg_3` contains the minumum of knowledge for making omelette, scrambled_eggs, sunny_side_up
* `kitchen_egg_4` contains the minumum of knowledge for making omelette, scrambled_eggs, sunny_side_up, egg_in_hole
* `kitchen_egg_5` contains the minumum of knowledge for making omelette, scrambled_eggs, sunny_side_up, egg_in_hole, and poached_egg

The five sets of objects include:

* `obj_0`, `obj_egg_4`, and `obj_egg_5` contain the minimum set of objects for `kitchen_egg_1`, `kitchen_egg_4` and `kitchen_egg_5` 
* `obj_3`, `obj_egg_4_m`, and `obj_egg_5_m` contain 10 eggs and 10 veggies
* `obj_4`, `obj_egg_4_l`, and `obj_egg_5_l` contain 2 copies of every utensil
* `obj_4_xl`, `obj_egg_4_xl`, and `obj_egg_5_xl` contain both (1) 10 eggs and 10 veggies, and (2) 2 copies of every utensil
* `obj_4_xxl`, `obj_egg_4_xxl`, and `obj_egg_5_xxl` contain both (1) 10 eggs and 10 veggies, and (2) 4 copies of every utensil 

## Experiment Results

Summary of results:

* with the minimum domain and object set, FD can solve a recipe within 0.001s
* when the environment contains both extended ingredients (e.g. eggs) and utensils (e.g. pans)

Note:

* rows with `-` means exceeding 5 min timeout
* blank rows means running out of memory during instantiation, which results in failed planning
* `var`, `op`, `axiom` columns contain the number of variables, operators, and axioms used during planning
* `plan` column contain the length of searched plan
* `cost` column contain the total cost of the plan (unit cost for now)
* `parse`, `search` columns contain the timer in seconds for the parsing and search procedures 
* `state` column contain number of states expanded

<!--
* run_name with `gi=` means the specified goal is ignored (i.e., deleted) from the problem file
-->

### When the environment conians the minumum sets of objects:

```python
     t  run_name                                         var    op    axiom    plan    cost    parse      search    state
------  ---------------------------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
210933  kitchen_egg_1, omelette, obj_0.pddl               60   932       27      47      47    0.511  0.0102195       165
210934  kitchen_egg_2, omelette, obj_0.pddl               60   932       27      47      47    0.506  0.0102126       165
210935  kitchen_egg_3, omelette, obj_0.pddl               60   932       27      47      47    0.501  0.0103028       165
210939  kitchen_egg_4, omelette, obj_egg_4.pddl           91  2507      109      47      47    3.914  0.0372211       396
210943  kitchen_egg_5, omelette, obj_egg_4.pddl          176  2409      109      53      53    4.182  0.0226506       253
------  ---------------------------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
210944  kitchen_egg_2, scrambled_eggs, obj_0.pddl         56   931       27      41      41    0.518  0.0106634       167
210945  kitchen_egg_3, scrambled_eggs, obj_0.pddl         56   931       27      41      41    0.513  0.0111647       167
210949  kitchen_egg_4, scrambled_eggs, obj_egg_4.pddl     86  2504      109      41      41    3.847  0.0299068       316
210953  kitchen_egg_5, scrambled_eggs, obj_egg_4.pddl    160  2296      109      47      47    3.889  0.0275968       299
------  ---------------------------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
210957  kitchen_egg_3, sunny_side_up, obj_egg_4.pddl      55  2035       69      28      28    3.777  0.00625692       79
211002  kitchen_egg_4, sunny_side_up, obj_egg_4.pddl      71  2048      106      28      28    4.012  0.00861308      113
211006  kitchen_egg_5, sunny_side_up, obj_egg_4.pddl     125  1800      106      30      30    4.004  0.00890017      106
------  ---------------------------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
211011  kitchen_egg_4, egg_in_hole, obj_egg_4.pddl        74  2051      107      30      30    4.467  0.00610388       89
211016  kitchen_egg_5, egg_in_hole, obj_egg_4.pddl       139  1913      107      30      30    4.06   0.00703404       89
------  ---------------------------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
211022  kitchen_egg_5, poached_egg, obj_egg_5.pddl       154  2273       76      22      22    6.156  0.00708321       85
```

### When the environment contains 10 eggs and 10 veggies:

```python
     t  run_name                                           var    op    axiom    plan    cost    parse     search    state
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
211058  kitchen_egg_1, omelette, obj_3.pddl                294  3542      198      47      47    3.094  0.0526419      424
211102  kitchen_egg_2, omelette, obj_3.pddl                294  3542      198      47      47    2.944  0.0616637      424
211105  kitchen_egg_3, omelette, obj_3.pddl                294  3542      198      47      47    3.019  0.0565081      424
211118  kitchen_egg_4, omelette, obj_egg_4_m.pddl          343  7529      316      56      56   12.792  0.0668754      404
211133  kitchen_egg_5, omelette, obj_egg_4_m.pddl          626  7431      298      56      56   13.545  0.0705151      411
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
211136  kitchen_egg_2, scrambled_eggs, obj_3.pddl          254  3532      108      40      40    2.903  0.0366719      308
211139  kitchen_egg_3, scrambled_eggs, obj_3.pddl          254  3532      108      40      40    2.894  0.0412128      308
211152  kitchen_egg_4, scrambled_eggs, obj_egg_4_m.pddl    293  7499      226      49      49   12.401  0.0757157      376
211205  kitchen_egg_5, scrambled_eggs, obj_egg_4_m.pddl    466  6301      208      49      49   12.471  0.0562253      378
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
211217  kitchen_egg_3, sunny_side_up, obj_egg_4_m.pddl     136  5896      141      27      27   11.877  0.0155547      114
211229  kitchen_egg_4, sunny_side_up, obj_egg_4_m.pddl     161  6008      196      33      33   11.721  0.0161065      127
211242  kitchen_egg_5, sunny_side_up, obj_egg_4_m.pddl     314  4770      178      33      33   12.421  0.0177018      132
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
211255  kitchen_egg_4, egg_in_hole, obj_egg_4_m.pddl       137  5984      206      30      30   12.555  0.01446        111
211308  kitchen_egg_5, egg_in_hole, obj_egg_4_m.pddl       202  3866      188      30      30   12.363  0.0149113      117
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
211326  kitchen_egg_5, poached_egg, obj_egg_5_m.pddl       325  5288      130      22      22   17.672  0.012724        87
```

### When the environment contains 2 copies of every utensil:

```python
     t  run_name                                         var    op    axiom    plan    cost    parse    search     state
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
214116  kitchen_egg_1, omelette, obj_4.pddl              124    2849  29       68      68      1.667    0.068268   680
214118  kitchen_egg_2, omelette, obj_4.pddl              124    2849  29       68      68      1.658    0.0702724  680
214120  kitchen_egg_3, omelette, obj_4.pddl              124    2849  29       68      68      1.673    0.0694334  680
214133  kitchen_egg_4, omelette, obj_egg_4_l.pddl        221    7611  214      61      61      12.611   0.144819   798
214147  kitchen_egg_5, omelette, obj_egg_4_l.pddl        286    7193  214      61      61      13.244   0.140403   795
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
214149  kitchen_egg_2, scrambled_eggs, obj_4.pddl        120    2847  29       41      41      1.671    0.0206573  257
214151  kitchen_egg_3, scrambled_eggs, obj_4.pddl        120    2847  29       41      41      1.681    0.0220964  257
214231  kitchen_egg_4, scrambled_eggs, obj_egg_4_l.pddl  216    7605  214      -       -       -        -
214613  kitchen_egg_5, scrambled_eggs, obj_egg_4_l.pddl
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
214626  kitchen_egg_3, sunny_side_up, obj_egg_4_l.pddl   135    6008  144      29      29      12.612   0.0185011  147
214639  kitchen_egg_4, sunny_side_up, obj_egg_4_l.pddl   161    6031  211      39      39      12.586   0.0221366  166
214653  kitchen_egg_5, sunny_side_up, obj_egg_4_l.pddl   205    5053  211      39      39      13.067   0.0255738  189
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
214706  kitchen_egg_4, egg_in_hole, obj_egg_4_l.pddl     164    6037  213      42      42      13.148   0.0352553  320
214720  kitchen_egg_5, egg_in_hole, obj_egg_4_l.pddl     229    5479  213      42      42      13.249   0.0364352  323
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
214741  kitchen_egg_5, poached_egg, obj_egg_5_l.pddl     251    6743  125      22      22      20.288   0.0145595  87
```

### When the environment contains both 10 eggs & veggies and 2 copies of every utensil:

```python
     t  run_name                                          var    op     axiom    plan    cost    parse    search     state
------  ------------------------------------------------  -----  -----  -------  ------  ------  -------  ---------  -------
063459  kitchen_egg_1, omelette, obj_4_xl.pddl            358    9419   299      51      51      12.865   0.41591    1618
063510  kitchen_egg_2, omelette, obj_4_xl.pddl            358    9419   299      51      51      10.020   0.300098   1618
063520  kitchen_egg_3, omelette, obj_4_xl.pddl            358    9419   299      51      51      9.076    0.312746   1618
063603  kitchen_egg_4, omelette, obj_egg_4_xl.pddl        473    20769  538      51      51      41.736   0.555485   1198
063650  kitchen_egg_5, omelette, obj_egg_4_xl.pddl        916    20351  520      51      51      45.486   0.433745   1250
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
063702  kitchen_egg_2, scrambled_eggs, obj_4_xl.pddl      318    9399   119      49      49      9.801    2.03623    11475
063714  kitchen_egg_3, scrambled_eggs, obj_4_xl.pddl      318    9399   119      49      49      9.362    1.99511    11475
064214  kitchen_egg_4, scrambled_eggs, obj_egg_4_xl.pddl  423    20709  358      -       -       -        -
064715  kitchen_egg_5, scrambled_eggs, obj_egg_4_xl.pddl
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
064759  kitchen_egg_3, sunny_side_up, obj_egg_4_xl.pddl   216    16304  243      28      28      43.585   0.0399582  176
064843  kitchen_egg_4, sunny_side_up, obj_egg_4_xl.pddl   251    16498  328      32      32      43.429   0.062769   223
064927  kitchen_egg_5, sunny_side_up, obj_egg_4_xl.pddl   484    11740  310      32      32      43.212   0.0515667  233
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
065014  kitchen_egg_4, egg_in_hole, obj_egg_4_xl.pddl     227    16450  348      40      40      45.568   0.0986753  342
065059  kitchen_egg_5, egg_in_hole, obj_egg_4_xl.pddl     292    8332   330      40      40      44.505   0.0635933  348
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
065203  kitchen_egg_5, poached_egg, obj_egg_5_xl.pddl     521    13889  179      22      22      63.058   0.0241492  89
```

### When the environment contains both 10 eggs & veggies and 4 copies of every utensil:

```python
     t  run_name                                           var    op     axiom    plan    cost    parse    search    state
------  -------------------------------------------------  -----  -----  -------  ------  ------  -------  --------  -------
065450  kitchen_egg_1, omelette, obj_4_xxl.pddl            444    32749  501      51      51      40.412   0.507984  1109
065531  kitchen_egg_2, omelette, obj_4_xxl.pddl            444    32749  501      51      51      38.870   0.545349  1109
065611  kitchen_egg_3, omelette, obj_4_xxl.pddl            444    32749  501      51      51      38.807   0.507466  1109
070053  kitchen_egg_4, omelette, obj_egg_4_xxl.pddl        633    68565  1086     51      51      278.485  1.10617   1198
070403  kitchen_egg_5, omelette, obj_egg_4_xxl.pddl        1496   66847  1068     51      51      186.607  1.09691   1250
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
070447  kitchen_egg_2, scrambled_eggs, obj_4_xxl.pddl      404    32709  141      49      49      39.293   2.88542   6592
070530  kitchen_egg_3, scrambled_eggs, obj_4_xxl.pddl      404    32709  141      49      49      39.271   2.92493   6592
071030  kitchen_egg_4, scrambled_eggs, obj_egg_4_xxl.pddl  583    68445  726      -       -       -        -
071531  kitchen_egg_5, scrambled_eggs, obj_egg_4_xxl.pddl  1036   50327  708      -       -       -        -
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
071959  kitchen_egg_3, sunny_side_up, obj_egg_4_xxl.pddl   316    54536  551      28      28      265.509  0.153392  176
072500  kitchen_egg_4, sunny_side_up, obj_egg_4_xxl.pddl
073000  kitchen_egg_5, sunny_side_up, obj_egg_4_xxl.pddl
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
073501  kitchen_egg_4, egg_in_hole, obj_egg_4_xxl.pddl
074003  kitchen_egg_5, egg_in_hole, obj_egg_4_xxl.pddl
------  -----------------------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
074005  kitchen_egg_5, poached_egg, obj_egg_5_xxl.pddl
```

## Five egg recipes and plans by FD

### Omelette

```lisp
  ( :derived ( exist-omelette ?env - env )
    ( exists 
      ( ?egg1 - egg ?veggies1 - ingredient ?plate1 - plate )
      ( and 
        ( inside ?plate1 ?egg1 )
        ( beaten ?egg1 )
        ( fried ?egg1 )
        ( folded ?egg1 )
        ( is-buttery ?egg1 )

        ( fried ?veggies1 )
        ( sauteed ?veggies1 )

        ( has-seasoning ?egg1 nutmilk cup two )

        ( has-seasoning ?egg1 chives tablespoon2 two )
        ( seasoning-mixed ?egg1 chives )

        ( has-seasoning ?egg1 salt gram two )
        ( seasoning-mixed ?egg1 salt )

        ( has-seasoning ?egg1 pepper gram two )
        ( seasoning-mixed ?egg1 pepper )
      )
    )
  )
```

The plan of making an Omelette (length = 47):

```python
pickup fork1 kitchentop robot (1)
open fridge (1)
getout milkbottle1 fridge robot (1)
getout butter fridge robot (1)
getout egg1 fridge robot (1)
getout veggies1 fridge robot (1)
close fridge (1)
crack-egg egg1 smallbowl1 robot (1)
add-ingredient butter smallbowl1 robot (1)
open dcup1 (1)
getout frypan1 dcup1 robot (1)
close dcup1 (1)
add-ingredient veggies1 smallbowl1 robot (1)
mix egg1 fork1 smallbowl1 robot (1)
putdown frypan1 burner robot (1)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
pickup tablespoon1 kitchentop robot (1)
season egg1 salt salter1 tablespoon1 robot (1)
season egg1 pepper shaker1 tablespoon1 robot (1)
mix egg1 fork1 smallbowl1 robot (1)
season egg1 chives container1 tablespoon1 robot (1)
mix egg1 fork1 smallbowl1 robot (1)
season egg1 chives container1 tablespoon1 robot (1)
putdown tablespoon1 burner robot (1)
pickup smallbowl1 kitchentop robot (1)
transfer butter smallbowl1 frypan1 robot (1)
transfer egg1 smallbowl1 frypan1 robot (1)
transfer veggies1 smallbowl1 frypan1 robot (1)
putdown smallbowl1 burner robot (1)
switchon burner frypan1 (1)
fry egg1 frypan1 burner butter (1)
fry veggies1 frypan1 burner butter (1)
switchoff burner frypan1 (1)
pickup spatula1 kitchentop robot (1)
fold egg1 frypan1 spatula1 robot (1)
putdown spatula1 burner robot (1)
pickup frypan1 burner robot (1)
transfer egg1 frypan1 plate1 robot (1)
putdown milkbottle1 burner robot (1)
pickup salter1 kitchentop robot (1)
sprinkle egg1 salt salter1 gram robot (1)
sprinkle egg1 salt salter1 gram robot (1)
putdown salter1 burner robot (1)
pickup shaker1 kitchentop robot (1)
sprinkle egg1 pepper shaker1 gram robot (1)
sprinkle egg1 pepper shaker1 gram robot (1)
```

### Scrambled eggs

```lisp
  ( :derived ( exist-scrambled-eggs ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate )
      ( and 
        ( inside ?plate1 ?egg1 )
        ( beaten ?egg1 )
        ( fried ?egg1 )
        ( scrambled ?egg1 )
        ( is-buttery ?egg1 )

        ( has-seasoning ?egg1 nutmilk cup two )

        ( has-seasoning ?egg1 chives tablespoon1 one )
        ( seasoning-mixed ?egg1 chives )

        ( has-seasoning ?egg1 salt gram one )
        ( seasoning-mixed ?egg1 salt )

        ( has-seasoning ?egg1 pepper gram one )
        ( seasoning-mixed ?egg1 pepper )
      )
    )
  )
```
The plan of making Scrambled eggs (length = 41):


```python
pickup fork1 kitchentop robot (1)
open fridge (1)
getout milkbottle1 fridge robot (1)
getout butter fridge robot (1)
getout egg1 fridge robot (1)
close fridge (1)
crack-egg egg1 smallbowl1 robot (1)
open dcup1 (1)
getout frypan1 dcup1 robot (1)
close dcup1 (1)
add-ingredient butter smallbowl1 robot (1)
mix egg1 fork1 smallbowl1 robot (1)
putdown frypan1 burner robot (1)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
pickup tablespoon1 kitchentop robot (1)
season egg1 chives container1 tablespoon1 robot (1)
mix egg1 fork1 smallbowl1 robot (1)
putdown tablespoon1 burner robot (1)
pickup spatula1 kitchentop robot (1)
putdown spatula1 burner robot (1)
pickup salter1 kitchentop robot (1)
sprinkle egg1 salt salter1 gram robot (1)
mix egg1 fork1 smallbowl1 robot (1)
putdown salter1 burner robot (1)
pickup shaker1 kitchentop robot (1)
sprinkle egg1 pepper shaker1 gram robot (1)
mix egg1 fork1 smallbowl1 robot (1)
putdown shaker1 burner robot (1)
pickup smallbowl1 kitchentop robot (1)
transfer butter smallbowl1 frypan1 robot (1)
transfer egg1 smallbowl1 frypan1 robot (1)
switchon burner frypan1 (1)
fry egg1 frypan1 burner butter (1)
switchoff burner frypan1 (1)
putdown smallbowl1 burner robot (1)
pickup spatula1 burner robot (1)
scrape egg1 frypan1 spatula1 robot (1)
putdown spatula1 burner robot (1)
pickup frypan1 burner robot (1)
transfer egg1 frypan1 plate1 robot (1)
```

### Sunny Side Up

```lisp
  ( :derived ( exist-sunny-side-up ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate )
      ( and 
        ( inside ?plate1 ?egg1 )
        ( fried ?egg1 )
        ( is-buttery ?egg1 )
        ( steamed ?egg1 ) 
        ( has-seasoning ?egg1 salt gram one )
        ( has-seasoning ?egg1 pepper gram one )
      )
    )
  )
```

The plan of making a Sunny Side Up (length = 28):

```python
pickup salter1 kitchentop robot (1)
sprinkle egg1 salt salter1 gram robot (1)
open fridge (1)
getout egg1 fridge robot (1)
close fridge (1)
crack-egg egg1 smallbowl1 robot (1)
open dcup2 (1)
getout oilbottle1 dcup2 robot (1)
close dcup2 (1)
transfer oliveoil oilbottle1 frypan1 robot (1)
open dcup1 (1)
getout frypan1 dcup1 robot (1)
getout pancover1 dcup1 robot (1)
close dcup1 (1)
putdown frypan1 burner robot (1)
pickup shaker1 kitchentop robot (1)
sprinkle egg1 pepper shaker1 gram robot (1)
putdown shaker1 burner robot (1)
pickup smallbowl1 kitchentop robot (1)
transfer egg1 smallbowl1 frypan1 robot (1)
switchon burner frypan1 (1)
fry egg1 frypan1 burner oliveoil (1)
puton pancover1 frypan1 robot (1)
steam egg1 frypan1 burner (1)
pickup frypan1 burner robot (1)
transfer egg1 frypan1 plate1 robot (1)
putdown frypan1 burner robot (1)
switchoff burner frypan1 (1)
```

### Egg in a Hole


```lisp
  ( :derived ( exist-egg-in-hole ?env - env )
    ( exists 
      ( ?egg1 - egg ?bread1 - bread ?plate1 - plate )
      ( and 
        ( inside ?plate1 ?bread1 )
        ( has-hole ?bread1 circle )
        ( in-hole ?egg1 ?bread1 ) 
        ( fried ?bread1 )
        ( is-buttery ?bread1 ) 
        ( has-seasoning ?egg1 salt gram one )
        ( has-seasoning ?egg1 pepper gram one )
      )
    )
  )
```

The plan of making an Egg in a Hole (length = 30):

```python
pickup holecutter1 kitchentop robot (1)
make-hole bread1 holecutter1 circle robot (1)
open fridge (1)
getout butter fridge robot (1)
getout egg1 fridge robot (1)
close fridge (1)
crack-egg egg1 bread1 robot (1)
add-ingredient butter smallbowl1 robot (1)
open dcup1 (1)
getout frypan1 dcup1 robot (1)
close dcup1 (1)
putdown frypan1 burner robot (1)
pickup salter1 kitchentop robot (1)
sprinkle egg1 salt salter1 gram robot (1)
putdown salter1 burner robot (1)
pickup shaker1 kitchentop robot (1)
sprinkle egg1 pepper shaker1 gram robot (1)
putdown shaker1 burner robot (1)
pickup bread1 kitchentop robot (1)
add-ingredient bread1 smallbowl1 robot (1)
putdown holecutter1 burner robot (1)
pickup smallbowl1 kitchentop robot (1)
transfer butter smallbowl1 frypan1 robot (1)
transfer bread1 smallbowl1 frypan1 robot (1)
switchon burner frypan1 (1)
fry bread1 frypan1 burner butter (1)
switchoff burner frypan1 (1)
putdown smallbowl1 burner robot (1)
pickup frypan1 burner robot (1)
transfer bread1 frypan1 plate1 robot (1)
```

### Poached Egg

```lisp
  ( :derived ( exist-poached-egg ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate )
      ( and 
        ( boiled water )
        ( boiled ?egg1 )
        ( hardness ?egg1 outerside medium-hard )

        ( has-vinegar water ) ; helps the whites set at a lower temperature while keeping the yolks runny

        ;( hardness ?egg1 innerside soft ) ; encode cooking knowledge / causal models into operators and axoims
      )
    )
  )
```

The plan of making a Poached Egg (length = 22):

```
open dcup1 (1)
turn-tap-on faucet (1)
getout pot1 dcup1 robot (1)
add-liquid water faucet pot1 robot (1)
turn-tap-off faucet (1)
open fridge (1)
getout egg1 fridge robot (1)
close fridge (1)
close dcup1 (1)
crack-egg egg1 smallbowl1 robot (1)
putdown pot1 burner robot (1)
pickup smallbowl1 kitchentop robot (1)
transfer egg1 smallbowl1 pot1 robot (1)
open dcup2 (1)
getout mediumbottle1 dcup2 robot (1)
close dcup2 (1)
switchon burner pot1 (1)
change-level burner medium (1)
pour-liquid whitevinegar mediumbottle1 pot1 robot (1)
boil water pot1 burner (1)
boil water pot1 burner (1)
switchoff burner pot1 (1)
```

---

## Previous weird results about `is-buttery`

when (at-level high) and (not (is-liquid) param1) exists


### When the environment contains 10 eggs and 10 veggies:

```python
     t  run_name                                                   var    op    axiom    plan    parse    search     state
------  ---------------------------------------------------------  -----  ----  -------  ------  -------  ---------  -------
203618  kitchen_egg_1, omelette, obj_3,                            294    3542  198      47      3.417    0.0560734  424
203622  kitchen_egg_2, omelette, obj_3,                            294    3542  198      47      3.488    0.0572367  424
203626  kitchen_egg_3, omelette, obj_3,                            294    3542  198      47      3.305    0.0700046  424
203641  kitchen_egg_4, omelette, obj_egg_4_m,                      343    7529  316      56      14.740   0.0778197  404
204142  kitchen_egg_5, omelette, obj_egg_4_m,                      633    7433  334      -       -        -          -
204159  kitchen_egg_5, omelette, obj_egg_4_m, gi=is_buttery        623    7433  334      52      15.474   0.191407   811
------  -------------------------------------------------------  -----  ----  -------  ------  -------  ----------  -------
204203  kitchen_egg_2, scrambled_eggs, obj_3,                      254    3532  108      40      3.451    0.0562847  308
204207  kitchen_egg_3, scrambled_eggs, obj_3,                      254    3532  108      40      3.683    0.0531232  308
204223  kitchen_egg_4, scrambled_eggs, obj_egg_4_m,                293    7499  226      49      15.020   0.0699502  376
204723  kitchen_egg_5, scrambled_eggs, obj_egg_4_m,                473    6303  244      -       -        -          -
204742  kitchen_egg_5, scrambled_eggs, obj_egg_4_m, gi=is_buttery  463    6303  244      42      17.691   0.126726   482
------  -------------------------------------------------------  -----  ----  -------  ------  -------  ----------  -------
204759  kitchen_egg_3, sunny_side_up, obj_egg_4_m,                 136    5896  141      27      16.202   0.0266506  114
204817  kitchen_egg_4, sunny_side_up, obj_egg_4_m,                 151    6008  196      27      18.018   0.031578   118
204835  kitchen_egg_5, sunny_side_up, obj_egg_4_m,                 310    4772  202      29      17.406   0.0237115  137
------  -------------------------------------------------------  -----  ----  -------  ------  -------  ----------  -------
204853  kitchen_egg_4, egg_in_hole, obj_egg_4_m,                   137    5984  206      30      17.120   0.0253792  111
205354  kitchen_egg_5, egg_in_hole, obj_egg_4_m,
205413  kitchen_egg_5, egg_in_hole, obj_egg_4_m, gi=is_buttery     206    3868  212      32      18.340   0.0398749  125
------  -------------------------------------------------------  -----  ----  -------  ------  -------  ----------  -------
205441  kitchen_egg_5, poached_egg, obj_egg_5_m,                   330    5288  195      22      27.596   0.0144483  76
```

### When the environment contains 2 copies of every utensil:

```python
     t  run_name                                                   var    op    axiom    plan    parse    search     state
------  ---------------------------------------------------------  -----  ----  -------  ------  -------  ---------  -------
211648  kitchen_egg_1, omelette, obj_4,                            124    2849  29       68      1.714    0.0693452  680
211650  kitchen_egg_2, omelette, obj_4,                            124    2849  29       68      1.690    0.074333   680
211652  kitchen_egg_3, omelette, obj_4,                            124    2849  29       68      1.724    0.0710202  680
211705  kitchen_egg_4, omelette, obj_egg_4_l,                      221    7611  214      61      12.614   0.139616   798
212205  kitchen_egg_5, omelette, obj_egg_4_l,                      293    7195  280      -       -        -          -
212220  kitchen_egg_5, omelette, obj_egg_4_l, gi=is_buttery        292    7195  280      61      13.934   0.152373   897
------  ---------------------------------------------------------  -----  ----  -------  ------  -------  ---------  -------
212222  kitchen_egg_2, scrambled_eggs, obj_4,                      120    2847  29       41      1.717    0.0221763  257
212224  kitchen_egg_3, scrambled_eggs, obj_4,                      120    2847  29       41      1.691    0.0250289  257
212324  kitchen_egg_4, scrambled_eggs, obj_egg_4_l,                216    7605  214      -       -        -          -
212824  kitchen_egg_5, scrambled_eggs, obj_egg_4_l,
212839  kitchen_egg_5, scrambled_eggs, obj_egg_4_l, gi=is_buttery  266    6769  280      41      14.341   0.0356264  220
------  ---------------------------------------------------------  -----  ----  -------  ------  -------  ---------  -------
212853  kitchen_egg_3, sunny_side_up, obj_egg_4_l,                 135    6008  144      29      13.422   0.0217398  147
212907  kitchen_egg_4, sunny_side_up, obj_egg_4_l,                 160    6031  211      29      13.640   0.0236584  161
212922  kitchen_egg_5, sunny_side_up, obj_egg_4_l,                 210    5055  255      29      14.233   0.027923   147
------  ---------------------------------------------------------  -----  ----  -------  ------  -------  ---------  -------
212936  kitchen_egg_4, egg_in_hole, obj_egg_4_l,                   164    6037  213      42      13.799   0.0374208  320
213437  kitchen_egg_5, egg_in_hole, obj_egg_4_l,                   235    5481  257      -       -        -          -
213452  kitchen_egg_5, egg_in_hole, obj_egg_4_l, gi=is_buttery     233    5481  257      33      14.725   0.0241682  148
------  ---------------------------------------------------------  -----  ----  -------  ------  -------  ---------  -------
213515  kitchen_egg_5, poached_egg, obj_egg_5_l,                   256    6743  245      25      22.505   0.019964   126
```

### When the environment contains both 10 eggs & veggies and 2 copies of every utensil:

```python
     t  run_name                                                    var    op     axiom    plan    parse    search     state
------  ----------------------------------------------------------  -----  -----  -------  ------  -------  ---------  -------
214011  kitchen_egg_1, omelette, obj_4_xl,                          358    9419   299      51      9.306    0.316715   1618
214021  kitchen_egg_2, omelette, obj_4_xl,                          358    9419   299      51      9.094    0.300642   1618
214031  kitchen_egg_3, omelette, obj_4_xl,                          358    9419   299      51      9.210    0.340507   1618
214113  kitchen_egg_4, omelette, obj_egg_4_xl,                      473    20769  538      51      40.750   0.389818   1198
214613  kitchen_egg_5, omelette, obj_egg_4_xl,                      923    20353  586      -       -        -          -
214712  kitchen_egg_5, omelette, obj_egg_4_xl, gi=is_buttery        913    20353  586      49      42.193   15.4131    46426
------  ----------------------------------------------------------  -----  -----  -------  ------  -------  ---------  -------
214724  kitchen_egg_2, scrambled_eggs, obj_4_xl,                    318    9399   119      49      9.341    2.11589    11475
214758  kitchen_egg_3, scrambled_eggs, obj_4_xl,                    318    9399   119      49      25.856   7.72045    11475
214859  kitchen_egg_4, scrambled_eggs, obj_egg_4_xl,                423    20709  358      -       -        -          -
215359  kitchen_egg_5, scrambled_eggs, obj_egg_4_xl,                663    16093  406      -       -        -          -
215445  kitchen_egg_5, scrambled_eggs, obj_egg_4_xl, gi=is_buttery  653    16093  406      40      44.970   0.232838   747
------  ----------------------------------------------------------  -----  -----  -------  ------  -------  ---------  -------
215529  kitchen_egg_3, sunny_side_up, obj_egg_4_xl,                 216    16304  243      28      43.134   0.0410474  176
215614  kitchen_egg_4, sunny_side_up, obj_egg_4_xl,                 241    16498  328      28      44.347   0.0488374  205
215659  kitchen_egg_5, sunny_side_up, obj_egg_4_xl,                 480    11742  354      32      44.575   0.044776   190
------  ----------------------------------------------------------  -----  -----  -------  ------  -------  ---------  -------
215744  kitchen_egg_4, egg_in_hole, obj_egg_4_xl,                   227    16450  348      40      43.797   0.07649    342
220244  kitchen_egg_5, egg_in_hole, obj_egg_4_xl,                   298    8334   374      -       -        -          -
220331  kitchen_egg_5, egg_in_hole, obj_egg_4_xl, gi=is_buttery     296    8334   374      37      45.679   0.0668695  278
------  ----------------------------------------------------------  -----  -----  -------  ------  -------  ---------  -------
220431  kitchen_egg_5, poached_egg, obj_egg_5_xl,
```

### When the environment contains both 10 eggs & veggies and 4 copies of every utensil:

```python
     t  run_name                                                     var    op     axiom    plan    parse    search    state
------  -----------------------------------------------------------  -----  -----  -------  ------  -------  --------  -------
125126  kitchen_egg_1, omelette, obj_4_xxl,                          444    32749  501      51      38.347   0.495747  1109
125205  kitchen_egg_2, omelette, obj_4_xxl,                          444    32749  501      51      37.076   0.501044  1109
125244  kitchen_egg_3, omelette, obj_4_xxl,                          444    32749  501      51      37.568   0.490112  1109
125344  kitchen_egg_4, omelette, obj_egg_4_xxl,
125844  kitchen_egg_5, omelette, obj_egg_4_xxl,                      1503   66849  1194     -       -        -         -
125944  kitchen_egg_5, omelette, obj_egg_4_xxl, gi=is_buttery        1503   66849  1194     -       -        -         -
------  -----------------------------------------------------------  -----  -----  -------  ------  -------  --------  -------
130032  kitchen_egg_2, scrambled_eggs, obj_4_xxl,                    404    32709  141      49      43.309   2.84812   6592
130119  kitchen_egg_3, scrambled_eggs, obj_4_xxl,                    404    32709  141      49      42.441   3.16628   6592
130219  kitchen_egg_4, scrambled_eggs, obj_egg_4_xxl,
130720  kitchen_egg_5, scrambled_eggs, obj_egg_4_xxl,                1043   50329  834      -       -        -         -
130820  kitchen_egg_5, scrambled_eggs, obj_egg_4_xxl, gi=is_buttery  1043   50329  834      -       -        -         -
------  -----------------------------------------------------------  -----  -----  -------  ------  -------  --------  -------
130920  kitchen_egg_3, sunny_side_up, obj_egg_4_xxl,                 1043   50329  834      -       -        -         -
131020  kitchen_egg_4, sunny_side_up, obj_egg_4_xxl,                 1043   50329  834      -       -        -         -
131121  kitchen_egg_5, sunny_side_up, obj_egg_4_xxl,                 1043   50329  834      -       -        -         -
------  -----------------------------------------------------------  -----  -----  -------  ------  -------  --------  -------
131221  kitchen_egg_4, egg_in_hole, obj_egg_4_xxl,                   1043   50329  834      -       -        -         -
131721  kitchen_egg_5, egg_in_hole, obj_egg_4_xxl,                   478    23042  802      -       -        -         -
132221  kitchen_egg_5, egg_in_hole, obj_egg_4_xxl, gi=is_buttery     478    23042  802      -       -        -         -
------  -----------------------------------------------------------  -----  -----  -------  ------  -------  --------  -------
132222  kitchen_egg_5, poached_egg, obj_egg_5_xxl,                   478    23042  802      -       -        -         -
```