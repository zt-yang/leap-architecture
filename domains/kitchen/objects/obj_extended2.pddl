  (:objects

    ; --- level 1 physical objects
    dcup1 - furniture
    burner - appliance
    kitchentop sink - worktop
    kitchen - env 
    robot - agent
    customer1 - customer

    ; --- level 2 ingredients
    salt pepper chives - seasoning
    whitevinegar - vinegar
    oliveoil butter - oil
    water nutmilk - liquid
    faucet - liquidtap
    egg1 - egg
    bread1 - bread

    ; --- level 2 utensils
    holecutter1 - cuttingutensil
    fork1 - normalutensil
    spatula1 - cookingutensil
    tablespoon1 - measureutensil

    ; --- level 2 containers
    plate1 - plate
    salter1 shaker1 container1 - normalcontainer
    oilbottle1 milkbottle1 mediumbottle1 - liquidcontainer
    smallbowl1 - specialcontainer

    ; --- level 3 cooking containers
    frypan1 - pan ; for reducing, sauteing, searing, or frying
    pancover1 - containercover

    ; --- level 2 abstract objects
    one two three four five six - number
    gram cup drop - measureunit
    circle - shape
    low medium high - level
    outerside innerside - part
    hard medium-hard soft - hardnesslevel

    ;; to merge with grocery
    veggies1 - ingredient
    fridge1 - furniture
    pot1 - pot
  )

  (:init

    ; ----------------------
    ; properties of places that cannot move
    ; ----------------------
    (closed dcup1)
    (closed fridge1)
    (switchedoff burner)
    (default-level burner low)
    (turnedoff faucet)

    ; ----------------------
    ; stored in places that cannot move
    ; ----------------------
    (in dcup1 frypan1)
    (in dcup1 pot1)
    (in dcup1 oilbottle1)
    (in dcup1 mediumbottle1)
    (in dcup1 container1)

    (in fridge1 egg1)
    (in fridge1 milkbottle1)
    (in fridge1 butter)

    (on kitchentop faucet)
    (on kitchentop bread1)

    (on kitchentop salter1)
    (on kitchentop shaker1)

    (on kitchentop tablespoon1)
    (on kitchentop holecutter1)
    (on kitchentop fork1)
    (on kitchentop spatula1)

    (on kitchentop plate1)
    (on kitchentop smallbowl1)

    ; ----------------------
    ; stored in movables
    ; ----------------------
    (inside salter1 salt)
    (inside shaker1 pepper)
    (inside container1 chives)
    (inside oilbottle1 oliveoil)
    (inside mediumbottle1 whitevinegar)
    (inside milkbottle1 nutmilk)
    (inside faucet water)

    ; ----------------------
    ; properties of ingredients
    ; ----------------------
    (needs-peeling egg1)
    (sauteed veggies1)
    (raw egg1)
    (is-butter butter)
    (has-shape holecutter1 circle)

    ; ----------------------
    ; for recipes other than omelette
    ; ----------------------
    (matching-size pancover1 frypan1)
    (in dcup1 pancover1)

    ; ----------------------
    ; needs to be achieved by grocery problem
    ; ----------------------
    ;(in fridge1 veggies1)

    (= (total-cost) 0)
  )