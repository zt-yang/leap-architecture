  (:objects

    ucup1 ucup2 dcup1 dcup2 drawer1 fridge - furniture
    burner - appliance
    kitchentop sink - worktop

    salt pepper chives - seasoning
    butter - oil
    nutmilk - liquid
    veggies1 veggies2 veggies3 veggies4 veggies5 veggies6 veggies7 veggies8 veggies9 veggies10 - ingredient
    egg1 egg2 egg3 egg4 egg5 egg6 egg7 egg8 egg9 egg10 - egg

    fork1 fork2 - normalutensil
    spatula1 spatula2 - cookingutensil
    tablespoon1 tablespoon2 - measureutensil
    whisk1 whisk2 - whiskutensil
    plate1 plate2 - plate
    salter1 shaker1 container1 salter2 shaker2 container2 - normalcontainer
    milkbottle1 milkbottle2 - liquidcontainer
    smallbowl1 smallbowl2 - specialcontainer
    frypan1 frypan2 - pan

    fork3 fork4 - normalutensil
    spatula3 spatula4 - cookingutensil
    tablespoon3 tablespoon4 - measureutensil
    whisk3 whisk4 - whiskutensil
    plate3 plate4 - plate
    salter3 shaker3 container3 salter4 shaker4 container4 - normalcontainer
    milkbottle3 mediumbottle3 - liquidcontainer
    milkbottle4 mediumbottle4 - liquidcontainer
    smallbowl3 smallbowl4 - specialcontainer
    frypan3 frypan4 - pan 

    robot - agent

    one two three four five six - number
    gram cup - measureunit
    kitchen - env 

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

    ; ----------------------
    ; stored in places that cannot move
    ; ----------------------
    (in dcup1 frypan1)
    (in dcup1 frypan2)
    (in dcup1 frypan3)
    (in dcup1 frypan4)
    (in dcup2 container1)
    (in dcup2 container2)
    (in dcup2 container3)
    (in dcup2 container4)

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
    (in fridge milkbottle2)
    (in fridge milkbottle3)
    (in fridge milkbottle4)
    (in fridge butter)

    (on kitchentop salter1)
    (on kitchentop shaker1)
    (on kitchentop tablespoon1)
    (on kitchentop fork1)
    (on kitchentop spatula1)
    (on kitchentop whisk1)
    (on kitchentop plate1)
    (on kitchentop smallbowl1)

    (on kitchentop salter2)
    (on kitchentop shaker2)
    (on kitchentop tablespoon2)
    (on kitchentop fork2)
    (on kitchentop spatula2)
    (on kitchentop whisk2)
    (on kitchentop plate2)
    (on kitchentop smallbowl2)

    (on kitchentop salter3)
    (on kitchentop shaker3)
    (on kitchentop tablespoon3)
    (on kitchentop fork3)
    (on kitchentop spatula3)
    (on kitchentop whisk3)
    (on kitchentop plate3)
    (on kitchentop smallbowl3)

    (on kitchentop salter4)
    (on kitchentop shaker4)
    (on kitchentop tablespoon4)
    (on kitchentop fork4)
    (on kitchentop spatula4)
    (on kitchentop whisk4)
    (on kitchentop plate4)
    (on kitchentop smallbowl4)

    ; ----------------------
    ; stored in movables
    ; ----------------------
    (inside salter1 salt)
    (inside shaker1 pepper)
    (inside container1 chives)
    (inside milkbottle1 nutmilk)

    (inside salter2 salt)
    (inside shaker2 pepper)
    (inside container2 chives)
    (inside milkbottle2 nutmilk)

    (inside salter3 salt)
    (inside shaker3 pepper)
    (inside container3 chives)
    (inside milkbottle3 nutmilk)

    (inside salter4 salt)
    (inside shaker4 pepper)
    (inside container4 chives)
    (inside milkbottle4 nutmilk)

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

  )