(define (problem drive)
  (:domain grocery)
  
  (:objects obj_grocery)

  (:init obj_grocery)

  (:goal
    ( and
      ;(agent-at robot ashdown)
      ;(agent-at robot parkinglot101)

      ;(agent-at robot car1)
      ;(at-loc car1 parkinglot101)

      ;(contain-loc ashdown parkinglot101)

      (at-loc car1 mit-campus)
      ;(at-loc car1 stata)
      ;(agent-at robot stata)
      ;(agent-at robot mit-campus)
      ;(agent-at robot wholefoods-cs)

      ;(agent-at robot allston)
      ;(at-loc car1 allston)
      ; ----------------------------------

      ;(at-loc car1 stata)
    )
  )
  
  (:metric minimize (total-cost))
)
