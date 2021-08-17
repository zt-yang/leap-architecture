# LEAP (Learning-Enabled Abstraction for Planning)

![Diagram of LEAP architecture](docs/diagram.png)

* CogMan: cognitive manager that employs strategists and commonsense knowledge to solve big, complex problems
	* Pre-problem Strategists: a sequence of (learned) components that map a big problem into a sequence of smaller problems by making hierarchical or temporal abstractions
		* HPN: (v1) relax preconditions with fixed hierarchy (v2) with learned importance score
		* PLOI: (v1) find minimum set of objects at the beginning of solving the problem (v2) change the set dynamically
		* C2S2 (context-conditioned subgoal suggestor): (v1) with 3-gram models (v2) with language models 
	* Post-problem Strategists: a sequence of components that improve a plan 
		* VNS: to change the order of operators, e.g. open the fridge only once to get both the meat and cheese

## Usage

Run `run.py` with the domain and problem pddl files, along with the sequence of strategists to use. The code searches for the pddl files in all sub-directories of `domains/`.

```
## the general template
python run.py domain.pddl problem.pddl 
    -o 'large_domain_objects.pddl' 
    -p [fd/pp] 
    -s 'hpn,c2s2,pre-strategists separated by comma' 
    -v [0/1/2] 
    -e 'experiment_output_directory'

## this should work and generate an output dir with plan and log in experiments/dev
python run.py kitchen_1.pddl omelette_5.pddl -o obj_3.pddl -v 2 -e 'experiments/dev'

## this needs to run successfully for every new version of the code and domain files
./tests.sh
```

Note that `kitchen_3.pddl` and `obj_eggs.pddl` are currently being actively developed for a larger kitchen domain.

Helper functions:

```
## post_experiments.py prints a table of experimental stats in directory
python generators/post_experiments.py experiments/kitchen_operators

## init_objects.py converts doc/objects.md file to PDDL tuples of types and objects
python generators/init_objects.py 
```

### Available Planners

* `df`: FastDownward with lama-first. Better than PyperPlan in that it can take ADL expressions for using forall/exists/when. It also supports action costs and axioms (see `downward/driver/aliases.py` and [Doc/Evaluator](http://www.fast-downward.org/Doc/Evaluator#Landmark-count_heuristic)). But it doesn't support PDDL 2+ and 3+ features, like fluents, numerical planning, temporal planning, soft goals & preferences.

```python
ALIASES["lama-first"] = [
    "--evaluator",
    "hlm=lmcount(lm_factory=lm_reasonable_orders_hps(lm_rhw()),transform=adapt_costs(one),pref=false)",
    "--evaluator", "hff=ff(transform=adapt_costs(one))",
    "--search", """lazy_greedy([hff,hlm],preferred=[hff,hlm],
                               cost_type=one,reopen_closed=false)"""]
```

* `pp`: PyperPlan with Greedy Best First Search and FF heuristic

### Available Strategists

* `hpn`, `ploi` or `c2s2`: output the original domain and problem pddl

### Available Test Cases

`test_goals.sh` tests the effect of increasing the number of goal predicates on search complexity, with the same `kitchen_1`.pddl and `obj_1`.pddl, i.e. minimum operators & objects:
* omelette_1.pddl has only eggs
* omelette_2.pddl adds veggies
* omelette_3.pddl adds salt and pepper
* omelette_4.pddl adds nutmilk and chives
* omelette_5.pddl contains all positive goal predicates without any use of axioms
* omelette_6.pddl contains one negative goal predicate

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

`test_objects.sh` tests the effect of increasing the number of objects on search complexity, with the same `kitchen_1.pddl` and `omelette_5.pddl`, i.e. full omelette:
* obj_1.pddl contains the bare minimum set of objects
* obj_2.pddl contains some alternative objects 
* obj_3.pddl contains 12 eggs
* obj_4.pddl contains multiples of every object
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


`test_egg_recipes.sh` tests the search complexity of 10 different egg-related recipes, with the same `kitchen_3.pddl` and `obj_eggs.pddl`, i.e. with all definitions and objects for egg recipes:
* scrambled_eggs.pddl specifies beaten, scrambled eggs
* omelette.pddl specifies beaten, folded eggs with veggies
* sunny_side_up.pddl specifies fried, steamed eggs on frypan
* egg_in_hole.pddl specifies fried egg in the hole of a bread

```
     t  problem_name                                                       var    op    axiom    plan    parse     search    state
------  ---------------------------------------------------------------  -----  ----  -------  ------  -------  ---------  -------
085358  kitchen_egg_4-scrambled_eggs-obj_egg_4.pddl-scrambled_eggs.pddl    312  6677      161      43    9.846  0.120834       749
085408  kitchen_egg_4-omelette-obj_egg_4.pddl-omelette.pddl                350  6680      161      52   10.03   0.119653       711
085419  kitchen_egg_4-sunny_side_up-obj_egg_4.pddl-sunny_side_up.pddl      142  4560      125      28   10.377  0.272117      2501
085432  kitchen_egg_4-egg_in_hole-obj_egg_4.pddl-crack                     202  3234      172      50   10.129  2.14165      24498
085447  kitchen_3-poached_egg-obj_eggs.pddl-poached_egg.pddl               368  4944      137      25   14.394  0.0189829      144
```

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

### Ongoing

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

## Domains

You may find more classic IPC domains in [FF Domain Collection](https://fai.cs.uni-saarland.de/hoffmann/ff-domains.html) and [IPC2018 domains](https://bitbucket.org/ipc2018-classical/domains/src/master/).

### Kitchen domain

```
    (exist-egg-in-hole ?x - env)
    (exist-poached-egg ?x - env)
    (exist-baked-egg ?x - env)
    (exist-boiled-egg ?x - env)
    (exist-deviled-egg ?x - env)
    (exist-cloud-egg ?x - env)
    (exist-quiche ?x - env)
```

---

## Planners setup

Add FastDownward or PyperPlan as git submodules:

```
git submodule add https://github.com/aibasel/downward.git
git submodule add https://github.com/aibasel/pyperplan.git
git submodule init
git submodule update
./downward/build.py release
```

---

## Experiments

Write your test script like `test_goals.sh` with all test cases. 

You can also add the following lines to `tests.sh`:

```
chmod +x test_something.sh
./test_something.sh
```
