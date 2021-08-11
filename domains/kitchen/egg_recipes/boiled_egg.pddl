(define (problem BoiledEgg)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-boiled-egg kitchen)
    )
  )
)
