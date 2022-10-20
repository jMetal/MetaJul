MetaJul Web site
================

.. image:: https://github.com/jMetal/MetaJul/actions/workflows/unitTest.yml/badge.svg
    :alt: Test Status
    :target: https://github.com/jMetal/MetaJul/actions/workflows/unitTest.yml


The MetaJul project is aimed at studying the implementation of metaheuristics in the Julia programming language. The implemented codes and unit tests are located, respectively, in the ``src`` and tests ``test`` folders.

Current features:

* Encoding: continuous, binary
* Problems: 
  
     - Single-objective problems: continuous (Sphere), binary (OneMax)
     - Multi-objective problems: continuous (Fonseca, Schaffer, Kursawe, ZDT benchmark)

* Operators: uniform mutation, polynomial mutation, BLX-alpha crossover, simulated binary crossover (SBX), random selection, binary tournament selection
* Algorithms: local search, evolutionary algorithm, NSGA-II
* Archives: unbounded non-dominated archive, bounded crowding distance archive

The ``examples`` folder contains:

* Local search algorithm using uniform mutation to solve the Sphere problem
* Local search algorithm using polynomial mutation to solve the Sphere problem
* Local search algorithm using bit blip mutation to solve the OneMax problem
* Single objective genetic algorithm solving problem OneMax
* Single objective genetic algorithm solving problem Sphere
* NSGA-II algorithm configured from a generic evolutionary template
* NSGA-II algorithm configured from the NSGA-II template
* NSGA-II algorithm using a bounded crowding distance archive

Jupyter notebooks with examples can be found in the ``notebooks`` folder.

The next steps to carry out are enumerated in the `open issues page <https://github.com/jMetal/MetaJul/issues>`_ of the project.
