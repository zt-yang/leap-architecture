# Studying output.sas

## with minimum set of objects

effects of extraneous objects:
* there exists 11 variables (var138 to var var148) on where `oliveoil` is
* there exists 11 values on where `tablespoon1`/`bread1` is
* there exists 13 values on where `egg1` is

```python
begin_variable
var174
-1
13
Atom holding(egg1, robot)
Atom in(dcup1, egg1)
Atom in(dcup2, egg1)
Atom in(drawer1, egg1)
Atom in(fridge1, egg1)
Atom in(ucup1, egg1)
Atom in(ucup2, egg1)
Atom in-hole(egg1, bread1)
Atom in-hole(egg1, butter)
Atom on(burner, egg1)
Atom on(kitchentop, egg1)
Atom on(sink, egg1)
<none of those>
end_variable
```

* there exists 8 variables for all types of seasoning the egg may have (2 values for 4 types of seasoning mentioned in goal)

```python
var166
-1
2
Atom has-seasoning(egg1, salt, gram, one)
NegatedAtom has-seasoning(egg1, salt, gram, one)
end_variable
begin_variable
var167
-1
2
Atom has-seasoning(egg1, salt, gram, two)
NegatedAtom has-seasoning(egg1, salt, gram, two)
end_variable
```


### Example variable with two values

SAS variable

```python
begin_variable
var2
-1 
2
Atom closed(ucup2)
Atom opened(ucup2)
end_variable
```

PDDL operator

```python
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
```

SAS operator

```python
begin_operator
close ucup2
0  ## 0 preconditions, each has two numbers <v, d>
1  ## 1 effect, each has four numbers <cond, v, d, d'>
0 2 1 0  ## the first effect: no precondition, value of var2 changes from value1 (opened(ucup2)) to value0 (closed(ucup2))
1 
end_operator

### 
begin_operator
open ucup2
0
1
0 2 0 1 ##
1
end_operator
```

### Example var with a lot of values (mutex)

where container1 is, which is mutually exclusive

```python
begin_variable
var37
-1
10
Atom holding(container1, robot)
Atom in(dcup1, container1)
Atom in(dcup2, container1)
Atom in(drawer1, container1)
Atom in(fridge1, container1)
Atom in(ucup1, container1)
Atom in(ucup2, container1)
Atom on(burner, container1)
Atom on(kitchentop, container1)
Atom on(sink, container1)
end_variable
```

```python
begin_mutex_group
3
156 1
174 7
174 8
end_mutex_group
```

### Example mutex group


```python
begin_mutex_group
11
156 0
174 0
174 1
174 2
174 3
174 4
174 5
174 6
174 9
174 10
174 11
end_mutex_group
```

```python
begin_variable
var156
-1
2
Atom cracked(egg1)
Atom raw(egg1)
end_variable
```

```python
begin_variable
var174
-1
13
Atom holding(egg1, robot)
Atom in(dcup1, egg1)
Atom in(dcup2, egg1)
Atom in(drawer1, egg1)
Atom in(fridge1, egg1)
Atom in(ucup1, egg1)
Atom in(ucup2, egg1)
Atom in-hole(egg1, bread1)
Atom in-hole(egg1, butter)
Atom on(burner, egg1)
Atom on(kitchentop, egg1)
Atom on(sink, egg1)
<none of those>
end_variable
```

### Example rule

#### simple rule with one cond and one effect

```python
begin_rule
1  ## 1 condition
14 0  ## cond
18 0 1  ## effect
end_rule
```

```python
begin_variable  ## cond 
var14
0
2
Atom new-axiom@0() ## one variable for each defined axiom
NegatedAtom new-axiom@0()
end_variable

begin_variable  ## effect 
var18
1
2
Atom is-egg(veggies1)
NegatedAtom is-egg(veggies1)
end_variable
```

### Example goal

```python
begin_goal
2
181 0
183 0
end_goal
```

2 destination values, in which 

```python
begin_variable
var181
1 
2
Atom organized(kitchen)
NegatedAtom organized(kitchen)
end_variable
```

### Example rule

the effect is making an axiom true, which makes the goal true

```python
begin_rule
6  ## 6 conditions
7 0   ## cond
6 0
5 0
4 0
3 0
2 0
8 0 1   ## effect
end_rule

begin_rule
4
8 1
176 1
1 1
180 0
181 1 0
end_rule
```


```python
begin_variable ## cond
var7
-1
2
Atom closed(dcup1)
Atom opened(dcup1)
end_variable

begin_variable   ## effect
var8
0
2
Atom new-axiom@1()
NegatedAtom new-axiom@1()
end_variable
```