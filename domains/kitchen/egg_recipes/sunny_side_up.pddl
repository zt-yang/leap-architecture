(define (problem SunnySideUp)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    ( and
      ( organized kitchen )
      ( exist-sunny-side-up kitchen )
    )
  )
)
