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
      (is-buttery egg1)
      (folded egg1)
      
      (fried veggies1)
      
    )
  )
)
