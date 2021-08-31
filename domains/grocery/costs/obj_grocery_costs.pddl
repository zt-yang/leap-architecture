  (:objects 

    ; ----------------------
    ;; --- 14 areas
    ; ----------------------
    harvard-campus central-square cambridge-port mit-campus longfellow-bridge beacon-hill north-end chinatown newburry-st harvard-bridge berklee-campus bu-campus bu-bridge allston - area

    parkinglot001 parkinglot002 parkinglot003 parkinglot004 parkinglot005 parkinglot006 parkinglot007 parkinglot008 parkinglot009 parkinglot010 parkinglot011 parkinglot012 parkinglot013 parkinglot014 - parkinglot

    ; ----------------------
    ;; --- 3 special locations
    ; ----------------------
    ashdown peabody stata - location

    home friends-home office - building

    parkinglot101 parkinglot102 parkinglot103 - parkinglot

    ; ----------------------
    ;; --- 9 supermarkets
    ; ----------------------
    brothers-market - location
    wholefoods-cs wholefoods-cp wholefoods-bh wholefoods-bc - location
    traderjoes-ns star-market-ns cmart-at cmart-ct - location

    market1 market2 market3 market4 market5 market6 market7 market8 market9 - store

    parkinglot201 parkinglot202 parkinglot203 parkinglot204 parkinglot205 parkinglot206 parkinglot207 parkinglot208 parkinglot209 - parkinglot

    ; ----------------------
    ;; --- 9 specialized stores
    ; ----------------------
    chocolate-shop-hc chocolate-shop-bh chocolate-shop-ns - location
    butchers-shop-bh butchers-shop-ne - location
    mikes-pastry-hc mikes-pastry-ne modern-pastry-ne meixin-pastry-ct - location

    shop1 shop2 shop3 shop4 shop5 shop6 shop7 shop8 shop9 - store

    parkinglot301 parkinglot302 parkinglot303 parkinglot304 parkinglot305 parkinglot306 parkinglot307 parkinglot308 parkinglot309 - parkinglot

    ; ----------------------
    ;; --- physical items
    ; ----------------------
    car1 - car 
    card1 - credit-card
    10 20 30 - cost

    ; ----------------------
    ;; to merge with kitchen_extended
    ; ----------------------
    robot - agent
    fridge1 - furniture
    dcup1 - furniture
    veggies1 - ingredient
    egg1 - egg
    egg2 - egg
    lambchop1 - lambchop
    bread1 - bread
    pot1 - pot
  )

  (:init 

    ; ----------------------
    ;; ---- area connectivity
    ; ----------------------
    (adj-area-1 harvard-campus central-square)
    (adj-area-1 central-square cambridge-port)
    (adj-area-1 central-square mit-campus)
    (adj-area-1 mit-campus cambridge-port)
    (adj-area-1 mit-campus harvard-bridge)
    (adj-area-1 mit-campus longfellow-bridge)
    (adj-area-1 longfellow-bridge beacon-hill)
    (adj-area-1 beacon-hill north-end)
    (adj-area-1 beacon-hill chinatown)
    (adj-area-1 beacon-hill newburry-st)
    (adj-area-1 chinatown newburry-st)
    (adj-area-1 newburry-st harvard-bridge)
    (adj-area-1 newburry-st berklee-campus)
    (adj-area-1 chinatown newburry-st)
    (adj-area-1 berklee-campus harvard-bridge)
    (adj-area-1 berklee-campus bu-campus)
    (adj-area-1 bu-campus harvard-bridge)
    (adj-area-1 bu-campus bu-bridge)
    (adj-area-1 cambridge-port bu-bridge)
    (adj-area-1 allston bu-bridge )
    (adj-area-1 allston berklee-campus)
  

    ; ----------------------
    ;; ---- area constitutes
    ; ----------------------
    (adj-loc-1 harvard-campus mikes-pastry-hc)
    (adj-loc-1 harvard-campus chocolate-shop-hc)
    (adj-loc-1 harvard-campus peabody)

    (adj-loc-1 central-square wholefoods-cs)

    (adj-loc-1 cambridge-port wholefoods-cp)

    (adj-loc-1 mit-campus ashdown)
    (adj-loc-1 mit-campus stata)
    (adj-loc-1 mit-campus brothers-market)

    (adj-loc-1 beacon-hill wholefoods-bh)
    (adj-loc-1 beacon-hill butchers-shop-bh)
    (adj-loc-1 beacon-hill chocolate-shop-bh)

    (adj-loc-1 north-end butchers-shop-ne)
    (adj-loc-1 north-end modern-pastry-ne)
    (adj-loc-1 north-end mikes-pastry-ne)

    (adj-loc-1 chinatown meixin-pastry-ct)
    (adj-loc-1 chinatown cmart-ct)

    (adj-loc-1 newburry-st star-market-ns)
    (adj-loc-1 newburry-st traderjoes-ns)
    (adj-loc-1 newburry-st chocolate-shop-ns)

    (adj-loc-1 berklee-campus wholefoods-bc)

    (adj-loc-1 allston cmart-at)


    ; ----------------------
    ;; ---- places with parking lots
    ; ----------------------

    ;; --- 14 parkinglots for areas
    (contain-loc harvard-campus parkinglot001)
    (contain-loc central-square parkinglot002)
    (contain-loc cambridge-port parkinglot003)
    (contain-loc mit-campus parkinglot004)
    (contain-loc longfellow-bridge parkinglot005)
    (contain-loc beacon-hill parkinglot006)
    (contain-loc north-end parkinglot007)
    (contain-loc chinatown parkinglot008)
    (contain-loc newburry-st parkinglot009)
    (contain-loc harvard-bridge parkinglot010)
    (contain-loc berklee-campus parkinglot011)
    (contain-loc bu-campus parkinglot012)
    (contain-loc bu-bridge parkinglot013)
    (contain-loc allston parkinglot014)
    
    ;; --- 3 parkinglots for special locations
    (contain-loc ashdown parkinglot101)
    (contain-loc peabody parkinglot102)
    (contain-loc stata parkinglot103)

    ;; --- 9 parkinglots for supermarkets
    (contain-loc brothers-market parkinglot201)
    (contain-loc wholefoods-cs parkinglot202)
    (contain-loc wholefoods-cp parkinglot203)
    (contain-loc wholefoods-bh parkinglot204)
    (contain-loc wholefoods-bc parkinglot205)
    (contain-loc traderjoes-ns parkinglot206)
    (contain-loc star-market-ns parkinglot207)
    (contain-loc cmart-at parkinglot208)
    (contain-loc cmart-ct parkinglot209)

    ;; --- 9 parkinglots for specialized stores
    (contain-loc chocolate-shop-hc parkinglot301)
    (contain-loc chocolate-shop-bh parkinglot302)
    (contain-loc chocolate-shop-ns parkinglot303)
    (contain-loc butchers-shop-bh parkinglot304)
    (contain-loc butchers-shop-ne parkinglot305)
    (contain-loc mikes-pastry-hc parkinglot306)
    (contain-loc mikes-pastry-ne parkinglot307)
    (contain-loc modern-pastry-ne parkinglot308)
    (contain-loc meixin-pastry-ct parkinglot309)


    ; ----------------------
    ;; ---- places with buildings
    ; ----------------------

    ;; --- 3 special locations
    (contain-loc ashdown home)
    (contain-loc peabody friends-home)
    (contain-loc stata office)

    ;; --- 9 marketplaces in supermarkets
    (contain-loc brothers-market market1)
    (contain-loc wholefoods-cs market2)
    (contain-loc wholefoods-cp market3)
    (contain-loc wholefoods-bh market4)
    (contain-loc wholefoods-bc market5)
    (contain-loc traderjoes-ns market6)
    (contain-loc star-market-ns market7)
    (contain-loc cmart-at market8)
    (contain-loc cmart-ct market9)

    ;; --- 9 shops in specialized stores
    (contain-loc chocolate-shop-hc shop1)
    (contain-loc chocolate-shop-bh shop2)
    (contain-loc chocolate-shop-ns shop3)
    (contain-loc butchers-shop-bh shop4)
    (contain-loc butchers-shop-ne shop5)
    (contain-loc mikes-pastry-hc shop6)
    (contain-loc mikes-pastry-ne shop7)
    (contain-loc modern-pastry-ne shop8)
    (contain-loc meixin-pastry-ct shop9)

    ; ----------------------
    ;; ---- shopping category
    ; ----------------------

    ;; --- 9 marketplaces in supermarkets
    (is-store market1)
    (is-store market2)
    (is-store market3)
    (is-store market4)
    (is-store market5)
    (is-store market6)
    (is-store market7)
    (is-store market8)
    (is-store market9)

    (store-cost market1 30)
    (store-cost market2 20)
    (store-cost market3 20)
    (store-cost market4 20)
    (store-cost market5 20)
    (store-cost market6 10)
    (store-cost market7 10)
    (store-cost market8 10)
    (store-cost market9 10)

    (at-loc veggies1 market1)
    (at-loc veggies1 market2)
    (at-loc veggies1 market3)
    (at-loc veggies1 market4)
    (at-loc veggies1 market5)
    (at-loc veggies1 market6)
    (at-loc veggies1 market7)
    (at-loc veggies1 market8)
    (at-loc veggies1 market9)

    (at-loc egg1 market1)
    (at-loc egg1 market2)
    (at-loc egg1 market3)
    (at-loc egg1 market4)
    (at-loc egg1 market5)
    (at-loc egg1 market6)
    (at-loc egg1 market7)
    (at-loc egg1 market8)
    (at-loc egg1 market9)

    (at-loc egg2 market1)
    (at-loc egg2 market2)
    (at-loc egg2 market3)
    (at-loc egg2 market4)
    (at-loc egg2 market5)
    (at-loc egg2 market6)
    (at-loc egg2 market7)
    (at-loc egg2 market8)
    (at-loc egg2 market9)
    
    (at-loc pot1 market2)
    (at-loc pot1 market3)
    (at-loc pot1 market8)
    (at-loc pot1 market9)

    ;; --- 9 shops in specialized stores
    (is-store shop1)
    (is-store shop2)
    (is-store shop3)
    (is-store shop4)
    (is-store shop5)
    (is-store shop6)
    (is-store shop7)
    (is-store shop8)
    (is-store shop9)

    (store-cost shop1 20)
    (store-cost shop2 20)
    (store-cost shop3 20)
    (store-cost shop4 30)
    (store-cost shop5 30)
    (store-cost shop6 10)
    (store-cost shop7 10)
    (store-cost shop8 10)
    (store-cost shop9 10)

    (at-loc lambchop1 shop4)
    (at-loc lambchop1 shop5)

    (at-loc bread1 shop6)
    (at-loc bread1 shop7)
    (at-loc bread1 shop8)
    (at-loc bread1 shop9)

    ; ----------------------
    ;; ---- task relevant
    ; ----------------------
    (agent-at robot home)
    (agent-has robot card1)
    (agent-owns robot car1)
    (parked-at car1 parkinglot101)  


  )