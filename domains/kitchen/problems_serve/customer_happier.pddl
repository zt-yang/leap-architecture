(define (problem CustomerHappier)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (customer-happier customer1)
    )
  )
  (:metric minimize (total-cost))
)
