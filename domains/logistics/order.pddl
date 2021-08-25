(define (problem order)
  (:domain logistics)
  
  (:objects 
    cityX - city
    home supermarket - location

    bicycle1 - bicycle 
    truck1 - truck 
    ;airplane1 - airplane

    veggies - obj

  )

  (:init 
    (loc-in supermarket cityX)

    (at-loc bicycle1 locB)  ;; cost = 52, plan = 4 steps
    (at-loc truck1 locA)    ;; cost = 32, plan = 5 steps
    (at-loc airplane1 locA) ;; cost = 8, plan = 4 steps

    (at-loc veggies supermarket)

    ;(adj-loc-1 locA locB)
    ;(adj-loc-1 locB locC)
    ;(adj-loc-1 locC locD)

    ;; version without derived predicates
    (adj-loc locA locB)
    (adj-loc locB locA)
    (adj-loc locB locC)
    (adj-loc locC locB)
    (adj-loc locC locD)
    (adj-loc locD locC)
  )

  (:goal
    ( and
      (at-loc package1 locD)
    )
  )
  
  (:metric minimize (total-cost))
)
