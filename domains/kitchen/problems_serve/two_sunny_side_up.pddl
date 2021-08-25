(define (problem TwoSunnySideUp)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    ( and
      ( organized kitchen )
      ( exist-two-sunny-side-up kitchen )
    )
  )
  (:metric minimize (total-cost))
)
