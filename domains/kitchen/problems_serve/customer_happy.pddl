(define (problem CustomerHappy)
  (:domain Kitchen)
  
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
