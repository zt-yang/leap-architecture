(define (problem SunnySideUpButtery)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    ( and
      ( organized kitchen )
      ( exist-sunny-side-up-buttery kitchen )
    )
  )
  (:metric minimize (total-cost))
)
