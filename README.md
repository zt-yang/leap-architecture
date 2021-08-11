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

`test_objects.sh` tests the effect of increasing the number of objects on search complexity, with the same `kitchen_1.pddl` and `omelette_5.pddl`, i.e. full omelette:
* obj_1.pddl contains the bare minimum set of objects
* obj_2.pddl contains some alternative objects 
* obj_3.pddl contains 12 eggs
* obj_4.pddl contains multiples of every object
* obj_eggs.pddl contains all objects for making 10 egg recipes

`test_egg_recipes.sh` tests the search complexity of 10 different egg-related recipes, with the same `kitchen_3.pddl` and `obj_eggs.pddl`, i.e. with all definitions and objects for egg recipes:
* scrambled_eggs.pddl specifies beaten, scrambled eggs
* omelette.pddl specifies beaten, folded eggs with veggies
* sunny_side_up.pddl specifies fried, steamed eggs on frypan
* egg_in_hole.pddl specifies fried egg in the hole of a bread

`test_operators` tests the effect of increasing the number of operators (for multiple recipes) on search complexity, with the same `omelette.pddl` and `obj_1.pddl`, i.e. minimum plan length & objects:
* kitchen_1.pddl contains all operators for omelette recipe
* kitchen_2.pddl contains all operators for omelette + maintanance goals
* kitchen_3.pddl contains all operators & definitions for 10 egg recipes
* kitchen_4.pddl contains all operators & definitions for egg & baking recipes

> TODO: change the `obj_1.pddl` here to `obj_4`.pddl and obj_eggs.pddl to make the problem combinatorially complicated

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
