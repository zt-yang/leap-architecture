  (:objects

    ucup1 ucup2 dcup1 dcup2 drawer1 fridge - furniture
 
    burner - appliance

    kitchentop sink - worktop

    salt pepper chives - seasoning
    oliveoil butter - oil
    nutmilk - liquid
    veggies1 veggies2 - ingredient
    egg1 egg2 egg3 egg4 egg5 egg6 egg7 egg8 egg9 egg10 egg11 egg12 - egg

    knife1 knife2 fork1 fork2 - normalutensil
    spatula1 spatula2 - cookingutensil
    tablespoon1 tablespoon2 - measureutensil
    whisk1 whisk2 - whiskutensil

    plate1 plate2 - plate
    salter1 salter2 shaker1 shaker2 container1 container2 - normalcontainer
    oilbottle1 oilbottle2 milkbottle1 milkbottle2 - liquidcontainer
    smallbowl1 smallbowl2 bigbowl1 bigbowl2 - specialcontainer
    frypan1 frypan2 - cookingcontainer
    robot - agent

    one two three four - number

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
    (in dcup2 oilbottle1)
    (in dcup2 oilbottle2)
    (in dcup2 container1)
    (in dcup2 container2)
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
    (in fridge egg11)
    (in fridge egg12)
    (in fridge veggies1)
    (in fridge veggies2)
    (in fridge milkbottle1)
    (in fridge milkbottle2)
    (in fridge butter)

    (on kitchentop salter1)
    (on kitchentop salter2)
    (on kitchentop shaker1)
    (on kitchentop shaker2)

    (on kitchentop tablespoon1)
    (on kitchentop tablespoon2)
    (on kitchentop fork1)
    (on kitchentop fork2)
    (on kitchentop spatula1)
    (on kitchentop spatula2)
    (on kitchentop whisk1)
    (on kitchentop whisk2)

    (on kitchentop plate1)
    (on kitchentop plate2)
    (on kitchentop smallbowl1)
    (on kitchentop smallbowl2)
    (on kitchentop bigbowl1)
    (on kitchentop bigbowl2)

    ; ----------------------
    ; stored in movables
    ; ----------------------
    (inside salter1 salt)
    (inside shaker1 pepper)
    (inside container1 chives)
    (inside oilbottle1 oliveoil)
    (inside milkbottle1 nutmilk)

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
    (raw egg11)
    (raw egg12)
    (sauteed veggies1)
    (is-butter butter)

    ; ----------------------
    ; properties of agent
    ; ----------------------
    (handsfull robot)
    (holding fork1 robot)
  )