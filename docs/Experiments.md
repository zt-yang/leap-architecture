# Experiments & Results on Search Complexity

## 1. More goal predicates -> Search time increases more than linearly

`test_goals.sh` tests the effect of increasing the number of goal predicates on search complexity, with the same `kitchen_1`.pddl and `obj_1`.pddl, i.e. minimum operators & objects:
* omelette_1.pddl has only eggs
* omelette_2.pddl adds veggies
* omelette_3.pddl adds salt and pepper
* omelette_4.pddl adds nutmilk and chives
* omelette_5.pddl contains all positive goal predicates without any use of axioms
* omelette_6.pddl contains one negative goal predicate
* omelette_6.pddl contains two negative goal predicates

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

## 2. More objects -> Search time increases linearly

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

## 3. Different recipes -> Search time corresponds to # of axioms and depth of search, instead of # of operators or length of plan

`test_egg_recipes.sh` tests the search complexity of 10 different egg-related recipes, with the same `kitchen_3.pddl` and `obj_eggs.pddl`, i.e. with all definitions and objects for egg recipes:
* scrambled_eggs.pddl specifies beaten, scrambled eggs
* omelette.pddl specifies beaten, folded eggs with veggies
* sunny_side_up.pddl specifies fried, steamed eggs on frypan
* egg_in_hole.pddl specifies fried egg in the hole of a bread
* poached_egg.pddl specifies boiled egg with vinegar

```
     t  problem_name                                                       var    op    axiom    plan    parse     search    state
------  ---------------------------------------------------------------  -----  ----  -------  ------  -------  ---------  -------
085358  kitchen_egg_4-scrambled_eggs-obj_egg_4.pddl-scrambled_eggs.pddl    312  6677      161      43    9.846  0.120834       749
085408  kitchen_egg_4-omelette-obj_egg_4.pddl-omelette.pddl                350  6680      161      52   10.03   0.119653       711
085419  kitchen_egg_4-sunny_side_up-obj_egg_4.pddl-sunny_side_up.pddl      142  4560      125      28   10.377  0.272117      2501
085432  kitchen_egg_4-egg_in_hole-obj_egg_4.pddl-crack                     202  3234      172      50   10.129  2.14165      24498
085447  kitchen_3-poached_egg-obj_eggs.pddl-poached_egg.pddl               368  4944      137      25   14.394  0.0189829      144
```

Comparing the goal defintion of Omelette (0.12s), Sunny Side Up (0.27s), and Egg in a Hole (2.14s)

```
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

  ( :derived ( exist-sunny-side-up ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate )
      ( and 
        ( inside ?plate1 ?egg1 )
        ( fried ?egg1 )
        ;( is-buttery ?egg1 )  ; SHOW: weirdly cannot use butter here
        ( steamed ?egg1 ) 
        ( has-seasoning ?egg1 salt gram one )
        ( has-seasoning ?egg1 pepper gram one )
      )
    )
  )

  ( :derived ( exist-egg-in-hole ?env - env )
    ( exists 
      ( ?egg1 - egg ?bread1 - bread ?plate1 - plate )
      ( and 
        ( inside ?plate1 ?bread1 )
        ( has-hole ?bread1 circle )
        ( in-hole ?egg1 ?bread1 ) 
        ( fried ?bread1 )
        ; ( fried ?egg1 ) ; cannot achieve this because egg1 not in frypan but in the hole of bread which is on frypan
        ( is-buttery ?bread1 ) 
        ( has-seasoning ?egg1 salt gram one )
        ( has-seasoning ?egg1 pepper gram one )
      )
    )
  )
```

The plan of making an omelette (length = 52):

```
open fridge (0)
getout egg1 fridge robot (0)
close fridge (0)
crack-egg egg1 bigbowl1 robot (0)
open fridge (0)
getout milkbottle1 fridge robot (0)
getout butter fridge robot (0)
getout veggies1 fridge robot (0)
close fridge (0)
add-ingredient butter smallbowl1 robot (0)
add-ingredient veggies1 smallbowl1 robot (0)
pour bigbowl1 nutmilk milkbottle1 cup robot (0)
pour bigbowl1 nutmilk milkbottle1 cup robot (0)
putdown fork1 burner robot (0)
pickup bigbowl1 kitchentop robot (0)
putdown milkbottle1 burner robot (0)
pickup salter1 kitchentop robot (0)
sprinkle egg1 salt salter1 cup robot (0)
sprinkle egg1 salt salter1 gram robot (0)
sprinkle egg1 salt salter1 gram robot (0)
putdown salter1 burner robot (0)
pickup shaker1 kitchentop robot (0)
sprinkle egg1 pepper shaker1 cup robot (0)
sprinkle egg1 pepper shaker1 gram robot (0)
sprinkle egg1 pepper shaker1 gram robot (0)
putdown shaker1 burner robot (0)
pickup smallbowl1 kitchentop robot (0)
transfer butter smallbowl1 frypan1 robot (0)
transfer veggies1 smallbowl1 frypan1 robot (0)
open dcup1 (0)
getout frypan1 dcup1 robot (0)
close dcup1 (0)
putdown frypan1 burner robot (0)
pickup tablespoon2 kitchentop robot (0)
season egg1 chives container1 tablespoon2 robot (0)
season egg1 chives container1 tablespoon2 robot (0)
putdown tablespoon2 burner robot (0)
pickup fork1 kitchentop robot (0)
putdown fork1 burner robot (0)
pickup fork1 burner robot (0)
mix egg1 fork1 bigbowl1 robot (10)
switchon burner frypan1 (0)
fry veggies1 frypan1 burner butter (0)
transfer egg1 bigbowl1 frypan1 robot (0)
fry egg1 frypan1 burner butter (0)
switchoff burner frypan1 (0)
putdown fork1 burner robot (0)
pickup frypan1 burner robot (0)
putdown smallbowl1 burner robot (0)
pickup spatula1 kitchentop robot (0)
fold egg1 frypan1 spatula1 robot (0)
transfer egg1 frypan1 plate1 robot (0)
```

