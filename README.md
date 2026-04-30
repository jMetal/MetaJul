# MetaJul

[![Test Status](https://github.com/jMetal/MetaJul/actions/workflows/unitTest.yml/badge.svg)](https://github.com/jMetal/MetaJul/actions/workflows/unitTest.yml)
[![Version](https://img.shields.io/badge/version-v0.3.0-orange)](https://github.com/jMetal/MetaJul/releases)
[![Julia ≥ 1.10](https://img.shields.io/badge/Julia-%E2%89%A5%201.10-blue.svg)](https://julialang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

MetaJul is a component-based metaheuristics framework written in Julia. Algorithms are built by composing interchangeable components (selection, variation, replacement, …), making it straightforward to configure, extend, and experiment with new designs without subclassing.

The project is described in the paper [*Experiences Using Julia for Implementing Multi-objective Evolutionary Algorithms*](https://link.springer.com/chapter/10.1007/978-3-031-62922-8_12), presented at MIC 2024.

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/jMetal/MetaJul")
```

## Quickstart

```julia
using MetaJul

# Solve ZDT1 with NSGA-II (default settings: 100 solutions, 25 000 evaluations)
problem   = ZDT1()
algorithm = NSGAII(problem)
optimize!(algorithm)

solutions = foundSolutions(algorithm)
```

More complete examples are in the [`examples/`](examples/) folder. Jupyter notebooks with step-by-step explanations are in [`notebooks/`](notebooks/).

## Running NSGA-II from the REPL

Julia compiles code on first use (JIT), so the initial run includes compilation overhead. To measure true execution time, run the algorithm twice and time the second call:

```julia
julia> using MetaJul

julia> problem = ZDT1()

# First call: triggers JIT compilation (~1–2 s overhead)
julia> algorithm = NSGAII(problem); optimize!(algorithm)

# Second call: compiled, reflects actual runtime
julia> algorithm = NSGAII(problem); @time optimize!(algorithm)
  0.384 seconds (3.04 M allocations: 289.114 MiB, 6.34% gc time)
```

For repeated benchmarking, [`BenchmarkTools.jl`](https://github.com/JuliaCI/BenchmarkTools.jl) handles warm-up automatically:

```julia
julia> using BenchmarkTools

julia> @benchmark optimize!(NSGAII(ZDT1()))
BenchmarkTools.Trial: 13 samples with 1 evaluation per sample.
 Range (min … max):  373 ms … 410 ms
 Median:             384 ms
```

## Features

### Encodings
- Continuous (Float64, Integer), Binary, Permutation

### Problems

| Family | Problems |
|--------|----------|
| Single-objective continuous | Sphere |
| Single-objective binary | OneMax |
| Multi-objective continuous | Fonseca, Schaffer, Kursawe, ZDT1–4/6, DTLZ1, UF1 |
| Multi-objective binary | OneZeroMax |
| Multi-objective permutation | TSP |
| Constrained | Srinivas, ConstrEx, Binh2, Tanaka, Osyczka2, Golinski, multi-objective Knapsack |
| Real-world approximations | Subasi 2016 (RWA) |

### Operators
- **Mutation:** Uniform, Polynomial, Bit-flip, Permutation swap
- **Crossover:** BLX-α, Simulated Binary (SBX), Single-point, PMX
- **Selection:** Random, Binary tournament

### Algorithms
- Local search
- Genetic algorithm (single-objective)
- NSGA-II
- SMPSO (multi-objective PSO)

### Quality indicators
- Inverted Generational Distance (IGD)
- Inverted Generational Distance Plus (IGD+)
- Additive Epsilon Indicator (ε+)
- Hypervolume (HV)

### Other
- **Archives:** unbounded non-dominated, bounded crowding-distance
- **Evaluation:** sequential, multithreaded (`MultithreadedEvaluation`)
- **Observers:** `EvaluationObserver`, `FitnessObserver`, `FrontPlotObserver`
- **CLI utility:** `bin/quality_indicator.jl`

## Running the tests

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

## How to cite

If you use MetaJul in your research, please cite:

```bibtex
@inproceedings{Nebro2024MetaJul,
  author    = {Nebro, Antonio J.},
  title     = {Experiences Using Julia for Implementing Multi-objective Evolutionary Algorithms},
  booktitle = {Metaheuristics International Conference (MIC 2024)},
  series    = {Lecture Notes in Computer Science},
  volume    = {14753},
  pages     = {168--181},
  publisher = {Springer},
  year      = {2024},
  doi       = {10.1007/978-3-031-62922-8_12}
}
```

## Open issues and roadmap

Planned work is tracked on the [open issues page](https://github.com/jMetal/MetaJul/issues).
