  (:objects

    ucup1 ucup2 dcup1 dcup2 drawer1 fridge - furniture
 
    burner - appliance

    kitchentop sink - worktop

    salt pepper chives - seasoning
    oliveoil butter - oil
    nutmilk - liquid
    veggies1 - ingredient
    egg1 egg2 - egg

    knife1 fork1 - normalutensil
    spatula1 - cookingutensil
    tablespoon1 tablespoon2 - measureutensil
    whisk1 - whiskutensil

    plate1 - plate
    salter1 shaker1 container1 - normalcontainer
    oilbottle1 milkbottle1 - liquidcontainer
    smallbowl1 bigbowl1 - specialcontainer
    frypan1 - cookingcontainer
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
    (in dcup2 oilbottle1)
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
    (in fridge egg11)
    (in fridge egg12)
    (in fridge veggies1)
    (in fridge milkbottle1)
    (in fridge butter)

    (on kitchentop salter1)
    (on kitchentop shaker1)

    (on kitchentop tablespoon1)
    (on kitchentop tablespoon2)
    (on kitchentop fork1)
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

    ; ----------------------
    ; properties of ingredients
    ; ----------------------
    (raw egg1)
    (raw egg2)
    (sauteed veggies1)
    (is-butter butter)
    ;(is-cookingcontainer frypan1)

    ; ----------------------
    ; properties of agent
    ; ----------------------
    (handsfull robot)
    (holding fork1 robot)
  )