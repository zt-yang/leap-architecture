(define (problem TwoPoachedEgg)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-two-poached-egg kitchen)
    )
  )
  (:metric minimize (total-cost))
)
