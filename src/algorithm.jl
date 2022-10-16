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
  numberOfEvaluations::Int

  foundSolutions::Vector{Solution}

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

function evolutionaryAlgorithm(ea::EvolutionaryAlgorithm, solutionsCreation::Function, evaluation::Function, terminationCondition::Function, selection::Function, variation::Function, replacement::Function)
  population = solutionsCreation(ea.solutionsCreationParameters)
  population = evaluation(population, ea.evaluationParameters)

  evaluations = length(population)
  eaStatus = Dict("EVALUATIONS" => evaluations, "POPULATION" => population)

  while !terminationCondition(eaStatus, ea.terminationParameters)
    matingPool = selection(population, ea.selectionParameters)
    
    offspringPopulation = variation(population, matingPool, ea.variationParameters)
    offspringPopulation = evaluation(offspringPopulation, ea.evaluationParameters)

    population = replacement(population, offspringPopulation, ea.replacementParameters)
    
    evaluations += length(offspringPopulation)
    eaStatus["EVALUATIONS"] = evaluations
    eaStatus["POPULATION"] = population
  end

  foundSolutions = population
  return foundSolutions
end

function optimize(algorithm::EvolutionaryAlgorithm)
  algorithm.foundSolutions = evolutionaryAlgorithm(algorithm, algorithm.solutionsCreation, algorithm.evaluation, algorithm.termination, algorithm.selection, algorithm.variation, algorithm.replacement)
  
  return Nothing
end


mutable struct GeneticAlgorithm <: Metaheuristic
  problem::Problem
  populationSize::Int
  offspringPopulationSize::Int
  numberOfEvaluations::Int

  foundSolutions::Vector{Solution}

  solutionsCreation::Function

  evaluation::Function

  variation::Function
  crossover::Function
  crossoverParameters::NamedTuple
  mutation::Function
  mutationParameters::NamedTuple

  termination::Function

  selection::Function
  selectionParameters::NamedTuple

  replacement::Function
  replacementComparator::Function

  GeneticAlgorithm() = new()
end

function geneticAlgorithm(ga::GeneticAlgorithm, solutionsCreation::Function, evaluation::Function, terminationCondition::Function, selection::Function, variation::Function, replacement::Function)
  population = solutionsCreation((problem = ga.problem, populationSize = ga.populationSize))
  population = evaluation((population = population, problem = ga.problem))

  evaluations = length(population)
  eaStatus = Dict("EVALUATIONS" => evaluations, "MAX_EVALUATIONS" => ga.numberOfEvaluations)

  while !terminationCondition(eaStatus)
    matingPool = selection(population, ga.selectionParameters)
    
    offspringPopulation = variation(matingPool, ga.offspringPopulationSize, ga.crossover, ga.crossoverParameters, ga.mutation, ga.mutationParameters)
    offspringPopulation = evaluation((population = offspringPopulation, problem = ga.problem))

    population = replacement(population, offspringPopulation, ga.replacementComparator)
    
    evaluations += length(offspringPopulation)
    eaStatus["EVALUATIONS"] = evaluations
  end

  foundSolutions = population
  return foundSolutions
end

function optimize(algorithm::GeneticAlgorithm)
  algorithm.foundSolutions = geneticAlgorithm(algorithm, algorithm.solutionsCreation, algorithm.evaluation, algorithm.termination, algorithm.selection, algorithm.variation, algorithm.replacement)
  
  return Nothing
end
