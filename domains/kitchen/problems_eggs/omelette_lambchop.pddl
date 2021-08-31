(define (problem OmeletteLambchop)
  (:domain grocery_costsANDkitchen_lambchop)
  
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
