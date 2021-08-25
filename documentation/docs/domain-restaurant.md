# Restaurant

To create problems with hiearchical plans, we extend the Kitchen domain:

* to make multiple dishes 
* to achieve higher goals like making customers happy.

The steps include modifying operators and adding axioms so that:

* the same ingredients won't be used again, and the planner should return failure if there isn't enough ingredients
* some preparation steps, once taken for one dish, don't need to be taken again for the second dish, e.g. boil water