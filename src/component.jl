include("core.jl")
include("solution.jl")
include("operator.jl")
include("densityEstimator.jl")

using Base.Iterators

abstract type EAComponent end
abstract type Selection <: EAComponent end
abstract type Evaluation <: EAComponent end
abstract type Variation <: EAComponent end

"""
struct SequentialEvaluation <: Evaluation
   evaluate::Function
   function SequentialEvaluation() new(sequentialEvaluation) end
end

struct BinaryTournamentSelection <: Evaluation
  matingPoolSize::Int
  select::Function
  function BinaryTournamentSelection(matingPoolSize) 
    x = new(); 
    x.matingPoolSize = matingPoolSize; 
    x.select = binaryTournamentSelection; 
    return x 
  end
end
"""

## Solution creation components

function defaultSolutionsCreation(parameters::NamedTuple)::Vector{Solution}
  problem = parameters.problem
  numberOfSolutionsToCreate = parameters.populationSize
  [createSolution(problem) for _ in range(1, numberOfSolutionsToCreate)]
end

## Evaluation components
function sequentialEvaluation(parameters::NamedTuple)::Vector{Solution} 
  solutions::Vector{Solution} = parameters.population
  problem::Problem = parameters.problem
  return [evaluate(solution, problem) for solution in solutions]
end

## Termination components
function terminationByEvaluations(algorithmAttributes::Dict)::Bool
  return get(algorithmAttributes, "EVALUATIONS",0) >= get(algorithmAttributes, "MAX_EVALUATIONS",0)
end

## Selection components
function binaryTournamentMatingPoolSelection(solutions::Vector{Solution}, parameters::NamedTuple)::Vector{Solution}
  matingPoolSize::Int = parameters.matingPoolSize
  return [binaryTournamentSelection(solutions, (comparator = parameters.comparator,)) for _ in range(1,matingPoolSize)]
end

## Variation components
function crossoverAndMutationVariation(matingPool::Vector{Solution},
  offspringSolutionSize::Int, crossover::Function, crossoverParameters, mutation::Function, mutationParameters)

  parents = collect(zip(matingPool[1:2:end], matingPool[2:2:end]))

  crossedSolutions = [crossover(parent[1], parent[2], crossoverParameters) for parent in parents]
  solutionsToMutate = collect(flatten(crossedSolutions))
  offpring = [mutation(solutionsToMutate[i], mutationParameters) for i in range(1, offspringSolutionSize)]

  return offpring
end

## Replacement components
function muPlusLambdaReplacement(x::Vector{Solution}, y::Vector{Solution}, comparator::Function)
  jointVector = vcat(x,y)
  sort!(jointVector, lt=((a,b) -> comparator(a,b) <= 0))
  return jointVector[1:length(x)]
end


function compareRankingAndCrowdingDistance(x::Solution, y::Solution)::Int
  result = compareRanking(x, y)
  if (result == 0)
    result = compareCrowdingDistance(x,y)
  end
  return result
end

function rankingAndDensityEstimatorReplacement(x::Vector{T}, y::Vector{T}, comparator::Function = compareRankingAndCrowdingDistance)::Vector{T} where {T <: Solution}
  jointVector = vcat(x,y)
  
  ranking = computeRanking(jointVector)
  for rank in ranking.rank
    computeCrowdingDistanceEstimator!(rank)
  end

  sort!(jointVector, lt=((x,y) -> comparator(x,y) < 0))
  return jointVector[1:length(x)]
end

function rankingAndDensityEstimatorReplacementv2(x::Vector{Solution}, y::Vector{Solution}, comparator::Function = compareRankingAndCrowdingDistance)::Vector{Solution}
  jointVector = vcat(x,y)
  
  ranking = computeRanking(jointVector)

  resultSolutions = []
  remainingSolutions = length(x)
  currentRank = 1 
  while (remainingSolutions > 0)
    computeCrowdingDistanceEstimator!(getSubFront(ranking, currentRank))
    currentRankLength = length(getSubFront(ranking, currentRank))

    if currentRankLength <= remainingSolutions
      resultSolutions = vcat(resultSolutions, getSubFront(ranking, currentRank))
      remainingSolutions -= currentRankLength
      currentRank += 1
    else
      sort!(getSubFront(ranking, currentRank), lt=((x,y) -> compareCrowdingDistance(x,y) <= 0))
      resultSolutions = vcat(resultSolutions, getSubFront(ranking, currentRank)[1:remainingSolutions])
      remainingSolutions = 0
    end
  end

  return resultSolutions
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