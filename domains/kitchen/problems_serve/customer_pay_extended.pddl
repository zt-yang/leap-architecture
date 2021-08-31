(define (problem CustomerPay)
  (:domain grocery_costsANDkitchen_happy)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (customer-pay customer1)
    )
  )
  (:metric minimize (total-cost))
)
