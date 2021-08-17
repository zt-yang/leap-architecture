# Different recipes -> Search time corresponds to # of axioms and depth of search, instead of # of operators or length of plan

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
