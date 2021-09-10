  (:objects

    ; --- level 1 physical objects
    burner - appliance
    kitchentop sink - worktop
    kitchen - env 
    robot - agent
    customer1 - customer

    ; --- level 2 ingredients
    salt pepper chives thyme - seasoning
    whitevinegar - vinegar
    oliveoil butter - oil
    water nutmilk - liquid
    faucet - liquidtap
    garlic1 - garlic

    ; --- level 2 utensils
    holecutter1 - cuttingutensil
    fork1 - normalutensil
    spatula1 - cookingutensil
    tablespoon1 - measureutensil

    ; --- level 2 containers
    plate1 - plate
    salter1 shaker1 container1 glasscontainer1 - normalcontainer
    oilbottle1 milkbottle1 mediumbottle1 smallbottle1 - liquidcontainer
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
    dcup1 - furniture
    fridge1 - furniture
    veggies1 - ingredient
    lambchop1 - lambchop
    egg1 - egg
    egg2 - egg
    bread1 - bread
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
    (in dcup1 oilbottle1)
    (in dcup1 mediumbottle1)
    (in dcup1 container1)

    (in fridge1 milkbottle1)
    (in fridge1 butter)
    (in fridge1 glasscontainer1)

    (on kitchentop faucet)

    (on kitchentop salter1)
    (on kitchentop shaker1)
    (on kitchentop smallbottle1)

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
    (inside smallbottle1 thyme)
    (inside oilbottle1 oliveoil)
    (inside mediumbottle1 whitevinegar)
    (inside milkbottle1 nutmilk)
    (inside faucet water)
    (inside glasscontainer1 garlic1)

    ; ----------------------
    ; properties of ingredients
    ; ----------------------
    (needs-peeling egg1)
    (needs-peeling egg2)
    (raw egg1)
    (raw egg2)
    (sauteed veggies1)
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
    ;(in fridge1 bread1)
    ;(in fridge1 egg1)
    ;(in fridge1 egg2)
    ;(in fridge1 veggies1)
    ;(in fridge1 lambchop1)
    ;(in dcup1 pot1)

    (= (total-cost) 0)
  )