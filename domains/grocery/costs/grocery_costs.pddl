(define (domain grocery)

  (:requirements :adl :derived-predicates :action-costs )

  (:types
    physicalobj location agent item cost - object
    moveable vehicle - physicalobj

    bicycle car airplane - vehicle
    airport parkinglot building area - location
    store - building
    payment-item - item
    credit-card - payment-item

    ;; to merge with kitchen_extended
    ingredient utensil - moveable
    egg lambchop bread - ingredient
    staticobject - object
    furniture - staticobject

    utensil - moveable
    container - utensil
    cookingcontainer - container
    pot - cookingcontainer
  )

  (:predicates
    (at-loc ?x - physicalobj ?l - location) 
    (in-veh ?p - moveable ?v - vehicle) 

    ;; in order for the rule of "if A adj with B, then B adj with A"
    (adj-loc-1 ?l1 - location ?l2 - location)
    (adj-loc-2 ?l1 - location ?l2 - location)
    (adj-loc ?l1 - location ?l2 - location)
    (adj-area-1 ?a1 - area ?a2 - area)
    (adj-area-2 ?a1 - area ?a2 - area)
    (adj-area ?a1 - area ?a2 - area)
    (contain-loc ?l1 - location ?l2 - location)

    (parked ?v - vehicle)
    (parked-at ?v - vehicle ?l - location)
    (has-parked ?a - agent)

    (agent-at ?a - agent ?l - object)
    (agent-owns ?a - agent ?i - object)
    (agent-has ?a - agent ?i - object)

    (paid ?i - moveable)
    (shopping-at ?a - agent ?l - store)
    (is-store ?l - store)
    (store-cost ?l - store ?n - cost)

    ;; to merge with kitchen_extended
    (in ?x - furniture ?y - moveable)
  )

  (:action pay-grocery-10
    :parameters (?o - moveable ?l - store ?p - payment-item ?a - agent)
    :precondition (and 
      (agent-has ?a ?p)
      (at-loc ?o ?l)
      (shopping-at ?a ?l)
      (store-cost ?l 10)
    )
    :effect (and 
      (paid ?o)
      (agent-has ?a ?o)
      (agent-owns ?a ?o)
      (not (at-loc ?o ?l))
      (increase (total-cost) 10)
    )
  )

  (:action pay-grocery-20
    :parameters (?o - moveable ?l - store ?p - payment-item ?a - agent)
    :precondition (and 
      (agent-has ?a ?p)
      (at-loc ?o ?l)
      (shopping-at ?a ?l)
      (store-cost ?l 20)
    )
    :effect (and 
      (paid ?o)
      (agent-has ?a ?o)
      (agent-owns ?a ?o)
      (not (at-loc ?o ?l))
      (increase (total-cost) 20)
    )
  )

  (:action pay-grocery-30
    :parameters (?o - moveable ?l - store ?p - payment-item ?a - agent)
    :precondition (and 
      (agent-has ?a ?p)
      (at-loc ?o ?l)
      (shopping-at ?a ?l)
      (store-cost ?l 30)
    )
    :effect (and 
      (paid ?o)
      (agent-has ?a ?o)
      (agent-owns ?a ?o)
      (not (at-loc ?o ?l))
      (increase (total-cost) 30)
    )
  )

  (:action enter-building
    :parameters (?b - building ?l - location ?a - agent)
    :precondition (and 
      (agent-at ?a ?l)
      (contain-loc ?l ?b)
      (has-parked ?a)
    )
    :effect (and 
      (agent-at ?a ?b)
      (not (agent-at ?a ?l))
      (increase (total-cost) 1)
    )
  )

  (:action exit-building
    :parameters (?b - building ?l - location ?a - agent)
    :precondition (and 
      (agent-at ?a ?b)
      (contain-loc ?l ?b)
    )
    :effect (and 
      (agent-at ?a ?l)
      (not (agent-at ?a ?b))
      (increase (total-cost) 1)
    )
  )

  (:action load
    :parameters (?o - moveable ?v - vehicle ?l - location)
    :precondition (and 
      (at-loc ?v ?l) 
      (at-loc ?o ?l)
      (not (is-store ?l))
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

  (:action park-vehicle  
    :parameters (?t - vehicle ?p - parkinglot ?l - location ?a - agent)
    :precondition (and 
      (agent-at ?a ?t)
      (at-loc ?t ?l)
      (contain-loc ?l ?p)
    )
    :effect (and 
      (not (agent-at ?a ?t))
      (not (at-loc ?t ?l))
      (parked-at ?t ?p) 
      (agent-at ?a ?p)
      (increase (total-cost) 5)
    )
  )

  (:action unpark-vehicle  
    :parameters (?t - vehicle ?p - parkinglot ?l - location ?a - agent)
    :precondition (and 
      (agent-at ?a ?p)
      (parked-at ?t ?p)
      (contain-loc ?l ?p)
    )
    :effect (and 
      (not (agent-at ?a ?p))
      (not (at-loc ?t ?p))
      (not (parked-at ?t ?p)) 
      (at-loc ?t ?l)
      (agent-at ?a ?t)
      (increase (total-cost) 1)
    )
  )

  (:action walk-btw-area
    :parameters (?l1 - area ?l2 - area ?a - agent)
    :precondition (and 
      (agent-at ?a ?l1)
      (adj-area ?l1 ?l2)
    )
    :effect (and 
      (agent-at ?a ?l2)
      (not (agent-at ?a ?l1))
      (increase (total-cost) 40)
    )
  )

  (:action walk-btw-loc
    :parameters (?l1 - location ?l2 - location ?a - agent)
    :precondition (and 
      (agent-at ?a ?l1)
      (adj-loc ?l1 ?l2)
    )
    :effect (and 
      (agent-at ?a ?l2)
      (not (agent-at ?a ?l1))
      (increase (total-cost) 10)
    )
  )

  (:action walk-within-area
    :parameters (?l - area ?l1 - location ?l2 - location ?a - agent)
    :precondition (and 
      (agent-at ?a ?l1)
      (adj-loc ?l ?l1)
      (adj-loc ?l ?l2)
    )
    :effect (and 
      (agent-at ?a ?l2)
      (not (agent-at ?a ?l1))
      (increase (total-cost) 20)
    )
  )

  (:action walk-within-loc  ;; between building to parking of a location
    :parameters (?l - location ?l1 - location ?l2 - location ?a - agent)
    :precondition (and 
      (agent-at ?a ?l1)
      (contain-loc ?l ?l1)
      (contain-loc ?l ?l2)
    )
    :effect (and 
      (agent-at ?a ?l2)
      (not (agent-at ?a ?l1))
      (increase (total-cost) 5)
    )
  )

  (:action drive-btw-area
    :parameters (?t - car ?l1 - area ?l2 - area ?a - agent)
    :precondition (and 
      (at-loc ?t ?l1)
      (adj-area ?l1 ?l2)
      (agent-at ?a ?t)
      (agent-owns ?a ?t)
    )
    :effect (and 
      (at-loc ?t ?l2) 
      (not (at-loc ?t ?l1))
      (increase (total-cost) 4)
    )
  )

  (:action drive-within-area
    :parameters (?t - car ?l - area ?l1 - location ?l2 - location ?a - agent)
    :precondition (and 
      (at-loc ?t ?l1)
      (adj-loc ?l ?l1)
      (adj-loc ?l ?l2)
      (agent-at ?a ?t)
      (agent-owns ?a ?t)
    )
    :effect (and 
      (at-loc ?t ?l2) 
      (not (at-loc ?t ?l1))
      (increase (total-cost) 4)
    )
  )

  (:action drive-btw-loc
    :parameters (?t - car ?l1 - location ?l2 - location ?a - agent)
    :precondition (and 
      (at-loc ?t ?l1)
      (adj-loc ?l1 ?l2)
      (agent-at ?a ?t)
      (agent-owns ?a ?t)
    )
    :effect (and 
      (at-loc ?t ?l2) 
      (not (at-loc ?t ?l1))
      (increase (total-cost) 2)
    )
  )

  (:action store-obj
    :parameters (?m - moveable ?f - furniture ?a - agent)
    :precondition( and
      (agent-has ?a ?m)
      (agent-at ?a home)
    )
    :effect( and
      (not (agent-has ?a ?m))
      (in ?f ?m)
      (increase (total-cost) 1)
    )
  )

  ; ----------------------------------------
  ; axioms (when cannot exist in forall in axioms)
  ; ----------------------------------------
  (:derived (has-parked ?a - agent)
    (forall (?c - car) (parked ?c))
  )
  (:derived (parked ?v - vehicle) (exists (?p - parkinglot) (parked-at ?v ?p)))

  (:derived (shopping-at ?a - agent ?b - store) (agent-at ?a ?b))

  (:derived (adj-loc ?l1 - location ?l2 - location) (adj-loc-1 ?l1 ?l2) )
  (:derived (adj-loc ?l1 - location ?l2 - location) (adj-loc-2 ?l1 ?l2) )
  (:derived (adj-loc-2 ?l1 - location ?l2 - location) (adj-loc-1 ?l2 ?l1) )

  (:derived (adj-area ?l1 - area ?l2 - area) (adj-area-1 ?l1 ?l2) )
  (:derived (adj-area ?l1 - area ?l2 - area) (adj-area-2 ?l1 ?l2) )
  (:derived (adj-area-2 ?l1 - area ?l2 - area) (adj-area-1 ?l2 ?l1) )
)
