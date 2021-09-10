  (:objects

    ucup1 ucup2 dcup1 dcup2 drawer1 fridge - furniture
    burner - appliance
    kitchentop sink - worktop

    salt pepper chives - seasoning
    butter - oil
    nutmilk - liquid
    veggies1 - ingredient
    egg1 - egg

    fork1 fork2 - normalutensil
    spatula1 spatula2 - cookingutensil
    tablespoon1 tablespoon2 - measureutensil
    whisk1 whisk2 - whiskutensil

    plate1 plate2 - plate
    salter1 shaker1 container1 salter2 shaker2 container2 - normalcontainer
    milkbottle1 milkbottle2 - liquidcontainer
    smallbowl1 smallbowl2 - specialcontainer
    frypan1 frypan2 - pan
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
    (in dcup2 container1)
    (in dcup2 container2)

    (in fridge egg1)
    (in fridge veggies1)
    (in fridge milkbottle1)
    (in fridge milkbottle2)
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

    ; ----------------------
    ; properties of ingredients
    ; ----------------------
    (raw egg1)
    (sauteed veggies1)
    (is-butter butter)

  )