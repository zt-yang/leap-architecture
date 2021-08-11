(define (problem BakedEgg)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-baked-egg kitchen)
    )
  )
)
