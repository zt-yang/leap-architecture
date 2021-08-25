(define (domain logistics)

  (:requirements :adl :action-costs ) ;; :derived-predicates 

  (:types
    physicalobj city location - object
    obj vehicle - physicalobj
    bicycle truck airplane - vehicle
    airport - location
  )

  (:predicates
   (loc-in ?l - location ?c - city)
   (at-loc ?x - physicalobj ?l - location) 
   (in-veh ?p - obj ?v - vehicle) 

   ;; in order for the rule of "if A adj with B, then B adj with A"
   (adj-loc-1 ?l1 - location ?l2 - location)
   (adj-loc-2 ?l1 - location ?l2 - location)
   (adj-loc ?l1 - location ?l2 - location)
  )

  (:action load
    :parameters (?o - obj ?v - vehicle ?l - location)
    :precondition (and 
      (at-loc ?v ?l) 
      (at-loc ?o ?l)
    )
    :effect (and 
      (in-veh ?o ?v) 
      (not (at-loc ?o ?l) )
      (increase (total-cost) 1)
    )
  )

  (:action unload
    :parameters (?o - obj ?v - vehicle ?l - location)
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

  (:action bike
    :parameters (?b - bicycle ?l1 - location ?l2 - location ?c - city)
    :precondition (and 
      (at-loc ?b ?l1) 
      (loc-in ?l1 ?c) 
      (loc-in ?l2 ?c)
      (adj-loc ?l1 ?l2)
    )
    :effect (and 
      (at-loc ?b ?l2) 
      (not (at-loc ?b ?l1))
      (increase (total-cost) 25)
    )
  )

  (:action drive
    :parameters (?t - truck ?l1 - location ?l2 - location ?c - city)
    :precondition (and 
      (at-loc ?t ?l1)
      (loc-in ?l1 ?c) 
      (loc-in ?l2 ?c)
      (adj-loc ?l1 ?l2)
    )
    :effect (and 
      (at-loc ?t ?l2) 
      (not (at-loc ?t ?l1))
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

  ;(:derived (adj-loc ?l1 - location ?l2 - location) (adj-loc-1 ?l1 ?l2) )
  ;(:derived (adj-loc ?l1 - location ?l2 - location) (adj-loc-2 ?l1 ?l2) )
  ;(:derived (adj-loc-2 ?l1 - location ?l2 - location) (adj-loc-1 ?l2 ?l1) )
)
