# Making multiple different dishes take longer time than planning individually

## Make two dishes of the same kind

`test_serve_declare.sh`. The length of plan for making two poached egg is much smaller than making one poached egg because actions like `open fridge` and `switchoff burner pot1` need not be done again.


```python
     t  run_name              var    op    axiom    plan    parse     search    state
------  ------------------  -----  ----  -------  ------  -------  ---------  -------
102036  scrambled_eggs        362  4620      186      46   11.018  0.0549285      328
102048  two_scrambled_eggs    362  4620      190      60   10.684  0.101157       689
------  ------------------  -----  ----  -------  ------  -------  ---------  -------
102059  omelette              370  4620      194      47   10.524  0.0495447      322
102110  two_omelette          370  4620      202      66   10.048  0.114891       676
------  ------------------  -----  ----  -------  ------  -------  ---------  -------
102121  sunny_side_up         362  4620      186      30   10.633  0.0186152      118
102132  two_sunny_side_up     362  4620      190      41   10.469  0.0331593      197
------  ------------------  -----  ----  -------  ------  -------  ---------  -------
102143  egg_in_hole           370  4620      194      34   10.37   0.0241679      185
102155  two_egg_in_hole       370  4620      202      53   11.293  0.0766958      497
------  ------------------  -----  ----  -------  ------  -------  ---------  -------
102207  poached_egg           406  4993      218      24   10.932  0.0165712      112
102219  two_poached_egg       406  4993      222      27   11.683  0.0159511      124
```

Instead of getting `( enable-poached-egg ?egg1 ?plate1 )` from axioms, we get it from the effects of operartors, which also include effects that reverse the preconditions. This enables flexible negation, for certain effects like `( not ( boiled water ) )` needs not be achieved again

```lisp
  ( :action declare-poached-egg
    :parameters ( ?egg1 - egg ?plate1 - plate )
    :precondition( and
      ( boiled water )
      ( boiled ?egg1 )
      ( hardness ?egg1 outerside medium-hard )
      ( has-vinegar water )
    )
    :effect( and
      ( enable-poached-egg ?egg1 ?plate1 )

      ;( not ( boiled water ) )
      ( not ( boiled ?egg1 ) )
      ( not ( hardness ?egg1 outerside medium-hard ) )
      ;( not ( has-vinegar water ) )

      ( increase ( total-cost ) 1 )
    )
  )
```

With the reversed effects, it's not only able to make two dishes of the same kind, but also of different kinds

## Make multiple dishes of different kind

`test_serve_multiple.sh`


```python
     t  run_name                          var    op    axiom    plan    cost    parse     search  state
------  ------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
225521  omelette, pln=lama_first          370  4619      167      46      72   10.295  0.0506214  291
225533  egg_in_hole, pln=lama_first       370  4619      167      33      50   10.298  0.0257594  172
225544  multiple_14, pln=lama_first       387  4619      183      68     107   10.206  0.180543   924
------  ------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
225559  omelette, pln=lama                370  4619      167      46      66   10.395  0.222248   (>4.65)
225615  egg_in_hole, pln=lama             370  4619      167      32      43   11.087  0.267335   (>4.06)
225631  multiple_14, pln=lama             387  4619      183      60      86   11.642  0.347518   (>3.44)
------  ------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
225643  scrambled_eggs, pln=lama_first    362  4619      159      45      71   10.882  0.0535775  310
225654  egg_in_hole, pln=lama_first       370  4619      167      33      50   10.258  0.0261091  172
225706  multiple_24, pln=lama_first       379  4619      175      64     101   10.417  0.272622   1515
------  ------------------------------  -----  ----  -------  ------  ------  -------  ---------  -------
225721  scrambled_eggs, pln=lama          362  4619      159      43      60   10.584  0.229554   (>4.46)
225737  egg_in_hole, pln=lama             370  4619      167      32      43   10.635  0.206529   (>4.43)
225753  multiple_24, pln=lama             379  4619      175      54      76   10.407  0.397696   (>4.64)
```

The tricky thing about using effects to separate multiple dishes is the need to prevent the same action being taken twice on the same ingredient, thus operators like `fry` and `steam` need to include preconditions like `( not ( fried ?i ) )` and `( not ( steamed ?i ) )`.


### Difference between plans

Steps in plan by `lama-first` but not by `lama`:

```python
['putdown egg1 burner robot (2)',
 'putdown milkbottle1 burner robot (2)',
 'putdown holecutter1 burner robot (2)',
 'pickup egg1 burner robot (2)',
 'getout container1 dcup2 robot (1)',
 'pour-liquid oliveoil oilbottle1 frypan1 robot (2)',
 'putdown tablespoon1 burner robot (2)',
 'pickup milkbottle1 burner robot (2)',
 'putdown oilbottle1 burner robot (2)',
 'putdown salter1 burner robot (2)',
 'putdown shaker1 burner robot (2)',
 'putdown milkbottle1 burner robot (2)',
 'putdown smallbowl1 burner robot (2)',
 'putdown spatula1 burner robot (2)']
```

Steps in plan by `lama` but not by `lama-first`:

```python
['puton holecutter1 bread1 robot (1)',
 'transfer oliveoil oilbottle1 frypan1 robot (1)',
 'puton tablespoon1 bread1 robot (1)',
 'puton salter1 bread1 robot (1)',
 'puton shaker1 bread1 robot (1)',
 'puton oilbottle1 bread1 robot (1)',
 'puton smallbowl1 bread1 robot (1)',
 'puton spatula1 bread1 robot (1)']
```


