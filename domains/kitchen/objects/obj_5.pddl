  (:objects

    ucup1 ucup2 dcup1 dcup2 drawer1 fridge - furniture
    burner - appliance
    kitchentop sink - worktop

    salt pepper chives - seasoning
    butter - oil
    nutmilk - liquid
    veggies1 - ingredient
    egg1 - egg


    fork1 - normalutensil
    spatula1 - cookingutensil
    tablespoon1 - measureutensil
    whisk1 - whiskutensil
    plate1 - plate
    salter1 shaker1 container1 - normalcontainer
    milkbottle1 - liquidcontainer
    smallbowl1 - specialcontainer
    frypan1 - pan


    fork2 - normalutensil
    spatula2 - cookingutensil
    tablespoon2 - measureutensil
    whisk2 - whiskutensil
    plate2 - plate
    salter2 shaker2 container2 - normalcontainer
    milkbottle2 - liquidcontainer
    smallbowl2 - specialcontainer
    frypan2 - pan


    fork3 - normalutensil
    spatula3 - cookingutensil
    tablespoon3 - measureutensil
    whisk3 - whiskutensil
    plate3 - plate
    salter3 shaker3 container3 - normalcontainer
    milkbottle3 - liquidcontainer
    smallbowl3 - specialcontainer
    frypan3 - pan


    fork4 - normalutensil
    spatula4 - cookingutensil
    tablespoon4 - measureutensil
    whisk4 - whiskutensil
    plate4 - plate
    salter4 shaker4 container4 - normalcontainer
    milkbottle4 - liquidcontainer
    smallbowl4 - specialcontainer
    frypan4 - pan


    fork5 - normalutensil
    spatula5 - cookingutensil
    tablespoon5 - measureutensil
    whisk5 - whiskutensil
    plate5 - plate
    salter5 shaker5 container5 - normalcontainer
    milkbottle5 - liquidcontainer
    smallbowl5 - specialcontainer
    frypan5 - pan


    fork6 - normalutensil
    spatula6 - cookingutensil
    tablespoon6 - measureutensil
    whisk6 - whiskutensil
    plate6 - plate
    salter6 shaker6 container6 - normalcontainer
    milkbottle6 - liquidcontainer
    smallbowl6 - specialcontainer
    frypan6 - pan


    fork7 - normalutensil
    spatula7 - cookingutensil
    tablespoon7 - measureutensil
    whisk7 - whiskutensil
    plate7 - plate
    salter7 shaker7 container7 - normalcontainer
    milkbottle7 - liquidcontainer
    smallbowl7 - specialcontainer
    frypan7 - pan


    fork8 - normalutensil
    spatula8 - cookingutensil
    tablespoon8 - measureutensil
    whisk8 - whiskutensil
    plate8 - plate
    salter8 shaker8 container8 - normalcontainer
    milkbottle8 - liquidcontainer
    smallbowl8 - specialcontainer
    frypan8 - pan


    fork9 - normalutensil
    spatula9 - cookingutensil
    tablespoon9 - measureutensil
    whisk9 - whiskutensil
    plate9 - plate
    salter9 shaker9 container9 - normalcontainer
    milkbottle9 - liquidcontainer
    smallbowl9 - specialcontainer
    frypan9 - pan


    fork10 - normalutensil
    spatula10 - cookingutensil
    tablespoon10 - measureutensil
    whisk10 - whiskutensil
    plate10 - plate
    salter10 shaker10 container10 - normalcontainer
    milkbottle10 - liquidcontainer
    smallbowl10 - specialcontainer
    frypan10 - pan


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
    (in dcup2 container1)

    (in fridge egg1)
    (in fridge veggies1)
    (in fridge milkbottle1)
    (in fridge butter)

    (on kitchentop salter1)
    (on kitchentop shaker1)
    (on kitchentop tablespoon1)
    (on kitchentop fork1)
    (on kitchentop spatula1)
    (on kitchentop whisk1)
    (on kitchentop plate1)
    (on kitchentop smallbowl1)

    ; ----------------------
    ; stored in movables
    ; ----------------------
    (inside salter1 salt)
    (inside shaker1 pepper)
    (inside container1 chives)
    (inside milkbottle1 nutmilk)

    ; ----------------------
    ; multiples
    ; ----------------------
    (in dcup1 frypan2)
    (in dcup2 container2)
    (in fridge milkbottle2)
    (on kitchentop salter2)
    (on kitchentop shaker2)
    (on kitchentop tablespoon2)
    (on kitchentop fork2)
    (on kitchentop spatula2)
    (on kitchentop whisk2)
    (on kitchentop plate2)
    (on kitchentop smallbowl2)
    (inside salter2 salt)
    (inside shaker2 pepper)
    (inside container2 chives)
    (inside milkbottle2 nutmilk)

    (in dcup1 frypan3)
    (in dcup2 container3)
    (in fridge milkbottle3)
    (on kitchentop salter3)
    (on kitchentop shaker3)
    (on kitchentop tablespoon3)
    (on kitchentop fork3)
    (on kitchentop spatula3)
    (on kitchentop whisk3)
    (on kitchentop plate3)
    (on kitchentop smallbowl3)
    (inside salter3 salt)
    (inside shaker3 pepper)
    (inside container3 chives)
    (inside milkbottle3 nutmilk)


    (in dcup1 frypan4)
    (in dcup2 container4)
    (in fridge milkbottle4)
    (on kitchentop salter4)
    (on kitchentop shaker4)
    (on kitchentop tablespoon4)
    (on kitchentop fork4)
    (on kitchentop spatula4)
    (on kitchentop whisk4)
    (on kitchentop plate4)
    (on kitchentop smallbowl4)
    (inside salter4 salt)
    (inside shaker4 pepper)
    (inside container4 chives)
    (inside milkbottle4 nutmilk)


    (in dcup1 frypan5)
    (in dcup2 container5)
    (in fridge milkbottle5)
    (on kitchentop salter5)
    (on kitchentop shaker5)
    (on kitchentop tablespoon5)
    (on kitchentop fork5)
    (on kitchentop spatula5)
    (on kitchentop whisk5)
    (on kitchentop plate5)
    (on kitchentop smallbowl5)
    (inside salter5 salt)
    (inside shaker5 pepper)
    (inside container5 chives)
    (inside milkbottle5 nutmilk)


    (in dcup1 frypan6)
    (in dcup2 container6)
    (in fridge milkbottle6)
    (on kitchentop salter6)
    (on kitchentop shaker6)
    (on kitchentop tablespoon6)
    (on kitchentop fork6)
    (on kitchentop spatula6)
    (on kitchentop whisk6)
    (on kitchentop plate6)
    (on kitchentop smallbowl6)
    (inside salter6 salt)
    (inside shaker6 pepper)
    (inside container6 chives)
    (inside milkbottle6 nutmilk)


    (in dcup1 frypan7)
    (in dcup2 container7)
    (in fridge milkbottle7)
    (on kitchentop salter7)
    (on kitchentop shaker7)
    (on kitchentop tablespoon7)
    (on kitchentop fork7)
    (on kitchentop spatula7)
    (on kitchentop whisk7)
    (on kitchentop plate7)
    (on kitchentop smallbowl7)
    (inside salter7 salt)
    (inside shaker7 pepper)
    (inside container7 chives)
    (inside milkbottle7 nutmilk)


    (in dcup1 frypan8)
    (in dcup2 container8)
    (in fridge milkbottle8)
    (on kitchentop salter8)
    (on kitchentop shaker8)
    (on kitchentop tablespoon8)
    (on kitchentop fork8)
    (on kitchentop spatula8)
    (on kitchentop whisk8)
    (on kitchentop plate8)
    (on kitchentop smallbowl8)
    (inside salter8 salt)
    (inside shaker8 pepper)
    (inside container8 chives)
    (inside milkbottle8 nutmilk)


    (in dcup1 frypan9)
    (in dcup2 container9)
    (in fridge milkbottle9)
    (on kitchentop salter9)
    (on kitchentop shaker9)
    (on kitchentop tablespoon9)
    (on kitchentop fork9)
    (on kitchentop spatula9)
    (on kitchentop whisk9)
    (on kitchentop plate9)
    (on kitchentop smallbowl9)
    (inside salter9 salt)
    (inside shaker9 pepper)
    (inside container9 chives)
    (inside milkbottle9 nutmilk)


    (in dcup1 frypan10)
    (in dcup2 container10)
    (in fridge milkbottle10)
    (on kitchentop salter10)
    (on kitchentop shaker10)
    (on kitchentop tablespoon10)
    (on kitchentop fork10)
    (on kitchentop spatula10)
    (on kitchentop whisk10)
    (on kitchentop plate10)
    (on kitchentop smallbowl10)
    (inside salter10 salt)
    (inside shaker10 pepper)
    (inside container10 chives)
    (inside milkbottle10 nutmilk)


    ; ----------------------
    ; properties of ingredients
    ; ----------------------
    (raw egg1)
    (sauteed veggies1)
    (is-butter butter)

  )