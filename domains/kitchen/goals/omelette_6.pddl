(define (problem Omelette)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (closed ucup1)
      (closed ucup2)
      (closed dcup1)
      (closed dcup2)
      (closed drawer1)
      (closed fridge)
      (switchedoff burner)

      (beaten egg1)
      (fried egg1)
      (folded egg1)
      (is-buttery egg1)
      
      (fried veggies1)

      (has-seasoning egg1 salt gram four)
      (seasoning-mixed egg1 salt)

      (has-seasoning egg1 pepper gram four)
      (seasoning-mixed egg1 pepper)

      (has-seasoning egg1 chives tablespoon2 two)
      (seasoning-mixed egg1 chives)

      (has-seasoning egg1 nutmilk cup two)

      (not (burned-appliance burner))

    )
  )
)
