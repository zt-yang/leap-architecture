  (:objects

    ucup1 ucup2 dcup1 dcup2 drawer1 fridge - furniture

    burner - appliance

    kitchentop sink - worktop

    salt pepper chives - seasoning
    oliveoil - oil
    veggies1 - ingredient
    egg1 egg2 egg3 egg4 egg5 egg6 - egg

    knife1 fork1 - normalutensil
    spatula - cookingutensil
    tablespoon - measureutensil
    whisk1 - whiskutensil

    plate1 salter shaker container1 - normalcontainer
    oilbottle milkbottle - liquidcontainer
    smallbowl bigbowl - specialcontainer
    frypan - cookingcontainer
    robot - agent

    one two three four - number

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
    (in dcup1 frypan)
    (in dcup2 oilbottle)
    (in dcup2 container1)
    (in fridge egg1)
    (in fridge egg2)
    (in fridge egg3)
    (in fridge egg4)
    (in fridge egg5)
    (in fridge egg6)
    (in fridge veggies1)
    (in fridge milkbottle)

    (on kitchentop salter)
    (on kitchentop shaker)

    (on kitchentop tablespoon)
    (on kitchentop fork1)
    (on kitchentop spatula)
    (on kitchentop whisk1)

    (on kitchentop plate1)
    (on kitchentop smallbowl)
    (on kitchentop bigbowl)

    ; ----------------------
    ; stored in movables
    ; ----------------------
    (inside salter salt)
    (inside shaker pepper)
    (inside container1 chives)
    (inside oilbottle oliveoil)
    (inside milkbottle nutmilk)

    ; ----------------------
    ; properties of ingredients
    ; ----------------------
    (raw egg1)
    (raw egg2)
    (raw egg3)
    (raw egg4)
    (raw egg5)
    (raw egg6)
    (sauteed veggies1)

    ; ----------------------
    ; properties of agent
    ; ----------------------
    (handsfull robot)
    (holding fork1 robot)
  )