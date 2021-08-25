# Logistics domain

for testing planner modes, action costs,

```python
     t  run_name                     var    op    axiom    plan    cost    parse       search    state
------  -------------------------  -----  ----  -------  ------  ------  -------  -----------  -------
130147  pln=lama_first                 3    28        0       4      52    0.008  0.0001545          6
------  -------------------------  -----  ----  -------  ------  ------  -------  -----------  -------
130148  pln=lama                       3    28        0       5      32    0.014  0.00314392        52
130148  pln=seq_sat_lama_2011          3    28        0       5      32    0.011  0.00379796        52
130149  pln=seq_sat_fd_autotune_1      3    28        0       5      32    0.013  0.00683321        31
130149  pln=seq_sat_fd_autotune_2      3    28        0       5      32    0.008  0.00677617        35
130149  pln=seq_opt_bjolp              3    28        0       5      32    0.01   0.000458125        1
130150  pln=seq_opt_lmcut              3    28        0       5      32    0.008  0.000239667        0
130150  pln=v1                         3    28        0       5      32    0.01   0.000414417        6
```