(define (problem DeviledEgg)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-deviled-egg kitchen)
    )
  )
)
