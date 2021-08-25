(define (problem order)
  (:domain grocery)
  
  (:objects obj_grocery)

  (:init obj_grocery)

  (:goal
    ( and
      ;(parked-at car1 parkinglot1)
      ;(agent-at robot parkinglot1)
      ;(agent-has robot veggies1)
      ;(in-veh veggies1 car1) 
      ;(paid veggies1)
      (in fridge1 veggies1)
    )
  )
  
  ;(:metric minimize (total-cost))
)
