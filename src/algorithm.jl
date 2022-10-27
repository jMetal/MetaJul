include("core.jl")
include("solution.jl")

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
  problem::Problem
  populationSize::Int
  offspringPopulationSize::Int

  foundSolutions::Vector

  solutionsCreation::Function
  evaluation::Function
  termination::Function
  selection::Function
  variation::Function
  replacement::Function

  solutionsCreationParameters::NamedTuple
  evaluationParameters::NamedTuple
  terminationParameters::NamedTuple
  selectionParameters::NamedTuple
  variationParameters::NamedTuple
  replacementParameters::NamedTuple

  EvolutionaryAlgorithm() = new()
end

function evolutionaryAlgorithm(ea::EvolutionaryAlgorithm)
  population = ea.solutionsCreation(ea.solutionsCreationParameters)
  population = ea.evaluation(population, ea.evaluationParameters)

  evaluations = length(population)
  eaStatus = Dict("EVALUATIONS" => evaluations, "POPULATION" => population)

  while !ea.termination(eaStatus, ea.terminationParameters)
    matingPool = ea.selection(population, ea.selectionParameters)
    
    offspringPopulation = ea.variation(population, matingPool, ea.variationParameters)
    offspringPopulation = ea.evaluation(offspringPopulation, ea.evaluationParameters)

    population = ea.replacement(population, offspringPopulation, ea.replacementParameters)

    evaluations += length(offspringPopulation)
    eaStatus["EVALUATIONS"] = evaluations
    eaStatus["POPULATION"] = population
  end

  foundSolutions = population
  return foundSolutions
end

function optimize(algorithm::EvolutionaryAlgorithm)
  algorithm.foundSolutions = evolutionaryAlgorithm(algorithm)
  
  return Nothing
end


#################################

mutable struct NSGAII <: Metaheuristic
  problem::Problem
  populationSize::Int
  numberOfEvaluations::Int

  foundSolutions::Vector

  solutionsCreation::Function
  evaluation::Function
  termination::Function
  selection::Function

  mutation::MutationOperator
  crossover::CrossoverOperator

  solutionsCreationParameters::NamedTuple
  evaluationParameters::NamedTuple
  terminationParameters::NamedTuple
  selectionParameters::NamedTuple

  NSGAII() = new()
end

function NSGAII(nsgaII::NSGAII) 
  solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
  solver.problem = nsgaII.problem
  solver.populationSize = nsgaII.populationSize
  solver.offspringPopulationSize = nsgaII.populationSize

  solver.solutionsCreation = nsgaII.solutionsCreation
  solver.solutionsCreationParameters = nsgaII.solutionsCreationParameters

  solver.evaluation = nsgaII.evaluation
  solver.evaluationParameters = nsgaII.evaluationParameters

  solver.termination = nsgaII.termination
  solver.terminationParameters = nsgaII.terminationParameters

  solver.selection = nsgaII.selection
  solver.selectionParameters = nsgaII.selectionParameters

  solver.variation = crossoverAndMutationVariation
  solver.variationParameters = (offspringPopulationSize = solver.offspringPopulationSize, mutation = nsgaII.mutation,
  crossover = nsgaII.crossover)

  solver.replacement = rankingAndDensityEstimatorReplacement
  solver.replacementParameters = (comparator = compareRankingAndCrowdingDistance, )

  return evolutionaryAlgorithm(solver)
end

function optimize(algorithm::NSGAII)
  algorithm.foundSolutions = NSGAII(algorithm)
  
  return Nothing
end

