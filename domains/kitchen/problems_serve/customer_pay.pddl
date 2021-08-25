(define (problem CustomerPay)
  (:domain Kitchen)
  
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
