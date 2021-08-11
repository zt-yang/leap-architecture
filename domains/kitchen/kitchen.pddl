(define (domain Kitchen)
  ; (:requirements :strips :typing )
  (:requirements :adl :derived-predicates :action-costs )

  (:types

  	staticobject moveable agent number measureunit - object

  	surface furniture - staticobject
  	appliance worktop - surface

  	ingredient utensil - moveable
  	egg seasoning liquid - ingredient
  	oil - liquid
  	container normalutensil cookingutensil whiskutensil measureutensil - utensil
  	cookingcontainer normalcontainer - container
  	specialcontainer liquidcontainer - normalcontainer

  	robot - agent
  )

  (:predicates

		( impossible ?x - object ) ; for disabling an operator

  	; ----------------------
  	; object categories
  	; ----------------------
  	(is-egg ?x - ingredient)
  	(is-butter ?x - ingredient)
  	(is-cookingcontainer ?x - utensil)
  	(burned-utensil ?x - utensil ?y - appliance)
  	(burned-appliance ?y - appliance)

  	; ----------------------
  	; spatial relations
  	; ----------------------
  	(in ?x - furniture ?y - moveable) 		; x cannot move
  	(on ?x - surface ?y - moveable) 			; x cannot move
  	(inside ?x - container ?y - moveable) ; x can move
  	;(oningredient ?x - ingredient ?y - ingredient)

  	; ----------------------
  	; properties
  	; ----------------------
  	(closed ?x - staticobject)
  	(opened ?x - staticobject)
  	(switchedon ?x - appliance)
  	(switchedoff ?x - appliance)

  	; ----------------------
  	; agent state
  	; ----------------------
  	(holding ?x - object ?y - agent)
  	(handsfull ?x - agent)

  	; ----------------------
  	; ingredient state
  	; ----------------------

  	(cracked ?x - ingredient)
  	(beaten ?x - ingredient)
  	(firm ?x - ingredient)
  	(folded ?x - ingredient)

  	(raw ?x - ingredient)
  	(omelette ?x - ingredient)
  	(fried ?x - ingredient)
  	(cooked ?x - ingredient)
  	(burned ?x - ingredient)

  	(sauteed ?x - ingredient)
  	(chopped ?x - ingredient)
  	(is-buttery ?x - ingredient)

  	(on-ingredient ?x - ingredient ?y - seasoning)
  	(seasoning-mixed ?x - ingredient ?y - seasoning)

  	(has-seasoning ?i - ingredient ?s - seasoning ?u - measureutensil ?n - number)
  )

  ; ----------------------------------------
  ; deal with containers
  ; ----------------------------------------

  ( :action open
	    :parameters ( ?param1 - furniture )
	    :precondition( and
	    	 ( closed ?param1 ) 
	    )
	    :effect( and
		     ( not ( closed ?param1 ) )
		     ( opened ?param1 )
		  )
	)

  ( :action close  ; may close with hand full
	    :parameters ( ?param1 - furniture )
	    :precondition( and
			   ( opened ?param1 )
			)
	    :effect( and
		     ( not ( opened ?param1 ) )
		     ( closed ?param1 )
		  )
	)


  ; ----------------------------------------
  ; deal with appliances
  ; ----------------------------------------

  ( :action switchon
	    :parameters ( ?a - appliance ?c - cookingcontainer )
	    :precondition( and
	    		( switchedoff ?a )
			    ( on ?a ?c )
			)
	    :effect( and
		     ( not ( switchedoff ?a ) )
		     ( switchedon ?a )
		     ( forall (?u - utensil)
			     	( when ( and ( not ( = ?c ?u ) )  ( on ?a ?u ) )
			     				( burned-utensil ?u ?a )
			     	)
		     )
		  )
	)

  ( :action switchoff
	    :parameters ( ?a - appliance ?c - cookingcontainer )
	    :precondition( and
			   ( switchedon ?a )
			   ( on ?a ?c )
			)
	    :effect( and 
		     ( not ( switchedon ?a ) )
		     ( switchedoff ?a )
		  )
	)

  ; ----------------------------------------
  ; deal with movables
  ; ----------------------------------------

  ( :action pickup
	    :parameters ( ?param1 - moveable ?param2 - surface ?param3 - agent )
	    :precondition( and
			   ( on ?param2 ?param1 ) 
		     ( not ( handsfull ?param3 ) )
			)
	    :effect( and
		     ( not ( on ?param2 ?param1 ) )
		     ( holding ?param1 ?param3 )
		     ( handsfull ?param3 )
		  )
	)

  ( :action putdown
	    :parameters ( ?param1 - moveable ?param2 - surface ?param3 - agent )
	    :precondition( and
	    	 ( holding ?param1 ?param3 )
	    	 ( handsfull ?param3 )
	   	)
	    :effect( and
		     ( not ( holding ?param1 ?param3 ) )
		     ( not ( handsfull ?param3 ) )
		     ( on ?param2 ?param1 )
		     ( forall (?a - appliance)
			     	( when ( and 
			     						( = ?param2 ?a ) 
			     						( not ( is-cookingcontainer ?param1 ) )  
			     						( switchedon ?a ) 
			     					)
			     			( burned-utensil ?param1 ?a )
			     	)
		     )
		  )
	)
		     
  ( :action getout
	    :parameters ( ?param1 - moveable ?param2 - furniture ?param3 - agent )
	    :precondition( and
			   ( opened ?param2 )
			   ( in ?param2 ?param1 )
			)
	    :effect( and
		     ( not ( in ?param2 ?param1 ) )
		     ( holding ?param1 ?param3 ) 
		     ( handsfull ?param3 )
		  )
	)

  ( :action putaway
	    :parameters ( ?param1 - moveable ?param2 - furniture ?param3 - agent )
	    :precondition( and
			   ( opened ?param2 )
			   ( holding ?param1 ?param3 )
			   ( handsfull ?param3 )
			)
	    :effect( and
		     ( not ( holding ?param1 ?param3 ) )
		     ( not ( handsfull ?param3 ) )
		     ( in ?param2 ?param1 )
		  )
	)

  ( :action transfer
	    :parameters ( ?param1 - ingredient ?param2 - container ?param3 - container ?param4 - agent)
	    :precondition( and
			   ( holding ?param2 ?param4 )
			   ( inside ?param2 ?param1 )
			)
	    :effect( and
		     ( not ( inside ?param2 ?param1 ) )
		     ( inside ?param3 ?param1 )
		  )
	)

	( :action season 
	    :parameters ( ?i - ingredient ?s - ingredient ?c - container ?u - measureutensil ?r - agent)
	    :precondition( and
			   ( inside ?c ?s )
			   ( holding ?u ?r )
			)
	    :effect( and
	    		( on-ingredient ?i ?s ) 
	    		( has-seasoning ?i ?s ?u one )
		      ( when ( has-seasoning ?i ?s ?u one ) ( has-seasoning ?i ?s ?u two ) )
		     	( when ( has-seasoning ?i ?s ?u two ) ( has-seasoning ?i ?s ?u three ) )
		     	( when ( has-seasoning ?i ?s ?u three ) ( has-seasoning ?i ?s ?u four ) )
		     	( when ( has-seasoning ?i ?s ?u four ) ( has-seasoning ?i ?s ?u five ) )
		     	( when ( has-seasoning ?i ?s ?u five ) ( has-seasoning ?i ?s ?u six ) )
		  )
	)

	( :action sprinkle 
	    :parameters ( ?i - ingredient ?s - seasoning ?c - container ?u - measureunit ?r - agent)
	    :precondition( and
			   ( inside ?c ?s )
			   ( holding ?c ?r )
			)
	    :effect( and
	    		( on-ingredient ?i ?s ) 
	    		( has-seasoning ?i ?s ?u one )
	    		( when ( has-seasoning ?i ?s ?u one ) ( has-seasoning ?i ?s ?u two ) )
		     	( when ( has-seasoning ?i ?s ?u two ) ( has-seasoning ?i ?s ?u three ) )
		     	( when ( has-seasoning ?i ?s ?u three ) ( has-seasoning ?i ?s ?u four ) )
		     	( when ( has-seasoning ?i ?s ?u four ) ( has-seasoning ?i ?s ?u five ) )
		     	( when ( has-seasoning ?i ?s ?u five ) ( has-seasoning ?i ?s ?u six ) )
		  )
	)

	( :action pour 
	    :parameters ( ?to - container ?l - liquid ?from - container ?u - measureunit ?r - agent)
	    :precondition( and
			   ( inside ?from ?l )
			   ( holding ?from ?r )
			)
	    :effect( and
    		( forall ( ?i - ingredient ) 
	     		( when (inside ?to ?i)
	     			( and 
	     				( on-ingredient ?i ?l ) 
	     				( has-seasoning ?i ?l ?u one )
	     				( when ( has-seasoning ?i ?l ?u one ) ( has-seasoning ?i ?l ?u two ) )
	     				( when ( has-seasoning ?i ?l ?u two ) ( has-seasoning ?i ?l ?u three ) )
			     		( when ( has-seasoning ?i ?l ?u three ) ( has-seasoning ?i ?l ?u four ) )
			     		( when ( has-seasoning ?i ?l ?u four ) ( has-seasoning ?i ?l ?u five ) )
			     		( when ( has-seasoning ?i ?l ?u five ) ( has-seasoning ?i ?l ?u six ) )
	     			)
	     		) 
	     	)
		  )
	)

  ; ----------------------------------------
  ; cooking operators
  ; ----------------------------------------

  ;( :action fry
	;    :parameters ( ?param1 - ingredient ?param2 - cookingcontainer ?param3 - appliance ?o - oil )
	;    :precondition( and
	;		   ( inside ?param2 ?o )
	;		   ( inside ?param2 ?param1 )
	;		   ( beaten ?param1 )
	;		   ( on ?param3 ?param2 )
	;		   ( switchedon ?param3 )
	;		)
	;    :effect( and
	;	     ( not ( beaten ?param1 ) )
	;	     ( omelette ?param1 ) 
	;	  )
	;)

	( :action fry
	    :parameters ( ?i - ingredient ?p - cookingcontainer ?a - appliance ?o - oil)
	    :precondition( and
			   ( inside ?p ?o )
			   ( inside ?p ?i )
			   ( on ?a ?p )
			   ( switchedon ?a )
			)
	    :effect( and
		     ( fried ?i ) 
		     ( when (is-butter ?o) (is-buttery ?i))
		  )
	)

	( :action fold
	    :parameters ( ?i - ingredient ?p - cookingcontainer ?u - cookingutensil ?r - agent)
	    :precondition( and
			   ( firm ?i )
			   ( inside ?p ?i )
			   ( holding ?u ?r )
			)
	    :effect( and
		     ( folded ?i ) 
		  )
	)

  ( :action mix  
	    :parameters ( ?param1 - ingredient ?param2 - normalutensil ?param3 - specialcontainer ?param4 - agent ) ; (either whiskutensil normalutensil)
	    :precondition( and
			   ( not (cooked ?param1 ) ) ; for no beaten in fry
			   ( inside ?param3 ?param1 )
			   ( holding ?param2 ?param4 )
			)
	    :effect( and
		     ( when 
		     			( and ( is-egg ?param1 ) ( cracked ?param1 ) ) 
		     			( beaten ?param1 ) 
		     	)  ; for eggs 
		     ( beaten ?param1 ) 
		     ( forall ( ?s - seasoning ) 
		     		(when (on-ingredient ?param1 ?s) 
		     					(seasoning-mixed ?param1 ?s)
		     		) 
		     )
		  )
	)

  ( :action beat  ; special case of mixing
	    :parameters ( ?param1 - ingredient ?param2 - normalutensil ?param3 - specialcontainer ?param4 - agent )
	    :precondition( and
			   ( impossible ?param1 )
			   ( cracked ?param1 )
			   ( not (cooked ?param1 ) ) ; for no beaten in fry
			   ( inside ?param3 ?param1 )
			   ( holding ?param2 ?param4 )
			)
	   :effect( and
		     ( not ( cracked ?param1 ) )
		     ( beaten ?param1 ) 
		  )
	)

  ( :action add-ingredient
	    :parameters ( ?param1 - ingredient ?param2 - specialcontainer ?param3 - agent )
	    :precondition( and
			   ( holding ?param1 ?param3 )
			   ( on kitchentop ?param2 )
			   ( not ( is-egg ?param1 ) )
			)
	    :effect( and
		     ( not ( holding ?param1 ?param3 ) )
		     ( inside ?param2 ?param1 )

		     ;( when (and 
		     ;				( is-egg ?param1 )
		     ;				( raw ?param1 )
		     ;			)
		     ;			( cracked ?param1 )
		     ;)
		  )
	)

  ( :action crack-egg   ; a special case of adding ingredients
	    :parameters ( ?param1 - egg ?param2 - specialcontainer ?param3 - agent )
	    :precondition( and
			   ( raw ?param1 )
			   ( holding ?param1 ?param3 )
			   ( on kitchentop ?param2 )
			)
	   :effect( and
		     ( not ( raw ?param1 ) )
		     ( not ( holding ?param1 ?param3 ) )
		     ( inside ?param2 ?param1 )
		     ( cracked ?param1 )
		  )
	)

	( :derived (is-egg ?i ) (forall (?i - egg) (raw ?i ) ) )

	( :derived (cooked ?i - ingredient) (fried ?i) )

	( :derived (firm ?i - egg) (cooked ?i) )

	( :derived (burned ?i)
		(exists 
			( ?i - ingredient ?c - cookingcontainer ?a - appliance ?o - oil) 
		  ( and 
		 		( switchedon ?a )
		 		( on ?a ?c )
		 		( inside ?c ?i )
		 		( not ( inside ?c ?o ) )
			) 
		)
	)

	( :derived (burned-appliance ?a)
		(exists 
			( ?u - normalutensil ) 
		  ( burned-utensil ?u ?a )
		)
	)

)