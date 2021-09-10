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
    holecutter1 holecutter2 - cuttingutensil
    slottedspoon1 slottedspoon2 - spoon 
    fork1 fork2 - normalutensil
    spatula1 spatula2 - cookingutensil
    tablespoon1 tablespoon2 - measureutensil
    whisk1 whisk2 - whiskutensil

    ; --- level 2 containers
    plate1 plate2 - plate
    salter1 shaker1 container1 salter2 shaker2 container2 - normalcontainer
    oilbottle1 milkbottle1 mediumbottle1 - liquidcontainer
    oilbottle2 milkbottle2 mediumbottle2 - liquidcontainer
    smallbowl1 bigbowl1 - specialcontainer
    smallbowl2 bigbowl2 - specialcontainer

    ; --- level 3 cooking containers
    frypan1 frypan2 - pan ; for reducing, sauteing, searing, or frying
    pot1 pot2 - pot ; for simmering, poaching, or boiling
    pancover1 pancover2 - containercover

    ; --- level 2 abstract objects
    one two three four five six - number
    gram cup drop - measureunit
    circle - shape
    low medium high - level

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
    (inside milkbottle1 nutmilk)
    (inside mediumbottle1 whitevinegar)
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

    ; ----------------------
    ; duplicates
    ; ----------------------
    (in dcup1 frypan2)
    (in dcup1 pancover2)
    (in dcup1 pot2)
    (in dcup2 oilbottle2)
    (in dcup2 mediumbottle2)
    (in dcup2 container2)
    (in fridge milkbottle2)
    (on kitchentop salter2)
    (on kitchentop shaker2)
    (on kitchentop tablespoon2)
    (on kitchentop holecutter2)
    (on kitchentop fork2)
    (on kitchentop slottedspoon2)
    (on kitchentop spatula2)
    (on kitchentop whisk2)
    (on kitchentop plate2)
    (on kitchentop smallbowl2)
    (on kitchentop bigbowl2)

    (inside salter2 salt)
    (inside shaker2 pepper)
    (inside container2 chives)
    (inside oilbottle2 oliveoil)
    (inside milkbottle2 nutmilk)
    (inside mediumbottle2 whitevinegar)

    (has-shape holecutter2 circle)
    (matching-size pancover2 frypan2)

    (= (total-cost) 0)
  )