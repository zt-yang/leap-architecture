(define (problem DishesOneFive)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-omelette kitchen)
      (exist-egg-in-hole kitchen)
    )
  )
  (:metric minimize (total-cost))
)
