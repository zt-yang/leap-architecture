# Planner Modes

## Make egg dishes

`test_FD.sh` tests the planning time and performance of Satisfising LAMA (`lama_first`) and Optimizing LAMA (`lama`).

Note that for each planner run, total timeout for translation and search is 10 sec. When `state` shows `(>number)`, it means the search is still finding more plans. The best plan so far is reported here.

```python
     t  run_name                          var    op    axiom    plan    cost    parse      search  state
------  ------------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
190628  omelette, pln=lama_first          187  2149       97      45      71    5.076  0.0226832   225
190638  omelette, pln=lama                187  2149       97      45      64    5.274  0.139128    (>4.79)
------  ------------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
190644  scrambled_eggs, pln=lama_first    187  2149       97      53      85    5.234  0.0322311   306
190655  scrambled_eggs, pln=lama          187  2149       97      44      61    5.516  0.189056    (>4.54)
------  ------------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
190700  sunny_side_up, pln=lama_first     187  2149       97      27      42    5.267  0.00612013  66
190711  sunny_side_up, pln=lama           187  2149       97      28      41    5.178  0.114958    (>4.87)
------  ------------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
190716  egg_in_hole, pln=lama_first       187  2149       97      32      48    5.151  0.00806562  119
190727  egg_in_hole, pln=lama             187  2149       97      30      41    5.121  0.112132    (>4.95)
------  ------------------------------  -----  ----  -------  ------  ------  -------  ----------  -------
190732  poached_egg, pln=lama_first       225  2459      103      23      36    5.117  0.00811542  103
190743  poached_egg, pln=lama             225  2459      103      20      31    5.007  0.119612    (>5.04)
```

Goal of `poached_egg.pddl`

```lisp
  ( :derived ( exist-poached-egg ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate ) ( enable-poached-egg ?egg1 ?plate1 )
    )
  )

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

Plan of length 23 by `lama_first`:

```python
open dcup1 (1)
getout pot1 dcup1 robot (1)
close dcup1 (1)
putdown pot1 burner robot (2)
pickup faucet kitchentop robot (2)  ## it's unnecessary to pick up the faucet
transfer water faucet pot1 robot (1)
open fridge1 (1)
getout egg1 fridge1 robot (1)
close fridge1 (1)
crack-egg egg1 smallbowl1 robot (1)
putdown faucet burner robot (2)
pickup smallbowl1 kitchentop robot (2)
transfer egg1 smallbowl1 pot1 robot (1)
open dcup1 (1)
getout mediumbottle1 dcup1 robot (1)
close dcup1 (1)
switchon burner pot1 (1)
change-level burner medium (1)
boil water pot1 burner (5)
boil water pot1 burner (5)
switchoff burner pot1 (1)
pour-liquid whitevinegar mediumbottle1 pot1 robot (2) ## chosen by lama_first
declare-poached-egg egg1 plate1 (1)
```

Plan of length 20 by `lama`:

```python
pickup faucet kitchentop robot (2)
transfer water faucet pot1 robot (1)
open dcup1 (1)
getout pot1 dcup1 robot (1)
getout mediumbottle1 dcup1 robot (1)
close dcup1 (1)
open fridge1 (1)
getout egg1 fridge1 robot (1)
close fridge1 (1)
crack-egg egg1 smallbowl1 robot (1)
putdown pot1 burner robot (2)
switchon burner pot1 (1)
change-level burner medium (1)
boil water pot1 burner (5)
pickup smallbowl1 kitchentop robot (2)
transfer egg1 smallbowl1 pot1 robot (1)
boil water pot1 burner (5)
switchoff burner pot1 (1)
transfer whitevinegar mediumbottle1 pot1 robot (1) ## a better action chosen by lama
declare-poached-egg egg1 plate1 (1)
```

## Make customer happy


