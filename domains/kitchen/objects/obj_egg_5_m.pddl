  (:objects

    ; --- level 1 physical objects
    ucup1 ucup2 dcup1 dcup2 drawer1 fridge - furniture
    burner - appliance
    kitchentop sink - worktop
    kitchen - env 
    robot - agent

    ; --- level 2 ingredients
    salt pepper chives - seasoning
    whitevinegar - vinegar
    oliveoil butter - oil
    water nutmilk - liquid
    faucet - liquidtap
    veggies1 veggies2 veggies3 veggies4 veggies5 veggies6 veggies7 veggies8 veggies9 veggies10 - ingredient
    egg1 egg2 egg3 egg4 egg5 egg6 egg7 egg8 egg9 egg10 - egg
    bread1 toast1 - bread

    ; --- level 2 utensils
    holecutter1 - cuttingutensil
    slottedspoon1 - spoon 
    knife1 fork1 - normalutensil
    spatula1 - cookingutensil
    tablespoon1 - measureutensil
    whisk1 - whiskutensil

    ; --- level 2 containers
    plate1 - plate
    salter1 shaker1 container1 - normalcontainer
    oilbottle1 milkbottle1 mediumbottle1 - liquidcontainer
    smallbowl1 bigbowl1 - specialcontainer

    ; --- level 3 cooking containers
    frypan1 - pan ; for reducing, sauteing, searing, or frying
    pot1 - pot ; for simmering, poaching, or boiling
    pancover1 - containercover

    ; --- level 2 abstract objects
    one two three four - number
    gram cup drop - measureunit
    circle - shape
    low medium high - level
    outerside innerside - part
    hard medium-hard soft - hardnesslevel

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
    (default-level burner low)
    (turnedoff faucet)

    ; ----------------------
    ; stored in places that cannot move
    ; ----------------------
    (in dcup1 frypan1)
    (in dcup1 pot1)
    (in dcup2 oilbottle1)
    (in dcup2 mediumbottle1)
    (in dcup2 container1)

    (in fridge egg1)
    (in fridge egg2)
    (in fridge egg3)
    (in fridge egg4)
    (in fridge egg5)
    (in fridge egg6)
    (in fridge egg7)
    (in fridge egg8)
    (in fridge egg9)
    (in fridge egg10)

    (in fridge veggies1)
    (in fridge veggies2)
    (in fridge veggies3)
    (in fridge veggies4)
    (in fridge veggies5)
    (in fridge veggies6)
    (in fridge veggies7)
    (in fridge veggies8)
    (in fridge veggies9)
    (in fridge veggies10)

    (in fridge milkbottle1)
    (in fridge butter)

    (on kitchentop faucet)
    (on kitchentop bread1)
    (on kitchentop toast1)

    (on kitchentop salter1)
    (on kitchentop shaker1)

    (on kitchentop tablespoon1)
    (on kitchentop holecutter1)
    (on kitchentop fork1)
    (on kitchentop slottedspoon1)
    (on kitchentop spatula1)
    (on kitchentop whisk1)

    (on kitchentop plate1)
    (on kitchentop smallbowl1)
    (on kitchentop bigbowl1)

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
    (raw egg1)
    (raw egg2)
    (raw egg3)
    (raw egg4)
    (raw egg5)
    (raw egg6)
    (raw egg7)
    (raw egg8)
    (raw egg9)
    (raw egg10)
    (sauteed veggies1)
    (sauteed veggies2)
    (sauteed veggies3)
    (sauteed veggies4)
    (sauteed veggies5)
    (sauteed veggies6)
    (sauteed veggies7)
    (sauteed veggies8)
    (sauteed veggies9)
    (sauteed veggies10)
    
    (is-butter butter)
    (has-shape holecutter1 circle)

    ; ----------------------
    ; for recipes other than omelette
    ; ----------------------
    (matching-size pancover1 frypan1)
    (in dcup1 pancover1)

    (= (total-cost) 0)
  )