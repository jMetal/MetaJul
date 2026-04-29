# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the full test suite
julia --project=. -e 'using Pkg; Pkg.test()'

# Run a single test file
julia --project=. test/util/qualityIndicatorTest.jl

# Run an example
julia --project=. examples/NSGAIIFloatProblemDefaultSettings.jl

# Install/update dependencies
julia --project=. -e 'using Pkg; Pkg.instantiate()'

# Run quality indicator CLI
julia bin/quality_indicator.jl --help
```

## Architecture

MetaJul is a component-based metaheuristics framework. The design separates algorithm logic into interchangeable components, allowing algorithms to be constructed and configured without subclassing.

### Core abstraction hierarchy (`src/core/coreTypes.jl`)

All types derive from abstract bases defined here. The key hierarchy:
- `Solution` → `ContinuousSolution{T}`, `BinarySolution`, `PermutationSolution`
- `Problem{T}` → `ContinuousProblem{T}`, `BinaryProblem`, `PermutationProblem`
- `Algorithm` → `EvolutionaryAlgorithm`, `GeneticAlgorithm`, `NSGAII`, `ParticleSwarmOptimization`, `LocalSearch`
- `Component` → `SolutionsCreation`, `Evaluation`, `Termination`, `Selection`, `Variation`, `Replacement` (and PSO-specific components)
- `QualityIndicator`, `Archive`, `Comparator`, `Ranking`, `DensityEstimator`

### The EvolutionaryAlgorithm engine (`src/algorithm/evolutionaryAlgorithm.jl`)

`EvolutionaryAlgorithm` is the central execution engine. Its loop is:
```
create → evaluate → while !isMet(termination):
    select → variate → evaluate offspring → replace → notify observers
```
High-level algorithms (NSGA-II, GeneticAlgorithm) are thin wrappers: they configure an `EvolutionaryAlgorithm` instance with the right components and call `evolutionaryAlgorithm(solver)`. They do **not** re-implement the loop.

### Solution structure

Every solution carries: `variables`, `objectives`, `constraints` (vectors), `attributes` (Dict for arbitrary metadata), and `bounds`. `ContinuousSolution{T}` is generic over `Float64` or `Int`.

### Comparators convention

All `compare(comparator, a, b)` methods return: `-1` if `a` is better, `1` if `b` is better, `0` if equal.

### Observers

Algorithms hold an `Observable`. Observers are registered with `register!(observable(algorithm), observer)` before calling `optimize!`. The observable calls `notify(observable, status_dict)` each iteration. The status dict contains `"EVALUATIONS"`, `"POPULATION"`, and `"COMPUTING_TIME"`.

### Archives

`NonDominatedArchive` is unbounded and keeps only non-dominated solutions. `CrowdingDistanceArchive` is bounded; when full it removes the solution with lowest crowding distance.

---

## Extension patterns

### Adding a new problem

Follow the pattern in `src/problem/multiObjective/kursawe.jl`:

```julia
function myProblem()
    problem = ContinuousProblem{Float64}("MyProblem")
    addVariable(problem, Bounds{Float64}(lower, upper))  # repeat per variable
    addObjective(problem, x -> ...)                       # repeat per objective
    addConstraint(problem, x -> ...)                      # repeat per constraint (optional)
    return problem
end
```

For constrained problems use `ConstraintsAndDominanceComparator()` instead of `DefaultDominanceComparator()` in the algorithm — NSGA-II does this automatically when `numberOfConstraints(problem) > 0`.

### Adding a new quality indicator

Follow the pattern in `src/util/qualityIndicator.jl`:

```julia
struct MyIndicator <: QualityIndicator end

name(::MyIndicator) = "MY"
description(::MyIndicator) = "..."
is_minimization(::MyIndicator) = true   # or false

function compute(::MyIndicator, front::AbstractMatrix, reference_front::AbstractMatrix)
    # front rows are solutions, columns are objectives
end
```

### Adding a new algorithm

Compose an `EvolutionaryAlgorithm` with the required components in `optimize!`, then delegate:

```julia
mutable struct MyAlgorithm <: Algorithm
    solver::EvolutionaryAlgorithm
    # ... config fields
end

function optimize!(alg::MyAlgorithm)
    alg.solver.solutionsCreation = DefaultSolutionsCreation(problem, popSize)
    alg.solver.evaluation       = SequentialEvaluation(problem)
    alg.solver.termination      = alg.termination
    alg.solver.selection        = BinaryTournamentSelection(matingPoolSize, comparator)
    alg.solver.variation        = CrossoverAndMutationVariation(offspringSize, crossover, mutation)
    alg.solver.replacement      = RankingAndDensityEstimatorReplacement(ranking, densityEstimator)
    return evolutionaryAlgorithm(alg.solver)
end
```

### Registering new files

**Every new source file must be `include`d and its public symbols `export`ed in `src/MetaJul.jl`.** This is the single entry point of the package. Forgetting this step causes "not defined" errors even if the file compiles in isolation.

---

## Testing conventions

Test files mirror `src/` structure under `test/`. All tests use `@testset` / `@test` from the standard `Test` package. Helper constructors (e.g. `createContinuousSolution`) are defined in `test/runtests.jl` and are available to all included test files. New test files must be added to the appropriate list in `test/runtests.jl`.

Reference fronts for quality indicator tests live in `data/referenceFronts/` as CSV files (space-separated, no header).
