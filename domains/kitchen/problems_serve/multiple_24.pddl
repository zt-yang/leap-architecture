(define (problem DishesThreeFour)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-scrambled-eggs kitchen)
      (exist-egg-in-hole kitchen)
    )
  )
  (:metric minimize (total-cost))
)
