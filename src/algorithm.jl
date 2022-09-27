include("solution.jl")
include("problem.jl")

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

function localSearch(currentSolution::ContinuousSolution{Real}, problem::ContinuousProblem{Real}, numberOfIterations::Int, mutationOperator::Function, mutationParameters)::ContinuousSolution{Real}
  for i in 1:numberOfIterations
    mutatedSolution = copySolution(currentSolution)
    mutatedSolution.variables = mutationOperator(mutatedSolution.variables, mutationParameters)
    mutatedSolution.variables = restrict(mutatedSolution.variables, problem.bounds)

    mutatedSolution = evaluate(mutatedSolution, problem)

    if (mutatedSolution.objectives[1] < currentSolution.objectives[1])
      currentSolution = mutatedSolution
    end

    println("I: ", i, ". F: ", currentSolution.objectives[1])
  end

  return currentSolution
end

#################################

"""
struct EAState{T <: Solution}
  evaluations::Int
  population::Array{T}
  #computingTime
end

abstract type CreateSolutionsData end

struct createSolutionsFromProblemData <: CreateSolutionsData
  problem::Problem
  numberOfSolutionsToCreate::Int
end

function createSolutions(data::createSolutionsFromProblemData)::Vector
  return [createSolution(data.problem) for _ in 1:data.numberOfSolutionsToCreate]
end

println()
println()

#data = createSolutionsFromProblemData(createSchafferProblem(), 5)
#println("Creating 5 solutions: ", createSolutions(data))
println()
println()


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