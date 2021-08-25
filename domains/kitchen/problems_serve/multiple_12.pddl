(define (problem TwoDishes)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-scrambled-eggs kitchen)
      (exist-omelette kitchen)
    )
  )
  (:metric minimize (total-cost))
)
