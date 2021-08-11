(define (problem Omelette)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-omelette kitchen)
    )
  )
)
