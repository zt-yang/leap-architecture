# More objects -> Search time increases linearly with alternative utensils

`test_objects.sh` tests the effect of increasing the number of objects on search complexity by adding objects to `obj_0.pddl`, with the same set of operators in `kitchen_1.pddl` and the same goal definition in `omelette_5.pddl`, i.e. a full omelette:

* `obj_0.pddl` contains the bare minimum set of objects --> [[Note 2]](#note-2-objects-init-and-goals-in-omelette_5pddl)
* `obj_1.pddl` adds 3 extranuous objects (i.e. pot/pan, bread/veggies, oliveoil/butter) 
* `obj_2.pddl` adds 3 alternative objects (i.e. knife/fork, bigbowl/smallbowl, saltedbutter/butter)
* `obj_3.pddl` contains 10 eggs and 10 veggies (the goal mentions egg1 and veggie1) --> [[Note 1]](#note-1-use-axioms-to-define-recipe)
* `obj_4.pddl` contains multiples (2) of every utensil (11) --> [[Note 3]](#note-3-the-objects-duplicated-in-obj_4pddl-and-obj_5pddl)
* `obj_5.pddl` contains multiples (10) of every utensil (11) --> [[Conclusion 1]](#conclusion-1-search-time-increases-linearly-with-alternative-utensils) 
* `obj_eggs_0.pddl` contains the bare minimum set of objects for making 10 egg recipes

```python
     t  problem_name      var     op    axiom    plan    parse     search    state
------  --------------  -----  -----  -------  ------  -------  ---------  -------
142459  obj_0.pddl         56    932       11      48    0.483  0.0119011 *    177 
142501  obj_1.pddl         61   1522       13      55    1.211  0.0194257      348 
142502  obj_2.pddl         60   1280       13      54    0.898  0.0389651 *    580
142505  obj_3.pddl         92   2930       46      48    2.721  0.0209925      181 
142507  obj_4.pddl        119   2849       11      63    1.701  0.0684566 *    678 
142546  obj_5.pddl        429  56083       11      53   37.081  0.596486  *    907 
```

## Conclusion 1: Search time increases linearly with alternative utensils

Looking at line 1, line 3 (added 3 alternative utensil), line 5 (duplicated number of utensils by 2), and line 6 (duplicated number of utensils by 10), we notice that 

* search time increases almost linearly
* number of operators increases more than linearly
* number of axioms doesn't change
* plan lengths are different (strange)

## Note 1: Use Axioms to define recipe

Note that 10 eggs and 10 veggies only has a small effect when the goal mentions only the existance of egg and veggies, as opposed to mentioning `egg1` and `veggie1`:

* `obj_0.pddl` + `omelette_5.pddl` (`obj_0.pddl` contains the bare minimum set of objects)
* `obj_3.pddl` + `omelette_5.pddl` (`obj_3.pddl` contains 10 eggs and 10 veggies)
* `obj_3.pddl` + `omelette_5b.pddl`, which contains goal `(exist-omelette kitchen)` 

```python
     t  problem_name               var    op    axiom    plan    parse     search    state
------  -----------------------  -----  ----  -------  ------  -------  ---------  -------
144457  obj_0, omelette_5.pddl      56   932       11      48    0.495  0.0104259      177
144500  obj_3, omelette_5.pddl      92  2930       46      48    2.709  0.0198585      181
144504  obj_3, omelette_5b.pddl    269  3524       83      49    2.763  0.0517935      409
```

the following are results containing goal of `(exist-omelette kitchen)` 

```python
     t  run_name                                         var      op    axiom    plan    cost    parse      search    state
------  ---------------------------------------------  -----    ----  -------  ------  ------  -------  ----------  -------
210933  kitchen_egg_1, omelette, obj_0.pddl               60     932       27      47      47    0.511   0.0102195      165
211058  kitchen_egg_1, omelette, obj_3.pddl              294    3542      198      47      47    3.094   0.0526419      424
214116  kitchen_egg_1, omelette, obj_4.pddl              124    2849       29      68      68    1.667    0.068268      680
063459  kitchen_egg_1, omelette, obj_4_xl.pddl           358    9419      299      51      51   12.865     0.41591     1618
065450  kitchen_egg_1, omelette, obj_4_xxl.pddl          444   32749      501      51      51   40.412    0.507984     1109
```

### Definition of an omelette in `kitchen_1.pddl`

```
  ( :derived ( exist-omelette ?env - env )
    ( exists 
      ( ?egg1 - egg ?veggies1 - ingredient ?plate1 - plate ?p - normalcontainer )
      ( and 
        ( inside ?plate1 ?egg1 )
        ( beaten ?egg1 )
        ( fried ?egg1 )
        ( folded ?egg1 )
        ( is-buttery ?egg1 )

        ( fried ?veggies1 )
        ( sauteed ?veggies1 )

        ( has-seasoning ?egg1 nutmilk cup two )

        ( has-seasoning ?egg1 chives tablespoon1 two )
        ( seasoning-mixed ?egg1 chives )

        ( has-seasoning ?egg1 salt gram two )
        ( seasoning-mixed ?egg1 salt )

        ( has-seasoning ?egg1 pepper gram two )
        ( seasoning-mixed ?egg1 pepper )
      )
    )
  )
```

## Note 2: Objects, Init, and Goals in `omelette_5.pddl`

```
(define (problem Omelette)
  (:domain Kitchen)

  (:objects

    ucup1 ucup2 dcup1 dcup2 drawer1 fridge - furniture
    burner - appliance
    kitchentop sink - worktop

    salt pepper chives - seasoning
    butter - oil
    nutmilk - liquid
    veggies1 - ingredient
    egg1 - egg

    fork1 - normalutensil
    spatula1 - cookingutensil
    tablespoon1 - measureutensil
    whisk1 - whiskutensil

    plate1 - plate
    salter1 shaker1 container1 - normalcontainer
    milkbottle1 - liquidcontainer
    smallbowl1 - specialcontainer
    frypan1 - cookingcontainer
    robot - agent

    one two three four - number
    gram cup - measureunit
    kitchen - env 

  )

  (:init

    ; ----------------------
    ; properties of places that cannot move
    ; ----------------------
    (closed drawer1)
    (closed dcup1)
    (closed fridge)
    (closed dcup2)
    (closed ucup1)
    (closed ucup2)
    (switchedoff burner)

    ; ----------------------
    ; stored in places that cannot move
    ; ----------------------
    (in dcup1 frypan1)
    (in dcup2 container1)

    (in fridge egg1)
    (in fridge veggies1)
    (in fridge milkbottle1)
    (in fridge butter)

    (on kitchentop salter1)
    (on kitchentop shaker1)
    (on kitchentop tablespoon1)
    (on kitchentop fork1)
    (on kitchentop spatula1)
    (on kitchentop whisk1)
    (on kitchentop plate1)
    (on kitchentop smallbowl1)

    ; ----------------------
    ; stored in movables
    ; ----------------------
    (inside salter1 salt)
    (inside shaker1 pepper)
    (inside container1 chives)
    (inside milkbottle1 nutmilk)

    ; ----------------------
    ; properties of ingredients
    ; ----------------------
    (raw egg1)
    (sauteed veggies1)
    (is-butter butter)

  )

  (:goal
    (and
      (closed ucup1)
      (closed ucup2)
      (closed dcup1)
      (closed dcup2)
      (closed drawer1)
      (closed fridge)
      (switchedoff burner)

      (beaten egg1)
      (fried egg1)
      (folded egg1)
      (is-buttery egg1)
      
      (fried veggies1)

      (has-seasoning egg1 salt gram four)
      (seasoning-mixed egg1 salt)

      (has-seasoning egg1 pepper gram four)
      (seasoning-mixed egg1 pepper)

      (has-seasoning egg1 chives tablespoon1 two)
      (seasoning-mixed egg1 chives)

      (has-seasoning egg1 nutmilk cup two)
    )
  )
)
```

## Note 3: the Objects Duplicated in `obj_4.pddl` and `obj_5.pddl`

```
    (in dcup1 frypan2)
    (in dcup2 container2)

    (in fridge milkbottle2)

    (on kitchentop salter2)
    (on kitchentop shaker2)
    (on kitchentop tablespoon2)
    (on kitchentop fork2)
    (on kitchentop spatula2)
    (on kitchentop whisk2)
    (on kitchentop plate2)
    (on kitchentop smallbowl2)

    (inside salter2 salt)
    (inside shaker2 pepper)
    (inside container2 chives)
    (inside milkbottle2 nutmilk)
```
