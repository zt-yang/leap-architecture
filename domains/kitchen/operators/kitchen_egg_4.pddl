(define (domain Kitchen)

  (:requirements :adl :derived-predicates :action-costs )

  (:types

    staticobject moveable agent env abstract - object
    number measureunit shape level part - abstract

    surface furniture - staticobject
    appliance worktop - surface

    ingredient utensil - moveable
    egg seasoning liquid bread - ingredient
    oil vinegar - liquid
    container normalutensil cookingutensil whiskutensil measureutensil cuttingutensil specializeduensil - utensil
    spoon - normalutensil

    cookingcontainer normalcontainer liquidtap - container
    pan pot - cookingcontainer
    specialcontainer liquidcontainer cuisinecontainer - normalcontainer
    containercover - specializeduensil
    plate - cuisinecontainer

    robot - agent
    circle - shape
    hardnesslevel - level
  ) 

  (:predicates

    ( impossible ?x - object ) ; for disabling an operator

    ; ----------------------
    ; object categories
    ; ----------------------
    (is-egg ?x - ingredient)
    (is-butter ?x - ingredient)
    (is-cookingcontainer ?x - utensil)
    (has-shape ?x - utensil ?y - shape)

    ; ----------------------
    ; spatial relations
    ; ----------------------
    (in ?x - furniture ?y - moveable)       ; x cannot move
    (on ?x - surface ?y - moveable)         ; x cannot move
    (inside ?x - container ?y - moveable)   ; x can move
    (in-hole ?x - ingredient ?y - ingredient)  

    ; ----------------------
    ; properties
    ; ----------------------
    (closed ?x - staticobject)
    (opened ?x - staticobject)
    (turnedon ?x - liquidtap)
    (turnedoff ?x - liquidtap)
    (switchedon ?x - appliance)
    (switchedoff ?x - appliance)
    (covered ?x - container)

    (matching-size ?x - utensil ?y - utensil)

    (burned-ingredient ?x - utensil)
    (burned-utensil ?x - utensil ?y - appliance)
    (burned-appliance ?y - appliance)

    (burned-kitchen ?x - env)
    (burned-food ?x - env)
    (safe-kitchen ?x - env)
    (organized ?x - env)

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
    (scrambled ?x - ingredient)

    (raw ?x - ingredient)
    (omelette ?x - ingredient)
    (fried ?x - ingredient)
    (steamed ?x - ingredient)
    (cooked ?x - ingredient)
    (burned ?x - ingredient)

    (sauteed ?x - ingredient)
    (chopped ?x - ingredient)
    (is-buttery ?x - ingredient)

    (on-ingredient ?x - ingredient ?y - seasoning)
    (seasoning-mixed ?x - ingredient ?y - seasoning)
    (has-seasoning ?i - ingredient ?s - seasoning ?u - measureutensil ?n - number)

    (has-hole ?x - ingredient ?y - shape)
    (has-space ?x - specialcontainer)
    (can-hold ?x - (either specialcontainer ingredient) )

    ; ----------------------
    ; recipe state
    ; ----------------------

    (exist-scrambled-eggs ?x - env)
    (exist-omelette ?x - env)
    (exist-sunny-side-up ?x - env)
    (exist-egg-in-hole ?x - env)

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

  ( :action puton
      :parameters ( ?param1 - moveable ?param2 - moveable ?param3 - agent )
      :precondition( and
         ( holding ?param1 ?param3 )
         ( handsfull ?param3 )
      )
      :effect( and
         ( not ( holding ?param1 ?param3 ) )
         ( not ( handsfull ?param3 ) )
         ( on ?param2 ?param1 )
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
         ;              ( is-egg ?param1 )
         ;              ( raw ?param1 )
         ;          )
         ;          ( cracked ?param1 )
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
  ; don't delete this line: for substituting crack-egg effects

  ( :action make-hole  
      :parameters ( ?b - bread ?c - cuttingutensil ?s - shape ?a - agent )
      :precondition( and
          ( has-shape ?c ?s )
          ( holding ?c ?a )
          ( on kitchentop ?b )
          ( not ( has-hole ?b ?s ) )
      )
      :effect( and
          ( has-hole ?b ?s )
          ( increase ( total-cost ) 1 )
      )
  )

  ; ----------------------------------------
  ; cooking operators
  ; ----------------------------------------

  ( :action fry
      :parameters ( ?i - ingredient ?p - cookingcontainer ?a - appliance ?o - oil)
      :precondition( and
         ( inside ?p ?o )
         ( inside ?p ?i )
         ( on ?a ?p )
         ( switchedon ?a )
         ( not ( steamed ?i ) )
         ( not ( covered ?p ) )
      )
      :effect( and
         ( fried ?i ) 
         ( when ( is-butter ?o ) ( is-buttery ?i ))
         ( when ( steamed ?i ) ( not ( is-buttery ?i ) ))
      )
  )

  ( :action steam
      :parameters ( ?i - ingredient ?p - cookingcontainer ?a - appliance)
      :precondition( and
         ( inside ?p ?i )
         ( on ?a ?p )
         ( covered ?p )
         ( switchedon ?a )
      )
      :effect( and
         ( steamed ?i )
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

  ( :action scrape
      :parameters ( ?i - ingredient ?p - cookingcontainer ?u - cookingutensil ?r - agent)
      :precondition( and
         ( firm ?i )
         ( inside ?p ?i )
         ( holding ?u ?r )
      )
      :effect( and
         ( scrambled ?i ) 
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
         ( when  ( and ( is-egg ?param1 ) ( cracked ?param1 ) ) 
              ( beaten ?param1 ) 
          )  ; for eggs 
          ( beaten ?param1 ) 
          ( forall ( ?s - seasoning ) 
              ( when (on-ingredient ?param1 ?s) 
                      (seasoning-mixed ?param1 ?s)
              ) 
          )
          ( increase (total-cost) 10 )
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

  ; ----------------------------------------
  ; -------- ingredients transition model
  ; ----------------------------------------

  ( :derived (is-egg ?i ) (forall (?i - egg) (raw ?i ) ) )

  ( :derived (cooked ?i - ingredient) (fried ?i) )

  ( :derived (firm ?i - egg) (cooked ?i) )

  ; ----------------------------------------
  ; -------- utensils transition model
  ; ----------------------------------------

  ;( :derived (matching-size ?x ?y) ( matching-size ?y ?x ) )

  ( :derived ( covered ?con )
      (exists 
          ( ?cov - containercover ) 
          ( and 
              ( matching-size ?cov ?con )
            ( on ?con ?cov )
          )
      )
  )

  ( :derived ( can-hold ?c - container ) 
    ( exists ( ?s - surface ) ( on ?s ?c ) )
  )

  ( :derived ( can-hold ?i - ingredient )
    ( exists ( ?s - shape ) ( has-hole ?i ?s ) )
  )

  ; ----------------------------------------
  ; -------- ingredients burned because of inproper cooking
  ; ----------------------------------------
  
  ( :derived (burned-ingredient ?i - ingredient)
      ( exists 
          ( ?c - cookingcontainer ?a - appliance ?o - oil) 
        ( and 
              ( switchedon ?a )
              ( on ?a ?c )
              ( inside ?c ?i )
              ( not ( inside ?c ?o ) )
          ) 
      )
  )

  ( :derived (burned-food ?e - env)
      ( exists 
          ( ?i - ingredient ) 
        ( burned-appliance ?a )
      )
  )

  ; ----------------------------------------
  ; -------- utensils and appliances burned because of heating wrong objects
  ; ----------------------------------------

  ( :derived ( burned-appliance ?a - appliance )
      ( exists 
          ( ?u - normalutensil ) 
        ( burned-utensil ?u ?a )
      )
  )

  ( :derived ( burned-kitchen ?e - env )
      ( exists 
          ( ?a - appliance ) 
        ( burned-appliance ?a )
      )
  )

  ; ----------------------------------------
  ; -------- maintainance goals
  ; ----------------------------------------

  ( :derived ( safe-kitchen ?e - env )
      ( and
          ( not ( burned-kitchen ?e ) ) 
        ( not ( burned-food ?e ) ) 
      )
  )

  ( :derived ( organized ?env )
      ( and 
          ( forall ( ?f - furniture ) ( closed ?f ) )
          ( forall ( ?a - appliance ) ( switchedoff ?a ) )
          ( safe-kitchen ?env )
      )
  )

  ; ----------------------------------------
  ; -------- recipes
  ; ----------------------------------------

  ( :derived ( exist-scrambled-eggs ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate )
      ( and 
        ( inside ?plate1 ?egg1 )
        ( beaten ?egg1 )
        ( fried ?egg1 )
        ( scrambled ?egg1 )
        ( is-buttery ?egg1 )

        ( has-seasoning ?egg1 nutmilk cup two )

        ( has-seasoning ?egg1 chives tablespoon2 one )
        ( seasoning-mixed ?egg1 chives )

        ( has-seasoning ?egg1 salt gram one )
        ( seasoning-mixed ?egg1 salt )

        ( has-seasoning ?egg1 pepper gram one )
        ( seasoning-mixed ?egg1 pepper )
      )
    )
  )

  ( :derived ( exist-omelette ?env - env )
    ( exists 
      ( ?egg1 - egg ?veggies1 - ingredient ?plate1 - plate ?p - normalcontainer )
      ( and 
        ( inside ?plate1 ?egg1 )
        ( beaten ?egg1 )
        ( fried ?egg1 )
        ( folded ?egg1 )
        ( is-buttery ?egg1 )

        ( fried ?veggies1 )
        ( sauteed ?veggies1 )

        ( has-seasoning ?egg1 nutmilk cup two )

        ( has-seasoning ?egg1 chives tablespoon2 two )
        ( seasoning-mixed ?egg1 chives )

        ( has-seasoning ?egg1 salt gram two )
        ( seasoning-mixed ?egg1 salt )

        ( has-seasoning ?egg1 pepper gram two )
        ( seasoning-mixed ?egg1 pepper )
      )
    )
  )

  ( :derived ( exist-sunny-side-up ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate )
      ( and 
        ( inside ?plate1 ?egg1 )
        ( fried ?egg1 )
        ;( is-buttery ?egg1 )  ; SHOW: weirdly cannot use butter here
        ( steamed ?egg1 ) 
        ( has-seasoning ?egg1 salt gram one )
        ( has-seasoning ?egg1 pepper gram one )
      )
    )
  )

  ( :derived ( exist-egg-in-hole ?env - env )
    ( exists 
      ( ?egg1 - egg ?bread1 - bread ?plate1 - plate )
      ( and 
        ( inside ?plate1 ?bread1 )
        ( has-hole ?bread1 circle )
        ( in-hole ?egg1 ?bread1 ) 
        ( fried ?bread1 )
        ; ( fried ?egg1 ) ; cannot achieve this because egg1 not in frypan but in the hole of bread which is on frypan
        ( is-buttery ?bread1 ) 
        ( has-seasoning ?egg1 salt gram one )
        ( has-seasoning ?egg1 pepper gram one )
      )
    )
  )
)