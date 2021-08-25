# Grocery shopping domain

The grocery domain is developed to extend the kitchen domain, while testing the plan quality of satisfising LAMA (`lama-firt`), optimising LAMA (`lama`), and LEAP. The great city of Boston is simulated:

![Map of Boston](imgs/grocery-map.png)

## Types and Predicates

* Transportation happens between `location`s, which are marked either by dots or squares
* An `area`, represented by a black dot, is a large `location`. 
* Areas contain precise `location`s, which are represented by colored squares. Each precise `location` also contains a unmarked `parkinglot`, which is also of type `location`

#### Cost of traveling time:

* Between areas, cost of driving is 4, while cost of walking is 8
* Between an area and its locations, cost of driving or walking is 2
* Between locations in an area, cost of driving or walking is 4 = 2 + 2

#### Cost of shopping:

* In terms of pricing, `brothers-market`/`hmart` > `wholefoods` > `traderjoes`/`star-market`/`c-mart`, whose costs are 30, 20, 10 for each iterm respectively
* At `butchers-shop`, each item costs 30
* At `chocolate-shop`, each item costs 20
* At `pastry`, each item costs 10

#### Other costs:

* Cost of parking is 5 anywhere
* Costs of other operators are 1

#### Category of shopping:

* All markets sell `ingredient`
* Places that sell `utensil`: `hmart`, `wholefoods`, `star-market`, `cmart`
* Places that sell `alcohol`: `brothers-market`, `wholefoods`, `star-market`
* Places that sell `lamb-rack`: `butchers`
* Places that sell `pasta`: `brothers-market`
* Places that sell `chocolate`: `chocolate-shop`
* Places that sell `cake`: `pastry`
* `cmart` doesn't sell `seafood`
* `traderjoes` doesn't sell `baverages` 

## Example problems and expected results

Note that in the following calculation of costs, the cost of the same operations are omitted (e.g., parking once, entering building).

![Map of Boston](imgs/grocery-map.png)

#### `shop-veggie.pddl` requires purchase of `veggie1`:

* `lama-firt` would choose `brothers-market`, cost = 2+2 + 30 + 2+2 = 38
* `lama` would choose `wholefoods-cs` or `wholefoods-cp`, cost = 2+4+2 + 20 + 2+4+2 = 36

#### `shop-omelette.pddl` requires purchase of `veggies1` and `egg1`:

* `lama-firt` would choose `brothers-market`, cost = 2+2 + 60 + 2+2 = 68 
* `lama` would choose `traderjoes-ns` or `starmarket-ns`, cost = 2+4+4+2 + 20 + 2+4+4+2 = 44

#### `shop-lamb-plate.pddl` requires purchase of `veggies1` and `lamb-chop1`:

* `lama-firt` would choose to park at `beacon-hill`, shop at `wholefoods-bh` and `butchers-shop-bh`, cost = 2+4+4 + 5 + 2 + 30 + 2+2 + 20 + 2+4+4+2 = 83
* `lama` would choose to first shop at`traderjoes-ns` or `starmarket-ns`, then shop at `butchers-shop-bh`, parking twice and traveling further, cost = 2+4+4+2 + 5 + 10 + 2+4+2 + 5 + 30 + 2+4+4+2 = 82



