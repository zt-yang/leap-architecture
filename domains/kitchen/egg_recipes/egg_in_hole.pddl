(define (problem EggInHole)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-egg-in-hole kitchen)
    )
  )
  (:metric minimize (total-cost))
)
