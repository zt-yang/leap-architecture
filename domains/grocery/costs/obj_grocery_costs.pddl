  (:objects 

    home supermarket - location
    market1 - store
    parkinglot1 - parkinglot

    car1 - truck 
    card1 - credit-card

    ;; to merge with kitchen_extended
    veggies1 - ingredient
    fridge1 - furniture
    robot - agent
  )

  (:init 

    (at-loc car1 home)  

    ;; version without derived predicates
    (adj-loc-1 home supermarket)
    (adj-loc-1 supermarket home)

    (agent-at robot home)
    (agent-has robot card1)

    (contain-loc supermarket market1)
    (contain-loc supermarket parkinglot1)
    (at-loc veggies1 market1)
  )