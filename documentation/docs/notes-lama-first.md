
```python
     t  run_name      var    op    axiom    plan    cost    parse      search    state
------  ----------  -----  ----  -------  ------  ------  -------  ----------  -------
153103  omelette_1     34   742       10      20      20    1.291  0.00208362       68
153105  omelette_2     38   745       13      31      31    1.366  0.00439175      140
153107  omelette_3     39   749       13      42      42    1.323  0.00486575      165
153108  omelette_4     53   947       13      63      63    1.292  0.0132945       433
153110  omelette_5     61  1199       13      55      55    1.245  0.0138989       348
153111  omelette_6     63  1199       15      55      55    1.247  0.0132843       348
153113  omelette_7     63  1199       15      55      55    1.302  0.0142437       348
```

```sql
open dcup1 (1)
getout pot1 dcup1 robot (1)
close dcup1 (1)
putdown pot1 burner robot (1)
open fridge (1)
getout butter fridge robot (1)
getout egg1 fridge robot (1)
close fridge (1)
crack-egg egg1 smallbowl1 robot (1)
open dcup2 (1)
getout oilbottle1 dcup2 robot (1)
close dcup2 (1)
add-ingredient butter smallbowl1 robot (1)
putdown oilbottle1 burner robot (1)
pickup smallbowl1 kitchentop robot (1)
transfer butter smallbowl1 pot1 robot (1)
transfer egg1 smallbowl1 pot1 robot (1)
switchon burner pot1 (1)
fry egg1 pot1 burner butter (1)
switchoff burner pot1 (1)
[t=0.0422464s, 8478420 KB] Plan length: 20 step(s).
```

```sql
open dcup1 (1)
getout pot1 dcup1 robot (1)
close dcup1 (1)
putdown pot1 burner robot (1)
pickup smallbowl1 kitchentop robot (1)
open fridge (1)
getout butter fridge robot (1)
getout egg1 fridge robot (1)
close fridge (1)
putdown smallbowl1 kitchentop robot (1)
crack-egg egg1 smallbowl1 robot (1)
add-ingredient butter smallbowl1 robot (1)
pickup smallbowl1 kitchentop robot (1)
transfer butter smallbowl1 pot1 robot (1)
transfer egg1 smallbowl1 pot1 robot (1)
switchon burner pot1 (1)
fry egg1 pot1 burner butter (1)
switchoff burner pot1 (1)
[t=0.0729507s, 8496852 KB] Plan length: 18 step(s).
```


```sql
open dcup1 (1)
getout pot1 dcup1 robot (1)
close dcup1 (1)
open fridge (1)
getout butter fridge robot (1)
getout egg1 fridge robot (1)
putdown pot1 burner robot (1)
crack-egg egg1 smallbowl1 robot (1)
add-ingredient butter smallbowl1 robot (1)
pickup smallbowl1 kitchentop robot (1)
transfer butter smallbowl1 pot1 robot (1)
transfer egg1 smallbowl1 pot1 robot (1)
switchon burner pot1 (1)
fry egg1 pot1 burner butter (1)
switchoff burner pot1 (1)
close fridge (1)
[t=0.141309s, 8496852 KB] Plan length: 16 step(s).
```