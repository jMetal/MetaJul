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
* Observers: ``EvaluationObserver``, ``FitnessObserver``. Observers can be registered in observable entities, such as evolutionary algorithms, at configuration time.

The ``examples`` folder contains:

* Local search algorithm using uniform mutation to solve the Sphere problem
* Local search algorithm using polynomial mutation to solve the Sphere problem
* Local search algorithm using bit blip mutation to solve the OneMax problem
* Single objective genetic algorithm solving problem OneMax
* Single objective genetic algorithm solving problem Sphere
* Single objective genetic algorithm printing the current fitness during the running using a `FitnessObserver`.
* NSGA-II algorithm configured from a generic evolutionary algorithmm template
* NSGA-II algorithm configured from the NSGA-II template
* NSGA-II algorithm using a bounded crowding distance archive
* NSGA-II using an observer (`EvaluationObserver`) that prints the number of evaluations 

Jupyter notebooks with examples can be found in the ``notebooks`` folder.

The next steps to carry out are enumerated in the `open issues page <https://github.com/jMetal/MetaJul/issues>`_ of the project.
