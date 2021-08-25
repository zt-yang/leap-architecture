(define (problem TwoOmelette)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-two-omelette kitchen)
    )
  )
  (:metric minimize (total-cost))
)
