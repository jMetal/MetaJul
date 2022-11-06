include("core.jl")
include("solution.jl")
include("observer.jl")

abstract type Metaheuristic end

###################################

mutable struct LocalSearch <: Metaheuristic
  startingSolution::Solution
  problem::Problem
  numberOfIterations::Int
  mutation::Function
  mutationParameters::NamedTuple
  foundSolution::Solution

  LocalSearch() = new()
end

function optimize(algorithm :: LocalSearch)
  algorithm.foundSolution = localSearch(algorithm.startingSolution, algorithm.problem,
  algorithm.numberOfIterations, algorithm.mutation, algorithm.mutationParameters)
  
  return Nothing
end

function localSearch(currentSolution::Solution, problem::Problem, numberOfIterations::Int, mutationOperator::Function, mutationParameters)::Solution
  for i in 1:numberOfIterations
    mutatedSolution = copySolution(currentSolution)
    mutatedSolution.variables = mutationOperator(mutatedSolution.variables, mutationParameters)
    
    mutatedSolution = evaluate(mutatedSolution, problem)

    if (mutatedSolution.objectives[1] < currentSolution.objectives[1])
      currentSolution = mutatedSolution
    end
  end

  return currentSolution
end

#################################

mutable struct EvolutionaryAlgorithm <: Metaheuristic
  name::String
  problem::Problem
  populationSize::Int
  offspringPopulationSize::Int

  foundSolutions::Vector

  solutionsCreation::SolutionsCreation
  evaluation::Evaluation
  termination::Termination
  selection::Selection
  variation::Variation
  replacement::Replacement

  observable::Observable

  function EvolutionaryAlgorithm() 
    x = new()
    x.name = "EA"
    x.observable = Observable("EA observable")
    return return x
  end
end

function getObservable(algorithm::EvolutionaryAlgorithm)
  return algorithm.observable
end

function evolutionaryAlgorithm(ea::EvolutionaryAlgorithm)
  population = ea.solutionsCreation.create(ea.solutionsCreation.parameters)
  population = ea.evaluation.evaluate(population, ea.evaluation.parameters)

  evaluations = length(population)
  eaStatus = Dict("EVALUATIONS" => evaluations, "POPULATION" => population)

  notify(ea.observable, eaStatus)

  while !ea.termination.isMet(eaStatus, ea.termination.parameters)
    matingPool = ea.selection.select(population, ea.selection.parameters)
    
    offspringPopulation = ea.variation.variate(population, matingPool, ea.variation.parameters)
    offspringPopulation = ea.evaluation.evaluate(offspringPopulation, ea.evaluation.parameters)

    population = ea.replacement.replace(population, offspringPopulation, ea.replacement.parameters)

    evaluations += length(offspringPopulation)
    eaStatus["EVALUATIONS"] = evaluations
    eaStatus["POPULATION"] = population

    notify(ea.observable, eaStatus)
  end

  foundSolutions = population
  return foundSolutions
end

function optimize(algorithm::EvolutionaryAlgorithm)
  algorithm.foundSolutions = evolutionaryAlgorithm(algorithm)
  
  return Nothing
end

function name(algorithm::EvolutionaryAlgorithm)
  return algorithm.name
end


#################################

mutable struct NSGAII <: Metaheuristic
  problem::Problem
  populationSize::Int
  numberOfEvaluations::Int

  foundSolutions::Vector

  termination::Termination
  mutation::MutationOperator
  crossover::CrossoverOperator

  solver::EvolutionaryAlgorithm

  function NSGAII() 
    algorithm = new()
    algorithm.solver = EvolutionaryAlgorithm()
    algorithm.solver.name = "NSGA-II"
    return algorithm
  end
end

function nsgaII(nsgaII::NSGAII) 
  solver = nsgaII.solver 
  
  solver.problem = nsgaII.problem
  solver.populationSize = nsgaII.populationSize
  solver.offspringPopulationSize = nsgaII.populationSize

  solver.solutionsCreation = DefaultSolutionsCreation((problem = solver.problem, numberOfSolutionsToCreate = solver.populationSize))

  solver.evaluation = SequentialEvaluation((problem = solver.problem, ))

  solver.termination = nsgaII.termination
  solver.variation = CrossoverAndMutationVariation((offspringPopulationSize = solver.offspringPopulationSize, crossover = nsgaII.crossover, mutation = nsgaII.mutation))

  solver.replacement = solver.replacement = RankingAndDensityEstimatorReplacement((comparator = compareRankingAndCrowdingDistance, ))

  solver.selection = BinaryTournamentSelection((matingPoolSize = solver.variation.matingPoolSize, comparator = compareRankingAndCrowdingDistance))

  return evolutionaryAlgorithm(solver)
end

function optimize(algorithm::NSGAII)
  algorithm.foundSolutions = nsgaII(algorithm)
  
  return Nothing
end

function name(nsgaII::NSGAII)
  return name(nsgaII.solver)
end

function getObservable(nsgaII::NSGAII)
  return getObservable(nsgaII.solver)
end