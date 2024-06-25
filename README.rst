MetaJul Web site
================

.. image:: https://github.com/jMetal/MetaJul/actions/workflows/unitTest.yml/badge.svg
    :alt: Test Status
    :target: https://github.com/jMetal/MetaJul/actions/workflows/unitTest.yml


The MetaJul project is aimed at studying the implementation of metaheuristics in the Julia programming language. The implemented codes and unit tests are located, respectively, in the ``src`` and tests ``test`` folders. MetaJul is described in the paper `Experiences Using Julia for Implementing Multi-objective Evolutionary Algorithms <https://link.springer.com/chapter/10.1007/978-3-031-62922-8_12>`_, presented at the MIC 2024 conference.

Current features:

* Encoding: continuous, binary
* Problems: 
  
     - Single-objective problems: continuous (Sphere), binary (OneMax)
     - Multi-objective problems: continuous (Fonseca, Schaffer, Kursawe, ZDT benchmark), binary (OneZeroMax)
     - Constrained problems: Srinivas, ConstrEx, Bihn2, Tanaka, Osyczka2, Golinski

* Operators: mutation (uniform, polynomial, bit-flip), crossover (BLX-alpha, simulated binary crossover -SBX-, single-point), selection (random, binary tournament)
* Algorithms: local search, evolutionary algorithm, genetic algorithm, NSGA-II, SMPSO (multi-objective PSO)
* Encodings: continuous (float, integer), binary
* Archives: unbounded non-dominated archive, bounded crowding distance archive
* Observers: ``EvaluationObserver``, ``FitnessObserver``, ``FrontPlotObserver``. Observers can be registered in observable entities, such as evolutionary algorithms, at configuration time.

The ``examples`` folder contains Julia programs illustrating how the included algorithms (local search, single objective evolutionary algorithm, NSGA-II, SMPSO) can be configured and executed.

Jupyter notebooks with examples can be found in the ``notebooks`` folder. 

The next steps to carry out are enumerated in the `open issues page <https://github.com/jMetal/MetaJul/issues>`_ of the project.
