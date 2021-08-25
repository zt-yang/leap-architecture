(define (problem EggInHoleButtery)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-egg-in-hole-buttery kitchen)
    )
  )
  (:metric minimize (total-cost))
)
