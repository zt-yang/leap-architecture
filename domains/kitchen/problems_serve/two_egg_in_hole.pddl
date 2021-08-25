(define (problem TwoEggInHole)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-two-egg-in-hole kitchen)
    )
  )
  (:metric minimize (total-cost))
)
