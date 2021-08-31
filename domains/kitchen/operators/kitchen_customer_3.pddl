(define (domain Kitchen)

  (:requirements :adl :derived-predicates :action-costs )

  (:types

    staticobject moveable agent humans env abstract - object
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

    customer - humans
    robot - agent
    circle - shape
    hardnesslevel - level
  ) 

  (:predicates

    (impossible ?x - object) ; for disabling an operator

    ; ----------------------
    ; object categories
    ; ----------------------
    (is-egg ?x - ingredient)
    (is-liquid ?x - ingredient)
    (is-butter ?x - ingredient)
    (is-cookingcontainer ?x - utensil)
    (is-slotted ?x - slottedspoon)
    (has-shape ?x - utensil ?y - shape)
    (has-vinegar ?l - liquid)

    ; ----------------------
    ; spatial relations
    ; ----------------------
    (in ?x - furniture ?y - moveable)       ; x cannot move
    (on ?x - object ?y - moveable)         ; x cannot move
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
    (default-level ?x - appliance ?y - level)
    (at-level ?x - appliance ?y - level)

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
    (stirred ?x - liquid)

    (raw ?x - ingredient)
    (needs-peeling ?x - ingredient)
    (fried ?x - ingredient)
    (steamed ?x - ingredient)
    (cooked ?x - ingredient)
    (burned ?x - ingredient)
    (boiled ?x - ingredient)

    (sauteed ?x - ingredient)
    (chopped ?x - ingredient)
    (is-buttery ?x - ingredient)

    (seasoned-on ?x - ingredient ?y - ingredient)
    (seasoning-mixed ?x - ingredient ?y - ingredient)
    (has-seasoning ?i - ingredient ?s - ingredient ?u - object ?n - number)

    (has-hole ?x - ingredient ?y - shape)
    (has-space ?x - specialcontainer)
    (can-hold ?x - (either specialcontainer ingredient) )
    (hardness ?x - ingredient ?p - part ?l - hardnesslevel)

    ; ----------------------
    ; recipe state
    ; ----------------------

    (exist-scrambled-eggs ?x - env)
    (exist-omelette ?x - env)
    (exist-sunny-side-up ?x - env)
    (exist-egg-in-hole ?x - env)
    (exist-poached-egg ?x - env)

    ; ----------------------
    ; serve goals
    ; ----------------------
    (enable-scrambled-eggs ?x - egg ?y - plate)
    (enable-omelette ?x - egg ?y - ingredient ?z - plate)
    (enable-sunny-side-up ?x - egg ?y - plate)
    (enable-egg-in-hole ?x - egg ?y - bread ?z - plate)
    (enable-poached-egg ?x - egg ?y - plate)

    ( exist-two-scrambled-eggs ?env - env )
    ( exist-two-omelette ?x - env )
    ( exist-two-sunny-side-up ?x - env )
    ( exist-two-egg-in-hole ?x - env )
    ( exist-two-poached-egg ?x - env )
    ( exist-two-two-egg-dishs ?env - env )

    ( exist-two-egg-dishs ?env - env )
    ( customer-happy ?c - customer )
    ( customer-happier ?c - customer )
    ( customer-happiest ?c - customer )
    ( customer-pay ?c - customer )

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
         ( increase ( total-cost ) 1 )
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
         ( increase ( total-cost ) 1 )
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
         ( forall ( ?u - utensil )
            ( when ( and ( not ( = ?c ?u ) )  ( on ?a ?u ) )
                    ( burned-utensil ?u ?a )
            )
         )
          ( forall ( ?l - level )
            ( when ( default-level ?a ?l )
                   ( at-level ?a ?l )
            )
          )
         ( increase ( total-cost ) 1 )
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
         ( increase ( total-cost ) 1 )
      )
  )

  ( :action change-level
      :parameters ( ?a - appliance ?c - level )
      :precondition( and
          ( switchedon ?a )
      )
      :effect( and 
          ( at-level ?a ?c )
          ( default-level ?a ?c )
          ( increase ( total-cost ) 1 )
      )
  )

  ( :action turn-tap-on
      :parameters ( ?t - liquidtap )
      :precondition( and
          ( turnedoff ?t )
      )
      :effect( and
          ( not ( turnedoff ?t ) )
          ( turnedon ?t )
          ( increase ( total-cost ) 1 )
      )
  )

  ( :action turn-tap-off
      :parameters ( ?t - liquidtap )
      :precondition( and
          ( turnedon ?t )
      )
      :effect( and 
          ( not ( turnedon ?t ) )
          ( turnedoff ?t )
          ( increase ( total-cost ) 1 )
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
          ( increase ( total-cost ) 1 )
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
         ( increase ( total-cost ) 1 )
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
         ( increase ( total-cost ) 1 )
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
         ( increase ( total-cost ) 1 )
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
         ( increase ( total-cost ) 1 )
      )
  )

  ( :action transfer
      :parameters ( ?param1 - ingredient ?param2 - container ?param3 - container ?param4 - agent)
      :precondition( and
         ( holding ?param2 ?param4 )
         ( inside ?param2 ?param1 )
         ( not ( is-liquid ?param1 ) )
      )
      :effect( and
         ( not ( inside ?param2 ?param1 ) )
         ( inside ?param3 ?param1 )
         ( increase ( total-cost ) 1 )
      )
  )

  ( :action season 
      :parameters ( ?i - ingredient ?s - ingredient ?c - container ?u - measureutensil ?r - agent)
      :precondition( and
         ( inside ?c ?s )
         ( holding ?u ?r )
         ( not ( needs-peeling ?i ) )
      )
      :effect( and
          ( seasoned-on ?i ?s ) 
          ( has-seasoning ?i ?s ?u one )
          ( when ( has-seasoning ?i ?s ?u one ) ( has-seasoning ?i ?s ?u two ) )
          ( when ( has-seasoning ?i ?s ?u two ) ( has-seasoning ?i ?s ?u three ) )
          ( when ( has-seasoning ?i ?s ?u three ) ( has-seasoning ?i ?s ?u four ) )
          ( when ( has-seasoning ?i ?s ?u four ) ( has-seasoning ?i ?s ?u five ) )
          ( when ( has-seasoning ?i ?s ?u five ) ( has-seasoning ?i ?s ?u six ) )
          ( increase ( total-cost ) 1 )
      )
  )

  ( :action sprinkle 
      :parameters ( ?i - ingredient ?s - seasoning ?c - container ?u - measureunit ?r - agent)
      :precondition( and
         ( inside ?c ?s )
         ( holding ?c ?r )
         ( not ( needs-peeling ?i ) )
      )
      :effect( and
          ( seasoned-on ?i ?s ) 
          ( has-seasoning ?i ?s ?u one )
          ( when ( has-seasoning ?i ?s ?u one ) ( has-seasoning ?i ?s ?u two ) )
          ( when ( has-seasoning ?i ?s ?u two ) ( has-seasoning ?i ?s ?u three ) )
          ( when ( has-seasoning ?i ?s ?u three ) ( has-seasoning ?i ?s ?u four ) )
          ( when ( has-seasoning ?i ?s ?u four ) ( has-seasoning ?i ?s ?u five ) )
          ( when ( has-seasoning ?i ?s ?u five ) ( has-seasoning ?i ?s ?u six ) )
          ( increase ( total-cost ) 1 )
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
          ( when ( and
              ( inside ?to ?i )
              ( not ( needs-peeling ?i ) )
            )
            ( and 
              ( seasoned-on ?i ?l ) 
              ( has-seasoning ?i ?l ?u one )
              ( when ( has-seasoning ?i ?l ?u one ) ( has-seasoning ?i ?l ?u two ) )
              ( when ( has-seasoning ?i ?l ?u two ) ( has-seasoning ?i ?l ?u three ) )
              ( when ( has-seasoning ?i ?l ?u three ) ( has-seasoning ?i ?l ?u four ) )
              ( when ( has-seasoning ?i ?l ?u four ) ( has-seasoning ?i ?l ?u five ) )
              ( when ( has-seasoning ?i ?l ?u five ) ( has-seasoning ?i ?l ?u six ) )
            )
          ) 
        )
        ( increase ( total-cost ) 1 )
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
         ( increase ( total-cost ) 1 )

         ;( when (and 
         ;              ( is-egg ?param1 )
         ;              ( raw ?param1 )
         ;          )
         ;          ( cracked ?param1 )
         ;)
      )
  )

  ( :action add-liquid
      :parameters ( ?l - liquid ?t - liquidtap ?c - container ?a - agent )
      :precondition( and
          ( holding ?c ?a )
          ( on kitchentop ?t )
          ( inside ?t ?l )
          ( turnedon ?t )
      )
      :effect( and
          ( inside ?c ?l )
          ( increase ( total-cost ) 1 )
      )
  )

  ( :action pour-liquid ; non-water
    :parameters ( ?l - liquid ?fr - liquidcontainer ?c - container ?a - agent )
    :precondition( and
        ( holding ?fr ?a )
        ( inside ?fr ?l )
    )
    :effect( and
        ( inside ?c ?l )
        ( increase ( total-cost ) 1 )
    )
  )

  ( :action crack-egg   ; a special case of adding ingredients
      :parameters ( ?param1 - egg ?param2 - moveable ?param3 - agent )
      :precondition( and
         ( raw ?param1 )
         ( holding ?param1 ?param3 )
         ( on kitchentop ?param2 )
         ( can-hold ?param2 )
         ( not ( cracked ?param1 ) )
      )
      :effect( and
         ( not ( raw ?param1 ) )
         ( not ( needs-peeling ?param1 ) )
         ( not ( holding ?param1 ?param3 ) )
         ( inside ?param2 ?param1 )
         ( cracked ?param1 )
         ( when ( has-space ?param2 ) ( inside ?param2 ?param1 ) )
         ( when ( has-hole ?param2 circle ) ( in-hole ?param1 ?param2 ) )
         ( increase ( total-cost ) 1 )
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
      :parameters ( ?i - ingredient ?p - pan ?a - appliance ?o - oil)
      :precondition( and
         ( inside ?p ?o )
         ( inside ?p ?i )
         ( on ?a ?p )
         ( switchedon ?a )
         ( not ( steamed ?i ) )
         ( not ( covered ?p ) )
         ( at-level ?a high )
         ( not ( fried ?i ) ) 
      )
      :effect( and
         ( fried ?i ) 
         ( when ( is-butter ?o ) ( is-buttery ?i ))
         ( when ( steamed ?i ) ( not ( is-buttery ?i ) ))
         ( increase ( total-cost ) 1 )
      )
  )

  ( :action steam
      :parameters ( ?i - ingredient ?p - cookingcontainer ?a - appliance)
      :precondition( and
         ( inside ?p ?i )
         ( on ?a ?p )
         ( covered ?p )
         ( switchedon ?a )
         ( at-level ?a medium )
         ( not ( steamed ?i ) )
      )
      :effect( and
         ( steamed ?i )
         ( increase ( total-cost ) 1 )
      )
  )

  ( :action boil
    :parameters ( ?l - liquid ?p - pot ?a - appliance )
    :precondition( and
      ( inside ?p ?l )
      ( on ?a ?p )
      ( switchedon ?a )
    )
    :effect( and

      ( boiled ?l )

      ;( when ( at-level ?a high ) ( increase ( total-cost ) 1 ) )
      ;( when ( at-level ?a medium ) ( increase ( total-cost ) 2 ) )
      ;( when ( at-level ?a low ) ( increase ( total-cost ) 3 ) )

      ( forall ( ?i - ingredient )
        ( and 
          ( when ( and ( inside ?p ?i ) ( boiled ?l ) ) 
                 ( boiled ?i ) )

          ; ----- when boiling eggs
          ( when ( and ( inside ?p ?i ) ( boiled ?l )
                        ( is-egg ?i ) ( at-level ?a high ) 
                        ( has-hole ?l circle ) ) 
                 ( and ( hardness ?i outerside hard )
                       ;( hardness ?i innerside hard ) 
                  ) )

          ( when ( and ( inside ?p ?i ) ( boiled ?l )
                        ( is-egg ?i ) ( at-level ?a medium ) 
                        ( has-hole ?l circle ) ) 
                 ( and ( hardness ?i outerside medium-hard )
                       ;( hardness ?i innerside medium-hard ) 
                  ) )

          ( when ( and ( inside ?p ?i ) ( boiled ?l )
                        ( is-egg ?i ) ( has-vinegar ?l ) ) 
                 ( hardness ?i innerside soft ) )

          ; ----- when boiling other things
          ( when ( and ( inside ?p ?i ) ( boiled ?l )
                        ( not ( is-egg ?i ) ) ( at-level ?a high ) ) 
                 ( and ( hardness ?i outerside hard )
                       ( hardness ?i innerside hard ) ) )

          ( when ( and ( inside ?p ?i ) ( boiled ?l )
                        ( not ( is-egg ?i ) ) ( at-level ?a medium ) ) 
                 ( and ( hardness ?i outerside medium-hard )
                       ( hardness ?i innerside medium-hard ) ) )
        )
      )

      ( increase ( total-cost ) 1 ) 
    )
  )

  ( :action fold
      :parameters ( ?i - ingredient ?p - pan ?u - cookingutensil ?r - agent)
      :precondition( and
         ( firm ?i )
         ( inside ?p ?i )
         ( holding ?u ?r )
         ( not ( folded ?i ) )
      )
      :effect( and
         ( folded ?i ) 
         ( increase ( total-cost ) 1 )
      )
  )

  ( :action scrape
      :parameters ( ?i - ingredient ?p - pan ?u - cookingutensil ?r - agent)
      :precondition( and
         ( firm ?i )
         ( inside ?p ?i )
         ( holding ?u ?r )
         ( not ( scrambled ?i ) )
      )
      :effect( and
         ( scrambled ?i ) 
         ( increase ( total-cost ) 1 )
      )
  )

  ( :action stir  
      :parameters ( ?l - liquid ?u - normalutensil ?p - pot ?a - agent )
      :precondition( and
          ( inside ?p ?l )
          ( holding ?u ?a )
          ( not ( stirred ?l ) )
      )
      :effect( and
          ( stirred ?l ) 
          ( has-hole ?l circle )
          ( increase ( total-cost ) 1 )
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
              ( when (seasoned-on ?param1 ?s) 
                      (seasoning-mixed ?param1 ?s)
              ) 
          )
          ( increase (total-cost) 1 )
      )
  )

  ( :action beat  ; special case of mixing
      :parameters ( ?param1 - ingredient ?param2 - normalutensil ?param3 - specialcontainer ?param4 - agent )
      :precondition( and
         ( impossible ?param1 )
         ( cracked ?param1 )
         ( not ( cooked ?param1 ) ) ; for no beaten in fry
         ( inside ?param3 ?param1 )
         ( holding ?param2 ?param4 )
      )
     :effect( and
         ( not ( cracked ?param1 ) )
         ( beaten ?param1 ) 
         ( increase ( total-cost ) 1 )
      )
  )

  ; ----------------------------------------
  ; -------- declare recipes
  ; ----------------------------------------

  ( :action declare-scrambled-eggs  
    :parameters ( ?egg1 - egg ?plate1 - plate )
    :precondition( and
      ( inside ?plate1 ?egg1 )
      ( beaten ?egg1 )
      ( fried ?egg1 )
      ( scrambled ?egg1 )
      ( has-seasoning ?egg1 nutmilk cup two )
      ( has-seasoning ?egg1 chives tablespoon1 one )
      ( seasoning-mixed ?egg1 chives )
      ( has-seasoning ?egg1 salt gram one )
      ( seasoning-mixed ?egg1 salt )
      ( has-seasoning ?egg1 pepper gram one )
      ( seasoning-mixed ?egg1 pepper )
    )
    :effect( and
      ( enable-scrambled-eggs ?egg1 ?plate1 )

      ( not ( inside ?plate1 ?egg1 ) )
      ( not ( beaten ?egg1 ) )
      ( not ( fried ?egg1 ) )
      ( not ( scrambled ?egg1 ) )
      ( not ( has-seasoning ?egg1 nutmilk cup two ) )
      ( not ( has-seasoning ?egg1 chives tablespoon1 one ) )
      ( not ( seasoning-mixed ?egg1 chives ) )
      ( not ( has-seasoning ?egg1 salt gram one ) )
      ( not ( seasoning-mixed ?egg1 salt ) )
      ( not ( has-seasoning ?egg1 pepper gram one ) )
      ( not ( seasoning-mixed ?egg1 pepper ) )

      ( increase ( total-cost ) 1 )
    )
  )

  ( :action declare-omelette
    :parameters ( ?egg1 - egg ?veggies1 - ingredient ?plate1 - plate )
    :precondition( and
      ( beaten ?egg1 )
      ( fried ?egg1 )
      ( folded ?egg1 )
      ( fried ?veggies1 )
      ( sauteed ?veggies1 )
      ( has-seasoning ?egg1 nutmilk cup two )
      ( has-seasoning ?egg1 chives tablespoon1 two )
      ( seasoning-mixed ?egg1 chives )
      ( has-seasoning ?egg1 salt gram two )
      ( seasoning-mixed ?egg1 salt )
      ( has-seasoning ?egg1 pepper gram two )
      ( seasoning-mixed ?egg1 pepper )
    )
    :effect( and
      ( enable-omelette ?egg1 ?veggies1 ?plate1 )

      ( not ( beaten ?egg1 ) )
      ( not ( fried ?egg1 ) )
      ( not ( folded ?egg1 ) )
      ( not ( fried ?veggies1 ) )
      ( not ( sauteed ?veggies1 ) )
      ( not ( has-seasoning ?egg1 nutmilk cup two ) )
      ( not ( has-seasoning ?egg1 chives tablespoon1 two ) )
      ( not ( seasoning-mixed ?egg1 chives ) )
      ( not ( has-seasoning ?egg1 salt gram two ) )
      ( not ( seasoning-mixed ?egg1 salt ) )
      ( not ( has-seasoning ?egg1 pepper gram two ) )
      ( not ( seasoning-mixed ?egg1 pepper ) )

      ( increase ( total-cost ) 1 )
    )
  )

  ( :action declare-sunny-side-up
    :parameters ( ?egg1 - egg ?plate1 - plate )
    :precondition( and
      ( inside ?plate1 ?egg1 )
      ( fried ?egg1 )
      ( steamed ?egg1 ) 
      ( has-seasoning ?egg1 salt gram one )
      ( has-seasoning ?egg1 pepper gram one )
    )
    :effect( and
      ( enable-sunny-side-up ?egg1 ?plate1 )

      ( not ( inside ?plate1 ?egg1 ) )
      ( not ( fried ?egg1 ) )
      ( not ( steamed ?egg1 )  )
      ( not ( has-seasoning ?egg1 salt gram one ) )
      ( not ( has-seasoning ?egg1 pepper gram one ) )

      ( increase ( total-cost ) 1 )
    )
  )

  ( :action declare-egg-in-hole
    :parameters ( ?egg1 - egg ?bread1 - bread ?plate1 - plate )
    :precondition( and
      ( inside ?plate1 ?bread1 )
      ( has-hole ?bread1 circle )
      ( in-hole ?egg1 ?bread1 ) 
      ( fried ?bread1 )
      ( has-seasoning ?egg1 salt gram one )
      ( has-seasoning ?egg1 pepper gram one )
    )
    :effect( and
      ( enable-egg-in-hole ?egg1 ?bread1 ?plate1 )

      ( not ( inside ?plate1 ?bread1 ) )
      ( not ( has-hole ?bread1 circle ) )
      ( not ( in-hole ?egg1 ?bread1 ) )
      ( not ( fried ?bread1 ) )
      ( not ( has-seasoning ?egg1 salt gram one ) )
      ( not ( has-seasoning ?egg1 pepper gram one ) )

      ( increase ( total-cost ) 1 )
    )
  )

  ( :action declare-poached-egg
    :parameters ( ?egg1 - egg ?plate1 - plate )
    :precondition( and
      ( boiled water )
      ( boiled ?egg1 )
      ( hardness ?egg1 outerside medium-hard )
      ( has-vinegar water )
    )
    :effect( and
      ( enable-poached-egg ?egg1 ?plate1 )

      ;( not ( boiled water ) )
      ( not ( boiled ?egg1 ) )
      ( not ( hardness ?egg1 outerside medium-hard ) )
      ;( not ( has-vinegar water ) )

      ( increase ( total-cost ) 1 )
    )
  )

  ; ----------------------------------------
  ; -------- ingredients transition model
  ; ----------------------------------------

  ( :derived (is-egg ?i ) (forall (?i - egg) (raw ?i ) ) )

  ( :derived (cooked ?i - ingredient) (fried ?i) )

  ( :derived (firm ?i - egg) (cooked ?i) )

  ( :derived ( is-liquid ?i - liquid ) 
    ( exists ( ?c - container ) ( inside ?c ?i ) ) )

  ( :derived ( has-vinegar ?l - liquid ) 
    ( exists ( ?v - vinegar ?p - cookingcontainer ) 
      ( and ( inside ?p ?v ) ( inside ?p ?l ) ( not ( = ?v ?l ) ) ) 
    )
  )


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
          ( forall ( ?t - liquidtap ) ( turnedoff ?t ) ) 
          ( safe-kitchen ?env )
      )
  )

  ; ----------------------------------------
  ; -------- recipes
  ; ----------------------------------------

  ( :derived ( exist-scrambled-eggs ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate ) ( enable-scrambled-eggs ?egg1 ?plate1 )
    )
  )

  ( :derived ( exist-omelette ?env - env )
    ( exists 
      ( ?egg1 - egg ?veggies1 - ingredient ?plate1 - plate ) 
      ( enable-omelette ?egg1 ?veggies1 ?plate1 )
    )
  )

  ( :derived ( exist-sunny-side-up ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate ) ( enable-sunny-side-up ?egg1 ?plate1 )
    )
  )

  ( :derived ( exist-egg-in-hole ?env - env )
    ( exists 
      ( ?egg1 - egg ?bread1 - bread ?plate1 - plate ) 
      ( enable-egg-in-hole ?egg1 ?bread1 ?plate1 )
    )
  )

  ( :derived ( exist-poached-egg ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate ) ( enable-poached-egg ?egg1 ?plate1 )
    )
  )


  ; ----------------------------------------
  ; -------- serve customers
  ; ----------------------------------------

  ( :derived ( exist-two-scrambled-eggs ?env - env ) 
    ( exists 
      ( ?egg1 - egg ?plate1 - plate ?egg2 - egg ?plate2 - plate )
      ( and 
        ( not ( = ?egg1 ?egg2 ) )
        ( not ( = ?plate1 ?plate2 ) )
        ( enable-scrambled-eggs ?egg1 ?plate1 )
        ( enable-scrambled-eggs ?egg2 ?plate2 )
      )
    )
  )

  ( :derived ( exist-two-omelette ?env - env )
    ( exists 
      ( ?egg1 - egg ?veggies1 - ingredient ?plate1 - plate 
        ?egg2 - egg ?veggies2 - ingredient ?plate2 - plate )
      ( and 
        ( not ( = ?egg1 ?egg2 ) )
        ( not ( = ?veggies1 ?veggies2 ) )
        ( not ( = ?plate1 ?plate2 ) )
        ( enable-omelette ?egg1 ?veggies1 ?plate1 )
        ( enable-omelette ?egg2 ?veggies2 ?plate2 )
      )
    )
  )

  ( :derived ( exist-two-sunny-side-up ?env - env )
    ( exists 
      ( ?egg1 - egg ?plate1 - plate ?egg2 - egg ?plate2 - plate )
      ( and 
        ( not ( = ?egg1 ?egg2 ) )
        ( not ( = ?plate1 ?plate2 ) )
        ( enable-sunny-side-up ?egg1 ?plate1 )
        ( enable-sunny-side-up ?egg2 ?plate2 )
      )
    )
  )

  ( :derived ( exist-two-egg-in-hole ?env - env ) 
    ( exists 
      ( ?egg1 - egg ?bread1 - bread ?plate1 - plate 
        ?egg2 - egg ?bread2 - bread ?plate2 - plate )
      ( and 
        ( not ( = ?egg1 ?egg2 ) )
        ( not ( = ?bread1 ?bread2 ) )
        ( not ( = ?plate1 ?plate2 ) )
        ( enable-egg-in-hole ?egg1 ?bread1 ?plate1 )
        ( enable-egg-in-hole ?egg2 ?bread2 ?plate2 )
      )
    )
  )

  ( :derived ( exist-two-poached-egg ?env - env ) 
    ( exists 
      ( ?egg1 - egg ?plate1 - plate ?egg2 - egg ?plate2 - plate )
      ( and 
        ( not ( = ?egg1 ?egg2 ) )
        ( not ( = ?plate1 ?plate2 ) )
        ( enable-poached-egg ?egg1 ?plate1 )
        ( enable-poached-egg ?egg2 ?plate2 )
      )
    )
  )

  ; ----------------------------------------
  ; -------- multiple options to make a customer happy
  ; ----------------------------------------

  ( :derived ( customer-happier ?c - customer ) ; two options
    ( exists ( ?env - env )
      ( exist-two-egg-dishs ?env )
    )
  )
  
  ( :derived ( exist-two-egg-dishs ?env - env ) ; option 1
    ( and
      (exist-omelette kitchen)
      (exist-egg-in-hole kitchen)
    )
  )

)