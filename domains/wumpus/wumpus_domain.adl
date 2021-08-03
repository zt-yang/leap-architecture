(define (domain wumpus-adl)
  (:requirements :adl :typing)

  ;; object types
  (:types agent wumpus gold arrow square)

  (:predicates
   (adj ?square-1 ?square-2 - square)
   (pit ?square - square)
   (at ?what ?square)
   (have ?who ?what)
   (alive ?who))

  (:action move
    :parameters (?who - agent ?from - square ?to - square)
    :precondition (and (alive ?who)
		       (at ?who ?from)
		       (adj ?from ?to)
                        )
    :effect (and (not (at ?who ?from))
		 (at ?who ?to)

		 (when (pit ?to)
		   (and (not (alive ?who))))

		 (when (exists (?w - wumpus) (and (at ?w ?to) (alive ?w)))
		   (and (not (alive ?who)))))
    )

  (:action take
    :parameters (?who - agent ?where - square ?what)
    :precondition (and (alive ?who)
		       (at ?who ?where)
		       (at ?what ?where))
    :effect (and (have ?who ?what)
		 (not (at ?what ?where)))
    )

  (:action shoot
    :parameters (?who - agent ?where - square ?with-arrow - arrow
		 ?victim - wumpus ?where-victim - square)
    :precondition (and (alive ?who)
		       (have ?who ?with-arrow)
		       (at ?who ?where)
		       (alive ?victim)
		       (at ?victim ?where-victim)
		       (adj ?where ?where-victim))
    :effect (and (not (alive ?victim))
		 (not (have ?who ?with-arrow)))
    )
)