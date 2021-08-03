(define (problem Omelette)
  (:domain Kitchen)
  (:objects
   ucup1 ucup2 dcup1 dcup2 drawer1 fridge - furniture
   burner - appliance
   kitchentop sink - worktop
   oil salt - ingredient
   egg1 - egg
   egg2 - egg
   egg3 - egg
   bacon1 - bacon
   bacon2 - bacon
   lettuce3 - lettuce
   cookingcontainer normalcontainer - container
   specialcontainer - normalcontainer
   liquidcontainer - normalcontainer
   knife1 fork1 - normalutensil
   plate1 salter - normalcontainer
   oilbottle - liquidcontainer
   bigbowl - specialcontainer
   frypan - cookingcontainer)
  (:init
   (closed drawer1)
   (closed dcup1)
   (closed fridge)
   (closed dcup2)
   (closed ucup1)
   (closed ucup2)
   (in dcup1 frypan)
   (in kitchentop plate1)
   (in kitchentop salter)
   (in kitchentop fork1)
   (in kitchentop bigbowl)
   (in dcup2 oilbottle)
   (in fridge egg1)
   (inside salter salt)
   (inside oilbottle oil)
   (off burner)
   (raw egg1)
   )
  (:goal
   (and
    (closed ucup1)
    (closed ucup2)
    (closed dcup1)
    (closed dcup2)
    (closed drawer1)
    (closed fridge)
    (omelette egg1))))
