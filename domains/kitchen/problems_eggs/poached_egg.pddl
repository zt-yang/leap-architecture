(define (problem PoachedEgg)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-poached-egg kitchen)
    )
  )
  (:metric minimize (total-cost))
)
