# Set up the Repository

To clone the LEAP repository, you need to send [Yang](mailto:ztyang@mit.edu) your GitHub username to be invited as a collaborator.

Open terminal and go to your favorite work directory (e.g., ~/Documents) to clone the project:

```
git clone git@github.com:zt-yang/leap-architecture.git
```

## Planners setup

Add FastDownward or PyperPlan as git submodules:

```
git submodule add https://github.com/aibasel/downward.git
git submodule add https://github.com/aibasel/pyperplan.git
git submodule init
git submodule update
./downward/build.py release
```