(define (problem ThreeDishes)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-sunny-side-up kitchen)
      (exist-egg-in-hole kitchen)
      (exist-poached-egg kitchen)
    )
  )
  (:metric minimize (total-cost))
)
