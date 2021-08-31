(define (problem Lambchop)
  (:domain grocery_costsANDkitchen_happy)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-poached-egg kitchen)
      (exist-cooked-lambchop kitchen)
    )
  )
  (:metric minimize (total-cost))
)
