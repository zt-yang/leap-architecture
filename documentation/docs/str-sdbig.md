## Separating Domains Based on Influence Graph

```python
     t  run_name                              var    op    axiom  plan    cost      prep    parse  search      state
------  ----------------------------------  -----  ----  -------  ------  ------  ------  -------  ----------  -------
123749  lama_first,                           424  2831      280  56      152      0        6.02   0.108769    816
------  ----------------------------------  -----  ----  -------  ------  ------  ------  -------  ----------  -------
123755  lama_first, prep=SDBIG/trial1_prb2      1     0        0  -       -        3.791    1.952  (>0.04)     -
123757  lama_first, prep=SDBIG/trial2_prb2      1     0        0  -       -        0        2.016  (>0.05)     -
123800  lama_first, prep=SDBIG/trial3_prb2      1     0        0  -       -        0        2.012  (>0.05)     -
123802  lama_first, prep=SDBIG/trial4_prb2      1     0        0  -       -        0        2.065  (>0.05)     -
123804  lama_first, prep=SDBIG/trial5_prb2      1     0        0  -       -        0        1.933  (>0.05)     -
123806  lama_first, prep=SDBIG/trial6_prb2      1     0        0  -       -        0        2.039  (>0.05)     -
123808  lama_first, prep=SDBIG/trial7_prb2      1     0        0  -       -        0        2.035  (>0.06)     -
123813  lama_first, prep=SDBIG/trial8_prb2    163  2068       90  46      74       0        4.961  0.0212483   207
123813  lama_first, prep=SDBIG/trial8_prb1     12    33       10  8       75       0        0.08   0.0002295   9
------  ----------------------------------  -----  ----  -------  ------  ------  ------  -------  ----------  -------
------  ----------------------------------  -----  ----  -------  ------  ------  ------  -------  ----------  -------
123824  lama,                                 424  2831      280  53      142      0        6.124  0.24001813  (>3.91)
------  ----------------------------------  -----  ----  -------  ------  ------  ------  -------  ----------  -------
123839  lama, prep=SDBIG/trial1_prb2          163  2068       90  45      64       3.777    5.091  0.13258815  (>4.95)
123839  lama, prep=SDBIG/trial1_prb1           12    33       10  12      71       3.777    0.079  0.00426283  191
```

## Tarjan’s algorithm for finding articulation points 

In DFS tree, a vertex u is articulation point if one of the following two conditions is true:

1) u is root of DFS tree and it has at least two children. 
2) u is not root of DFS tree and it has a child v such that no vertex in subtree rooted with v has a back edge to one of the ancestors (in DFS tree) of u.

[Tarjan’s algorithm](https://www.geeksforgeeks.org/articulation-points-or-cut-vertices-in-a-graph/) solves it in O(V+E) time