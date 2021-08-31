(define (problem OmeletteExtended)
  (:domain grocery_costsANDkitchen_extended)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-omelette kitchen)
    )
  )
  (:metric minimize (total-cost))
)
