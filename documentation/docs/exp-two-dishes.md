# Making multiple different dishes take longer time than planning individually


## Use axioms to make two dishes of the same kind

```python
     t  run_name              var    op    axiom    plan    parse     search    state
------  ------------------  -----  ----  -------  ------  -------  ---------  -------
095216  scrambled_eggs        288  4028      194      45    9.467  0.0422231      328
095226  two_scrambled_eggs    288  4028      198      58    9.686  0.101505       750
------  ------------------  -----  ----  -------  ------  -------  ---------  -------
095237  omelette              336  4298      210      54    9.673  0.0763608      547
095247  two_omelette          336  4298      218      73    9.641  0.150028       900
------  ------------------  -----  ----  -------  ------  -------  ---------  -------
095257  sunny_side_up         211  2940      169      29    9.519  0.0149978      135
095307  two_sunny_side_up     211  2940      173      39    9.626  0.026689       225
------  ------------------  -----  ----  -------  ------  -------  ---------  -------
095317  egg_in_hole           191  2670      185      33   10.179  0.0210144      192
095328  two_egg_in_hole       191  2670      193      51    9.922  0.0426344      506
------  ------------------  -----  ----  -------  ------  -------  ---------  -------
095338  poached_egg           221  3108      167      26    9.787  0.0191495      165
095349  two_poached_egg       221  3108      171      31   10.209  0.0274204      268
```

```lisp
  ( :derived ( enable-sunny-side-up ?egg1 - egg ?plate1 - plate )
    ( and 
      ( inside ?plate1 ?egg1 )
      ( inside ?plate1 ?egg1 )
      ( fried ?egg1 )
      ( steamed ?egg1 ) 
      ( has-seasoning ?egg1 salt gram one )
      ( has-seasoning ?egg1 pepper gram one )
    )
  )

  ( :derived ( exist-sunny-side-up ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate ) ( enable-sunny-side-up ?egg1 ?plate1 )
    )
  )

  ( :derived ( exist-two-sunny-side-up ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate ?egg2 - egg ?plate2 - plate )
      ( and 
        ( not ( = ?egg1 ?egg2 ) )
        ( not ( = ?plate1 ?plate2 ) )
        ( enable-sunny-side-up ?egg1 ?plate1 )
        ( enable-sunny-side-up ?egg2 ?plate2 )
      )
    )
  )
```

The length of plan for making two poached egg is much smaller than making one poached egg because actions like `open fridge` and `switchoff burner pot1` need not be done again.

```
open dcup1 (1)
turn-tap-on faucet (1)
getout pot1 dcup1 robot (1)
close dcup1 (1)
add-liquid water faucet pot1 robot (1)
turn-tap-off faucet (1)
open fridge (1)
getout egg1 fridge robot (1)
getout egg4 fridge robot (1)
close fridge (1)
open dcup2 (1)
getout mediumbottle1 dcup2 robot (1)
close dcup2 (1)
pour-liquid whitevinegar mediumbottle1 pot1 robot (1)
putdown pot1 burner robot (1)
crack-egg egg1 faucet robot (1)
crack-egg egg4 faucet robot (1)
switchon burner pot1 (1)
change-level burner medium (1)
pickup faucet kitchentop robot (1)
boil water pot1 burner (1)
transfer egg1 faucet pot1 robot (1)
transfer egg4 faucet pot1 robot (1)
boil water pot1 burner (1)
switchoff burner pot1 (1)
declare-poached-egg egg1 plate2 (1)
declare-poached-egg egg4 plate1 (1)
```

## Use operators to make two dishes of the same kind

It's not only able to make two dishes of the same kind, but also of different kinds

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


## Use operators to make multiple dishes of different kind


```python
     t  run_name          var    op    axiom    plan    parse     search    state
------  --------------  -----  ----  -------  ------  -------  ---------  -------
143741  omelette          371  4620      194      47    9.7    0.0487366      322
143751  egg_in_hole       371  4620      194      34    9.617  0.021686       185
143801  multiple_14       388  4620      210      65    9.539  0.150302      1093
------  --------------  -----  ----  -------  ------  -------  ---------  -------
143811  scrambled_eggs    363  4620      186      46    9.509  0.0483345      328
143821  egg_in_hole       371  4620      194      34    9.322  0.0228407      185
143832  multiple_24       380  4620      202      61   10.002  0.170658      1149
```

If we use axoims instead of effects, making multiple different dishes would fail because the same ingredient egg1 can be used for both the omelette and the scrambled eggs. 

However, the tricky thing about using effects to separate multiple dishes is the need to prevent the same action being taken twice on the same ingredient, thus operators like `fry` and `steam` need to include preconditions like `( not ( fried ?i ) )` and `( not ( steamed ?i ) )`.

### Plan for making omelette and egg_in_hole (65)

