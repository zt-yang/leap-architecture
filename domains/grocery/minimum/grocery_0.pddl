(define (domain grocery)

  (:requirements :adl :action-costs ) ;; :derived-predicates 

  (:types
    physicalobj location agent item - object
    moveable vehicle - physicalobj
    bicycle truck airplane - vehicle
    airport parkinglot building - location
    store - building
    payment-item - item
    credit-card - payment-item

    ;; to merge with kitchen_extended
    ingredient utensil - moveable
    staticobject - object
    furniture - staticobject
  )

  (:predicates
    (at-loc ?x - physicalobj ?l - location) 
    (in-veh ?p - moveable ?v - vehicle) 

    ;; in order for the rule of "if A adj with B, then B adj with A"
    (adj-loc-1 ?l1 - location ?l2 - location)
    (adj-loc-2 ?l1 - location ?l2 - location)
    (adj-loc ?l1 - location ?l2 - location)

    (contain-loc ?l1 - location ?l2 - location)
    (agent-at ?a - agent ?l - location)
    (agent-has ?a - agent ?i - object)
    (paid ?i - item)
    (parked ?v - vehicle)
    (parked-at ?v - vehicle ?l - location)
    (shopping-at ?a - agent ?l - store)

    ;; to merge with kitchen_extended
    (in ?x - furniture ?y - moveable)
  )

  (:action pay-grocery
    :parameters (?o - moveable ?l - store ?p - payment-item ?a - agent)
    :precondition (and 
      (agent-has ?a ?p)
      (at-loc ?o ?l)
      (shopping-at ?a ?l)
    )
    :effect (and 
      (paid ?o)
      (agent-has ?a ?o)
    )
  )

  (:action load-grocery
    :parameters (?o - moveable ?v - vehicle ?p - parkinglot ?a - agent)
    :precondition (and 
      (parked-at ?v ?p) 
      (agent-has ?a ?o)
      ;(agent-at ?a ?p)
    )
    :effect (and 
      (in-veh ?o ?v) 
    )
  )

  (:action load
    :parameters (?o - moveable ?v - vehicle ?l - location)
    :precondition (and 
      (at-loc ?v ?l) 
      (at-loc ?o ?l)
      (not (= ?l market1))
    )
    :effect (and 
      (in-veh ?o ?v) 
      (not (at-loc ?o ?l) )
      (increase (total-cost) 1)
    )
  )

  (:action unload
    :parameters (?o - moveable ?v - vehicle ?l - location)
    :precondition (and 
      (at-loc ?v ?l) 
      (in-veh ?o ?v)
    )
    :effect (and 
      (at-loc ?o ?l) 
      (not (in-veh ?o ?v))
      (increase (total-cost) 1)
    )
  )

  (:action enter-vehicle
    :parameters (?t - vehicle ?l - location ?a - agent)
    :precondition (and 
      (at-loc ?t ?l)
      (agent-at ?a ?l)
    )
    :effect (and 
      (not (agent-at ?a ?l))
      (agent-at ?a ?t)
    )
  )

  (:action exit-vehicle
    :parameters (?t - vehicle ?l - location ?a - agent)
    :precondition (and 
      (at-loc ?t ?l)
      (agent-at ?a ?t)
    )
    :effect (and 
      (not (agent-at ?a ?t))
      (agent-at ?a ?l)
    )
  )

  (:action enter-building
    :parameters (?t - vehicle ?b - building ?a - agent)
    :precondition (and 
      (agent-at ?a ?b)
      (parked ?t)
    )
    :effect (and 
      (agent-at ?a ?b)
      (shopping-at ?a ?b)
    )
  )

  (:action park-vehicle
    :parameters (?t - vehicle ?l - location ?p - location ?a - agent)
    :precondition (and 
      (at-loc ?t ?l)
      (agent-at ?a ?t)
      (contain-loc ?l ?p)
    )
    :effect (and 
      (parked-at ?t ?p) 
      (at-loc ?t ?p)
    )
  )

  (:derived (parked ?v - vehicle) (exists (?p - parkinglot) (parked-at ?v ?p)))

  (:action walk ;; between sub-locations of a location
    :parameters (?l - location ?l1 - location ?l2 - location ?a - agent)
    :precondition (and 
      (agent-at ?a ?l)
      (agent-at ?a ?l1)
      (contain-loc ?l ?l1)
      (contain-loc ?l ?l2)
    )
    :effect (and 
      (agent-at ?a ?l2)
      (not (agent-at ?a ?l1))
    )
  )

  (:action drive
    :parameters (?t - truck ?l1 - location ?l2 - location ?a - agent)
    :precondition (and 
      (at-loc ?t ?l1)
      (adj-loc ?l1 ?l2)
      (agent-at ?a ?t)
    )
    :effect (and 
      (at-loc ?t ?l2) 
      (not (at-loc ?t ?l1))
      ;(not (agent-at ?a ?t))
      ;(agent-at ?a ?l2)
      (increase (total-cost) 10)
    )
  )

  (:action fly
    :parameters (?p - airplane ?a1 - airport ?a2 - airport)
    :precondition (and 
      (at-loc ?p ?a1)
    )
    :effect (and 
      (at-loc ?p ?a2) 
      (not (at-loc ?p ?a1))
      (increase (total-cost) 3)
    )
  )

  (:action bike
    :parameters (?b - bicycle ?l1 - location ?l2 - location)
    :precondition (and 
      (at-loc ?b ?l1) 
      (adj-loc ?l1 ?l2)
    )
    :effect (and 
      (at-loc ?b ?l2) 
      (not (at-loc ?b ?l1))
      (increase (total-cost) 25)
    )
  )

  ( :action store-obj
    :parameters (?m - moveable ?f - furniture ?v - vehicle)
    :precondition( and
      (in-veh ?m ?v)
      (at-loc ?v home)
    )
    :effect( and
      (not (in-veh ?m ?v))
      (in ?f ?m)
      (increase (total-cost) 1)
    )
  )

  ;(:derived (adj-loc ?l1 - location ?l2 - location) (adj-loc-1 ?l1 ?l2) )
  ;(:derived (adj-loc ?l1 - location ?l2 - location) (adj-loc-2 ?l1 ?l2) )
  ;(:derived (adj-loc-2 ?l1 - location ?l2 - location) (adj-loc-1 ?l2 ?l1) )

)
