(define (problem order)
  (:domain grocery)
  
  (:objects obj_grocery)

  (:init obj_grocery)

  (:goal
    ( and
      (in fridge1 egg1)
      (in fridge1 bread1)
      (in fridge1 lambchop1)
    )
  )
  
  (:metric minimize (total-cost))
)