```python
pickup holecutter1 kitchentop robot (1)
make-hole toast1 holecutter1 circle robot (1)
putdown holecutter1 burner robot (1)
open fridge (1)
getout egg1 fridge robot (1)
getout milkbottle1 fridge robot (1)
getout veggies2 fridge robot (1)
close fridge (1)
open dcup2 (1)
getout container1 dcup2 robot (1)
getout oilbottle1 dcup2 robot (1)
close dcup2 (1)
pour-liquid oliveoil oilbottle1 frypan1 robot (1)
open dcup1 (1)
getout frypan1 dcup1 robot (1)
close dcup1 (1)
putdown frypan1 burner robot (1)
switchon burner frypan1 (1)
change-level burner high (1)
pickup tablespoon1 kitchentop robot (1)
crack-egg egg1 smallbowl1 robot (1)
add-ingredient veggies2 smallbowl1 robot (1)
season egg1 pepper shaker1 tablespoon1 robot (1)
season egg1 salt salter1 tablespoon1 robot (1)
open fridge (1)
getout egg4 fridge robot (1)
close fridge (1)
crack-egg egg4 toast1 robot (1)
season egg1 chives container1 tablespoon1 robot (1)
season egg1 chives container1 tablespoon1 robot (1)
putdown tablespoon1 burner robot (1)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
pickup fork1 kitchentop robot (1)
mix egg1 fork1 smallbowl1 robot (1)
putdown oilbottle1 burner robot (1)
pickup salter1 kitchentop robot (1)
sprinkle egg4 salt salter1 gram robot (1)
sprinkle egg1 salt salter1 gram robot (1)
sprinkle egg1 salt salter1 gram robot (1)
putdown salter1 burner robot (1)
pickup shaker1 kitchentop robot (1)
sprinkle egg4 pepper shaker1 gram robot (1)
sprinkle egg1 pepper shaker1 gram robot (1)
sprinkle egg1 pepper shaker1 gram robot (1)
putdown shaker1 burner robot (1)
pickup toast1 kitchentop robot (1)
add-ingredient toast1 smallbowl1 robot (1)
putdown milkbottle1 burner robot (1)
pickup smallbowl1 kitchentop robot (1)
transfer veggies2 smallbowl1 frypan1 robot (1)
fry veggies2 frypan1 burner oliveoil (1)
transfer egg1 smallbowl1 frypan1 robot (1)
fry egg1 frypan1 burner oliveoil (1)
transfer toast1 smallbowl1 frypan1 robot (1)
fry toast1 frypan1 burner oliveoil (1)
switchoff burner frypan1 (1)
putdown smallbowl1 burner robot (1)
pickup frypan1 burner robot (1)
transfer toast1 frypan1 plate1 robot (1)
declare-egg-in-hole egg4 toast1 plate1 (1)
putdown frypan1 burner robot (1)
pickup spatula1 kitchentop robot (1)
fold egg1 frypan1 spatula1 robot (1)
declare-omelette egg1 veggies2 plate2 (1)
```


### Plan for making scrambled_eggs and egg_in_hole (61)

```python
pickup holecutter1 kitchentop robot (1)
make-hole toast1 holecutter1 circle robot (1)
putdown holecutter1 burner robot (1)
open fridge (1)
getout egg1 fridge robot (1)
getout milkbottle1 fridge robot (1)
close fridge (1)
open dcup2 (1)
getout container1 dcup2 robot (1)
getout oilbottle1 dcup2 robot (1)
close dcup2 (1)
pour-liquid oliveoil oilbottle1 frypan1 robot (1)
open dcup1 (1)
getout frypan1 dcup1 robot (1)
close dcup1 (1)
putdown frypan1 burner robot (1)
switchon burner frypan1 (1)
change-level burner high (1)
pickup tablespoon1 kitchentop robot (1)
crack-egg egg1 smallbowl1 robot (1)
season egg1 chives container1 tablespoon1 robot (1)
season egg1 pepper shaker1 tablespoon1 robot (1)
season egg1 salt salter1 tablespoon1 robot (1)
putdown tablespoon1 burner robot (1)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
pour smallbowl1 nutmilk milkbottle1 cup robot (1)
pickup fork1 kitchentop robot (1)
mix egg1 fork1 smallbowl1 robot (1)
putdown oilbottle1 burner robot (1)
pickup salter1 kitchentop robot (1)
sprinkle egg1 salt salter1 gram robot (1)
open fridge (1)
getout egg4 fridge robot (1)
close fridge (1)
crack-egg egg4 toast1 robot (1)
sprinkle egg4 salt salter1 gram robot (1)
putdown salter1 burner robot (1)
pickup shaker1 kitchentop robot (1)
sprinkle egg1 pepper shaker1 gram robot (1)
sprinkle egg4 pepper shaker1 gram robot (1)
putdown shaker1 burner robot (1)
pickup toast1 kitchentop robot (1)
add-ingredient toast1 smallbowl1 robot (1)
putdown milkbottle1 burner robot (1)
pickup smallbowl1 kitchentop robot (1)
transfer toast1 smallbowl1 frypan1 robot (1)
fry toast1 frypan1 burner oliveoil (1)
transfer egg1 smallbowl1 frypan1 robot (1)
fry egg1 frypan1 burner oliveoil (1)
switchoff burner frypan1 (1)
putdown smallbowl1 burner robot (1)
pickup frypan1 burner robot (1)
transfer toast1 frypan1 plate1 robot (1)
declare-egg-in-hole egg4 toast1 plate1 (1)
putdown frypan1 burner robot (1)
pickup spatula1 kitchentop robot (1)
scrape egg1 frypan1 spatula1 robot (1)
putdown spatula1 burner robot (1)
pickup frypan1 burner robot (1)
transfer egg1 frypan1 plate1 robot (1)
declare-scrambled-eggs egg1 plate1 (1)
```