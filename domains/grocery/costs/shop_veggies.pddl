(define (problem order)
  (:domain grocery)
  
  (:objects obj_grocery)

  (:init obj_grocery)

  (:goal
    ( and
      ;(at-loc car1 brothers-market)
      ;(agent-has robot veggies1)
      ;(in-veh veggies1 car1)
      ;(at-loc car1 ashdown)

      ;(parked-at car1 parkinglot101)
      ;(agent-has robot veggies1)
      ;(agent-at robot home)

      (in fridge1 veggies1)
    )
  )
  
  (:metric minimize (total-cost))
)
