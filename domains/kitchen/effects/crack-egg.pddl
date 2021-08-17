  ( :action crack-egg-1   ; basic, omelette, scrambled, sunny-side-up
    :parameters ( ?param1 - egg ?param2 - specialcontainer ?param3 - agent )
    :precondition( and
      ( raw ?param1 )
      ( holding ?param1 ?param3 )
      ( on kitchentop ?param2 )
      ( can-hold ?param2 )
    ) 
    :effect( and
      ( not ( raw ?param1 ) )
      ( not ( holding ?param1 ?param3 ) )
      ( cracked ?param1 )
      ( increase ( total-cost ) 1 )

      ( inside ?param2 ?param1 )
    )
  )

  ( :action crack-egg-2   ; sunny-side-up cannot due to (when
    :parameters ( ?param1 - egg ?param2 - moveable ?param3 - agent )
    :precondition( and
      ( raw ?param1 )
      ( holding ?param1 ?param3 )
      ( on kitchentop ?param2 )
      ( can-hold ?param2 )
    ) 
    :effect( and
      ( not ( raw ?param1 ) )
      ( not ( holding ?param1 ?param3 ) )
      ( cracked ?param1 )
      ( increase ( total-cost ) 1 )

      ;( inside ?param2 ?param1 ) ; add a when condition, required for egg-in-hole
      ( when ( has-space ?param2 ) 
        ( inside ?param2 ?param1 )
      )
    )
  )

  ( :action crack-egg-3   ; egg-in-hole can
    :parameters ( ?param1 - egg ?param2 - moveable ?param3 - agent )
    :precondition( and
      ( raw ?param1 )
      ( holding ?param1 ?param3 )
      ( on kitchentop ?param2 )
      ( can-hold ?param2 )
    ) 
    :effect( and
      ( not ( raw ?param1 ) )
      ( not ( holding ?param1 ?param3 ) )
      ( cracked ?param1 )
      ( when ( has-space ?param2 ) ( inside ?param2 ?param1 ) )
      ( when ( has-hole ?param2 circle ) ( in-hole ?param1 ?param2 ) )
      ( increase ( total-cost ) 1 )

      ; SHOW: if I delete the following effects, which can never be possible, the plan length increases from 39 to 52, both inefficient
      ( when 
        ( and 
          ( impossible ?param2 )
          ( has-hole ?param2 circle ) 
          ( exists ( ?c - cookingcontainer ) ( inside ?c ?param2 ) )
        )
        ( and ( inside ?c ?param1 ) ( in-hole ?param1 ?param2 ) )
      )

    )
  )

  ( :action crack-egg-4   ; egg-in-hole cannot
    :parameters ( ?param1 - egg ?param2 - moveable ?param3 - agent )
    :precondition( and
      ( raw ?param1 )
      ( holding ?param1 ?param3 )
      ( on kitchentop ?param2 )
      ( can-hold ?param2 )
    ) 
    :effect( and
      ( not ( raw ?param1 ) )
      ( not ( holding ?param1 ?param3 ) )
      ( cracked ?param1 )
      ( when ( has-space ?param2 ) ( inside ?param2 ?param1 ) )
      ( when ( has-hole ?param2 circle ) ( in-hole ?param1 ?param2 ) )
      ( increase ( total-cost ) 1 )

      ; SHOW: if I delete the following effects, which can never be possible, the plan length increases from 39 to 52, both inefficient
      ;( when 
      ;  ( and 
      ;    ( impossible ?param2 )
      ;    ( has-hole ?param2 circle ) 
      ;    ( exists ( ?c - cookingcontainer ) ( inside ?c ?param2 ) )
      ;  )
      ;  ( and ( inside ?c ?param1 ) ( in-hole ?param1 ?param2 ) )
      ;)

    )
  )