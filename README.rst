MetaJul Web site
================

.. image:: https://github.com/jMetal/MetaJul/actions/workflows/unitTest.yml/badge.svg
    :alt: Test Status
    :target: https://github.com/jMetal/MetaJul/actions/workflows/unitTest.yml


The MetaJul project is aimed at studying the implementation of metaheuristics in the Julia programming language. The implemented codes and unit tests are located, respectively, in the ``src`` and tests ``test`` folder.

Current features:

* Encoding: continuous, binary
* Problems: 
  
     - Single-objective problems: continuous (Sphere), binary (OneMax)
     - Multi-objective problems: continuous (Fonseca, Schaffer, Kursawe, ZDT benchmark)

* Operators: uniform mutation, polynomial mutation, BLX-alpha crossover, simulated binary crossover (SBX), random selection, binary tournament selection
* Algorithms: local search, evolutionary algorithm, NSGA-II

The ``examples`` folder contains:

* Local search algorithm using uniform mutation to solve the Sphere problem
* Local search algorithm using polynomial mutation to solve the Sphere problem
* Local search algorithm using bit blip mutation to solve the OneMax problem
* Single objective genetic algorithm solving problem OneMax
* Single objective genetic algorithm solving problem Sphere
* NSGA-II algorithm configured from a generic evolutionary template
* NSGA-II algorithm configured from the NSGA-II template

Some notebooks with examples can be found in the ``notebooks`` folder.


TODO list (open issues):

* Revise the implementation to make the code more Julia compliant.
* Improve documentation
* Optimize the code to improve efficiency (the running time of NSGA-II is similar to the Java implementation included in jMetal).
* By default, objective functions are assumed to be minimized, so their values have to be multiplied by -1 in case of maximization. Revise this issue.
* NSGA-II does not solve problem ZDT4 when stopping at 25000 evaluations