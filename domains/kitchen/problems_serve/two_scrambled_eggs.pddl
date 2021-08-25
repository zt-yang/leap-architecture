(define (problem TwoScrambledEggs)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-two-scrambled-eggs kitchen)
    )
  )
  (:metric minimize (total-cost))
)
