(define (problem TwoDishes)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-two-egg-dishs kitchen)
    )
  )
  (:metric minimize (total-cost))
)
