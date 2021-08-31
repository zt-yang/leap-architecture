(define (problem CustomerHappy)
  (:domain grocery_costsANDkitchen_happy)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (customer-happy customer1)
    )
  )
  (:metric minimize (total-cost))
)
