(define (problem OmeletteButtery)
  (:domain Kitchen)
  
  (:objects kitchen_obj)

  (:init kitchen_obj)

  (:goal
    (and
      (organized kitchen)
      (exist-omelette-buttery kitchen)
    )
  )
  (:metric minimize (total-cost))
)
