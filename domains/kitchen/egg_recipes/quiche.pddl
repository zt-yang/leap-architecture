(define (problem Quiche)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-quiche kitchen)
    )
  )
)
