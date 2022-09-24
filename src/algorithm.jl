include("solution.jl")
include("problem.jl")

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

data = createSolutionsFromProblemData(createSchafferProblem(), 5)
println("Creating 5 solutions: ", createSolutions(data))
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

evolutionaryAlgorithm(solutionsCreation, evaluation, termination, selection, variation, replacement)