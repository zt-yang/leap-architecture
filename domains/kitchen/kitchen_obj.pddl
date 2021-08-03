(define (domain Kitchen)
  (:requirements :strips :typing )
  (:types
   staticobject moveable - object
   surface furniture - staticobject
   appliance worktop - surface
   ingredient utensil - moveable
   container normalutensil - utensil
   cookingcontainer normalcontainer - container
   specialcontainer - normalcontainer
   liquidcontainer - normalcontainer
   egg - ingredient
   bacon - ingredient
   lettuce - ingredient)
  (:predicates
   (in ?x - staticobject ?y - moveable)
   (inside ?x - container ?y - moveable)
   (closed ?x - staticobject)
   (opened ?x - staticobject)
   (holding ?x - object)
   (on ?x - appliance)
   (off ?x - appliance)
   (raw ?x - ingredient)
   (cracked ?x - ingredient)
   (omelette ?x - ingredient)
   (beaten ?x - ingredient))
  ( :action close
	    :parameters ( ?param1 - furniture)
	    :precondition( and
			   ( opened ?param1))
	    :effect( and
		     ( not ( opened ?param1 ) )
		     ( closed ?param1)))
  ( :action putaway
	    :parameters ( ?param1 - moveable ?param2 - furniture)
	    :precondition( and
			   ( opened ?param2)
			   ( holding ?param1 ))
	    :effect( and
		     ( not ( holding ?param1 ) )
		     ( in ?param2 ?param1)))
  ( :action pickup
	    :parameters ( ?param1 - moveable ?param2 - surface)
	    :precondition( and
			   ( in ?param2 ?param1))
	    :effect( and
		     ( not ( in ?param2 ?param1 ) )
		     ( holding ?param1)))
  ( :action fry
	    :parameters ( ?param1 - ingredient ?param2 - cookingcontainer ?param3 - appliance)
	    :precondition( and
			   ( inside ?param2 oil)
			   ( inside ?param2 ?param1)
			   ( beaten ?param1)
			   ( in ?param3 ?param2)
			   ( on ?param3))
	    :effect( and
		     ( not ( beaten ?param1 ) )
		     ( omelette ?param1)))
  ( :action transfer
	    :parameters ( ?param1 - ingredient ?param2 - container ?param3 - container)
	    :precondition( and
			   ( holding ?param2)
			   ( inside ?param2 ?param1))
	    :effect( and
		     ( not ( inside ?param2 ?param1 ) )
		     ( inside ?param3 ?param1)))
  ( :action switchon
	    :parameters ( ?param1 - appliance)
	    :precondition( and( off ?param1)
			      ( in ?param1 frypan))
	    :effect( and
		     ( not ( off ?param1 ) )
		     ( on ?param1)))
  ( :action switchoff
	    :parameters ( ?param1 - appliance)
	    :precondition( and
			   ( on ?param1)
			   ( in ?param1 frypan))
	    :effect( and
		     ( not ( on ?param1 ) )
		     ( off ?param1)))
  ( :action putdown
	    :parameters ( ?param1 - moveable ?param2 - surface)
	    :precondition( and( holding ?param1))
	    :effect( and
		     ( not ( holding ?param1 ) )
		     ( in ?param2 ?param1)))
  ( :action open
	    :parameters ( ?param1 - furniture)
	    :precondition( and( closed ?param1))
	    :effect( and
		     ( not ( closed ?param1 ) )
		     ( opened ?param1)))
  ( :action beat
	    :parameters ( ?param1 - ingredient ?param2 - normalutensil ?param3 - specialcontainer)
	    :precondition( and
			   ( cracked ?param1)
			   ( inside ?param3 ?param1)
			   ( holding ?param2))
	    :effect( and
		     ( not ( cracked ?param1 ) )
		     ( beaten ?param1)))
  ( :action crackegg
	    :parameters ( ?param1 - egg ?param2 - specialcontainer)
	    :precondition( and
			   ( raw ?param1)
			   ( holding ?param1)
			   ( in kitchentop ?param2))
	    :effect( and
		     ( not ( raw ?param1 ) )
		     ( not ( holding ?param1 ) )
		     ( inside ?param2 ?param1)
		     ( cracked ?param1)))
  ( :action getout
	    :parameters ( ?param1 - moveable ?param2 - furniture)
	    :precondition( and
			   ( opened ?param2)
			   ( in ?param2 ?param1))
	    :effect( and
		     ( not ( in ?param2 ?param1 ) )
		     ( holding ?param1))))