The plan of making an sunny-side-up (length = 28):

```
open fridge (0)
getout egg1 fridge robot (0)
close fridge (0)
crack-egg egg1 smallbowl1 robot (0)
open dcup2 (0)
getout oilbottle1 dcup2 robot (0)
close dcup2 (0)
transfer oliveoil oilbottle1 frypan1 robot (0)
open dcup1 (0)
getout frypan1 dcup1 robot (0)
getout pancover1 dcup1 robot (0)
close dcup1 (0)
putdown frypan1 burner robot (0)
pickup smallbowl1 kitchentop robot (0)
transfer egg1 smallbowl1 frypan1 robot (0)
switchon burner frypan1 (0)
fry egg1 frypan1 burner oliveoil (0)
puton pancover1 frypan1 robot (0)
steam egg1 frypan1 burner (0)
switchoff burner frypan1 (0)
pickup frypan1 burner robot (0)
transfer egg1 frypan1 plate1 robot (0)
putdown fork1 burner robot (0)
pickup salter1 kitchentop robot (0)
sprinkle egg1 salt salter1 gram robot (0)
putdown smallbowl1 burner robot (0)
pickup shaker1 kitchentop robot (0)
sprinkle egg1 pepper shaker1 gram robot (0)
```

The plan of making an egg-in-hole (length = 50):

```
putdown fork1 burner robot (0)
pickup holecutter1 kitchentop robot (0)
make-hole bread1 holecutter1 circle robot (1)
open fridge (0)
getout butter fridge robot (0)
getout egg1 fridge robot (0)
close fridge (0)
crack-egg-3 egg1 bread1 robot (1)
add-ingredient butter smallbowl1 robot (0)
open dcup1 (0)
getout frypan1 dcup1 robot (0)
close dcup1 (0)
putdown frypan1 burner robot (0)
pickup salter1 kitchentop robot (0)
sprinkle egg1 salt salter1 gram robot (0)
putdown salter1 burner robot (0)
pickup shaker1 kitchentop robot (0)
sprinkle egg1 pepper shaker1 gram robot (0)
putdown shaker1 burner robot (0)
pickup bread1 kitchentop robot (0)
add-ingredient bread1 smallbowl1 robot (0)
putdown holecutter1 burner robot (0)
pickup smallbowl1 kitchentop robot (0)
transfer bread1 smallbowl1 plate1 robot (0)
putdown smallbowl1 burner robot (0)
pickup plate1 kitchentop robot (0)
open dcup2 (0)
getout oilbottle1 dcup2 robot (0)
close dcup2 (0)
transfer oliveoil oilbottle1 frypan1 robot (0)
putdown plate1 burner robot (0)
pickup smallbowl1 burner robot (0)
transfer butter smallbowl1 frypan1 robot (0)
putdown smallbowl1 burner robot (0)
pickup plate1 burner robot (0)
transfer bread1 plate1 frypan1 robot (0)
putdown plate1 burner robot (0)
pickup frypan1 burner robot (0)
transfer bread1 frypan1 plate1 robot (0)
putdown oilbottle1 burner robot (0)
pickup plate1 burner robot (0)
putdown frypan1 burner robot (0)
pickup fork1 burner robot (0)
switchon burner frypan1 (0)
transfer bread1 plate1 frypan1 robot (0)
fry bread1 frypan1 burner butter (0)
switchoff burner frypan1 (0)
putdown fork1 burner robot (0)
pickup frypan1 burner robot (0)
transfer bread1 frypan1 plate1 robot (0)
```

## 4. More operators -> Search time increases linearly

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

---

## Ongoing

`test_effects.sh` tests how the complexity of operator effects affects the length of plan, with the same `kitchen_3.pddl` and `obj_eggs.pddl`, focusing on `crack-egg` action
* scrambled_eggs.pddl + crack-egg-1
* omelette.pddl + crack-egg-1
* sunny_side_up.pddl + crack-egg-1
* sunny_side_up.pddl + crack-egg-2 = FAIL
* egg_in_hole.pddl + crack-egg-3
* egg_in_hole.pddl + crack-egg-4 = LONGER

```
     t  problem_name                            var    op    axiom  plan    parse    search    state
------  ------------------------------------  -----  ----  -------  ------  -------  --------  -------
090308  scrambled_eggs-1-scrambled_eggs.pddl    314  6677      167  43      9.577    0.112926  749
090318  omelette-1-omelette.pddl                352  6680      167  50      9.792    0.115964  701
090329  sunny_side_up-1-sunny_side_up.pddl      144  4560      131  28      9.687    0.277916  2531
090349  sunny_side_up-2-sunny_side_up.pddl      157  4694      160  -       -        -         -
090402  egg_in_hole-3-egg_in_hole.pddl          202  3234      172  50      10.123   2.50423   24498
090415  egg_in_hole-4-egg_in_hole.pddl          139  4664      196  50      10.714   2.27736   24286
```
