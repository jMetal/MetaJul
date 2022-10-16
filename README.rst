MetaJul Web site
================

.. image:: https://github.com/jMetal/MetaJul/actions/workflows/unitTest.yml/badge.svg
    :alt: Test Status
    :target: https://github.com/jMetal/MetaJul/actions/workflows/unitTest.yml


The MetaJul project is aimed at studying the implementation of metaheuristics in the Julia programming language. The implemented codes and unit tests are located, respectively, in the ``src`` and tests ``test`` folder.

Currently implemented elements:

* Encoding: continuous, binary
* Problem: 
   * Single-objective problems: continuous (Sphere), binary (OneMax)
   * Multi-objective problems: continuous (Fonseca, Schaffer, Kursawe)
* Operator: uniform mutation, polynomial mutation, random selection, binary tournament selection
* Algorithm: local search, evolutionary algorithm, NSGA-II

The ``examples`` folder contains:

* Local search algorithm using uniform mutation to solve the Sphere problem
* Local search algorithm using polynomial mutation to solve the Sphere problem
* Local search algorithm using bit blip mutation to solve the OneMax problem