### `lama-firt`'s Plan for making scrambled_eggs and egg_in_hole (64)

```python
open fridge (1)
getout egg1 fridge robot (1)
getout milkbottle1 fridge robot (1)
close fridge (1)
putdown egg1 burner robot (2)
pickup holecutter1 kitchentop robot (2)
putdown milkbottle1 burner robot (2)
make-hole toast1 holecutter1 circle robot (1)
pickup fork1 kitchentop robot (2)
putdown holecutter1 burner robot (2)
open dcup2 (1)
pickup egg1 burner robot (2)
getout container1 dcup2 robot (1)
getout oilbottle1 dcup2 robot (1)
close dcup2 (1)
pour-liquid oliveoil oilbottle1 frypan1 robot (2)
open dcup1 (1)
getout frypan1 dcup1 robot (1)
close dcup1 (1)
putdown frypan1 burner robot (2)
pickup tablespoon1 kitchentop robot (2)
crack-egg egg1 smallbowl1 robot (1)
season egg1 chives container1 tablespoon1 robot (1)
season egg1 pepper shaker1 tablespoon1 robot (1)
season egg1 salt salter1 tablespoon1 robot (1)
mix egg1 fork1 smallbowl1 robot (3)
putdown tablespoon1 burner robot (2)
pickup milkbottle1 burner robot (2)
putdown oilbottle1 burner robot (2)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
pickup salter1 kitchentop robot (2)
sprinkle egg1 salt salter1 gram robot (1)
open fridge (1)
getout egg4 fridge robot (1)
close fridge (1)
crack-egg egg4 toast1 robot (1)
sprinkle egg4 salt salter1 gram robot (1)
putdown salter1 burner robot (2)
pickup shaker1 kitchentop robot (2)
sprinkle egg1 pepper shaker1 gram robot (1)
sprinkle egg4 pepper shaker1 gram robot (1)
putdown shaker1 burner robot (2)
pickup toast1 kitchentop robot (2)
add-ingredient toast1 smallbowl1 robot (1)
putdown milkbottle1 burner robot (2)
pickup smallbowl1 kitchentop robot (2)
transfer toast1 smallbowl1 frypan1 robot (1)
transfer egg1 smallbowl1 frypan1 robot (1)
putdown smallbowl1 burner robot (2)
switchon burner frypan1 (1)
fry toast1 frypan1 burner oliveoil (5)
fry egg1 frypan1 burner oliveoil (5)
switchoff burner frypan1 (1)
pickup frypan1 burner robot (2)
transfer toast1 frypan1 plate1 robot (1)
declare-egg-in-hole egg4 toast1 plate1 (1)
putdown frypan1 burner robot (2)
pickup spatula1 kitchentop robot (2)
scrape egg1 frypan1 spatula1 robot (3)
putdown spatula1 burner robot (2)
pickup frypan1 burner robot (2)
transfer egg1 frypan1 plate1 robot (1)
declare-scrambled-eggs egg1 plate1 (1)
```

### `lama`'s Plan for making scrambled_eggs and egg_in_hole (54)

```python
pickup holecutter1 kitchentop robot (2)
make-hole toast1 holecutter1 circle robot (1)
puton holecutter1 bread1 robot (1)
pickup tablespoon1 kitchentop robot (2)
open dcup2 (1)
getout oilbottle1 dcup2 robot (1)
close dcup2 (1)
transfer oliveoil oilbottle1 frypan1 robot (1)
open dcup1 (1)
getout frypan1 dcup1 robot (1)
close dcup1 (1)
putdown frypan1 burner robot (2)
switchon burner frypan1 (1)
pickup fork1 kitchentop robot (2)
open fridge (1)
getout milkbottle1 fridge robot (1)
getout egg1 fridge robot (1)
crack-egg egg1 smallbowl1 robot (1)
getout egg4 fridge robot (1)
close fridge (1)
crack-egg egg4 toast1 robot (1)
season egg1 chives container1 tablespoon1 robot (1)
season egg1 pepper shaker1 tablespoon1 robot (1)
season egg1 salt salter1 tablespoon1 robot (1)
mix egg1 fork1 smallbowl1 robot (3)
puton tablespoon1 bread1 robot (1)
pickup salter1 kitchentop robot (2)
sprinkle egg1 salt salter1 gram robot (1)
sprinkle egg4 salt salter1 gram robot (1)
puton salter1 bread1 robot (1)
pickup shaker1 kitchentop robot (2)
sprinkle egg1 pepper shaker1 gram robot (1)
sprinkle egg4 pepper shaker1 gram robot (1)
puton shaker1 bread1 robot (1)
pickup toast1 kitchentop robot (2)
add-ingredient toast1 smallbowl1 robot (1)
puton oilbottle1 bread1 robot (1)
pickup smallbowl1 kitchentop robot (2)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
transfer toast1 smallbowl1 frypan1 robot (1)
fry toast1 frypan1 burner oliveoil (5)
transfer egg1 smallbowl1 frypan1 robot (1)
fry egg1 frypan1 burner oliveoil (5)
switchoff burner frypan1 (1)
puton smallbowl1 bread1 robot (1)
pickup frypan1 burner robot (2)
transfer toast1 frypan1 plate1 robot (1)
declare-egg-in-hole egg4 toast1 plate1 (1)
puton milkbottle1 bread1 robot (1)
pickup spatula1 kitchentop robot (2)
scrape egg1 frypan1 spatula1 robot (3)
transfer egg1 frypan1 plate1 robot (1)
declare-scrambled-eggs egg1 plate1 (1)
```