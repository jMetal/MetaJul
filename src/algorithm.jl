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
mutable struct GeneticAlgorithm <: Metaheuristic
  problem::Problem
  populationSize::Int
  offspringPopulationSize::Int
  numberOfEvaluations::Int
  crossover::Function
  crossoverParameters::NamedTuple
  mutation::Function
  mutationParameters::NamedTuple
  foundSolutions::Vector{Solution}
  termination::Function
  matingPoolSize::Int
  selectionComparator::Function


  GeneticAlgorithm() = new()
end

function geneticAlgorithm(ga::GeneticAlgorithm, solutionsCreation::Function, evaluation::Function, terminationCondition::Function, selection::Function)
  #,  selection::Function, variation::Function, replacement::Function)
  println("START of algorithm")

  population = solutionsCreation((problem = ga.problem, populationSize = ga.populationSize))
  population = evaluation((population = population, problem = ga.problem))

  eaStatus = Dict("EVALUATIONS" => ga.populationSize, "MAX_EVALUATIONS" => ga.numberOfEvaluations)

  while !terminationCondition(eaStatus)
    matingPool = selection((population = population, matingPoolSize = 100)
  end

  foundSolutions = population
  return foundSolutions
end

function optimize(algorithm :: GeneticAlgorithm)
  algorithm.foundSolutions = geneticAlgorithm(algorithm, defaultSolutionsCreation, sequentialEvaluation, algorithm.termination, binaryTournamentSelection)
  
  return Nothing
end

"""
struct EvolutionaryAlgorithmAState{T <: Solution}
  evaluations::Int
  population::Array{T}
end


function evolutionaryAlgorithm(solutionsCreation::Function, evaluation::Function, termination::Function, selection::Function, variation::Function, replacement::Function)
  println("START of algorithm")
  
  population::Array{} = solutionsCreation()
  population = evaluation(population)
  initProgress() 
  while !termination()
    matingPopulation = selection(population)
    offspringPopulation = variation(population, matingPopulation)
    offspringPopulation = evaluation(offspringPopulation)

    population = replacement(population, offspringPopulation)
    updateProgress()
  end
  
  println("END of algorithm")
  return population

end

function initProgress()
  println("Init Progress")
end

function updateProgress()
  println("Update progress")
end

function solutionsCreation() 
  println("Solution creation")
  return [1,2,3,4]
end

function evaluation(population) 
  println("Evaluation")
  return [1,2,3,4]
end

function termination()
  println("Termination")

  return true 
end

function selection(population) 
  println("Selection")
  return population 
end

function variation(population, b) 
  println("Variation")
  return population 
end

function replacement(population, b) 
  println("Replacement")
  return population 
end

#evolutionaryAlgorithm(solutionsCreation, evaluation, termination, selection, variation, replacement)


"""