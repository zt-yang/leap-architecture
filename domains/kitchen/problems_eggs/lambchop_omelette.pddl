(define (problem Lambchop)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-omelette kitchen)
      (exist-cooked-lambchop kitchen)
    )
  )
  (:metric minimize (total-cost))
)
