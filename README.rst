MetaJul Web site
================

The MetaJul project is aimed at studying the implementation of metaheuristics in the Julia programming language. The implemented codes and unit tests are located, respectively, in the ``src`` and tests ``test`` folder.

Currently implemented elements:

* Encoding: continuous, binary
* Problem: continuous problem, problems Schaffer and Sphere
* Operator: uniform mutation, polynomial mutation, random selection, binary tournament selection
* Algorithm: local search

The ``examples`` folder contains:

* Local search algorithm using uniform mutation to solve the Sphere problem (10 variables)
* Local search algorithm using polynomial mutation to solve the Sphere problem (10 variables)