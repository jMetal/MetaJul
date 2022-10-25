include("core.jl")
include("solution.jl")
include("operator.jl")
include("densityEstimator.jl")

using Base.Iterators
using Random

## Solution creation components

function defaultSolutionsCreation(parameters::NamedTuple)::Vector{Solution}
  problem = parameters.problem
  numberOfSolutionsToCreate = parameters.numberOfSolutionsToCreate
  [createSolution(problem) for _ in range(1, numberOfSolutionsToCreate)]
end

## Evaluation components
function sequentialEvaluation(solutions::Vector{Solution}, parameters::NamedTuple)::Vector{Solution} 
  problem::Problem = parameters.problem
  return [evaluate(solution, problem) for solution in solutions]
end

function sequentialEvaluationWithArchive(solutions::Vector{Solution}, parameters::NamedTuple)::Vector{Solution} 
  archive = parameters.archive
  problem::Problem = parameters.problem
  for solution in solutions
    evaluate(solution, problem) 
    add!(archive, solution)
  end
  return solutions
end

## Termination components
function terminationByEvaluations(algorithmAttributes::Dict, parameters::NamedTuple)::Bool
  return get(algorithmAttributes, "EVALUATIONS",0) >= parameters.numberOfEvaluationToStop
end

## Selection components
function binaryTournamentMatingPoolSelection(solutions::Vector{Solution}, parameters::NamedTuple)::Vector{Solution}
  matingPoolSize::Int = parameters.matingPoolSize
  return [binaryTournamentSelection(solutions, (comparator = parameters.comparator,)) for _ in range(1,matingPoolSize)]
end

function randomMatingPoolSelection(solutions::Vector{T}, parameters::NamedTuple)::Vector{T} where {T <: Solution}
  matingPoolSize::Int = parameters.matingPoolSize
  withReplacement::Bool = parameters.withReplacement
  if withReplacement
    result = [solutions[rand(1:length(solutions))] for _ in range(1,matingPoolSize)]

    return result
  else
    @assert matingPoolSize <= length(solutions) string("The mating pool size ", matingPoolSize, " is higher than the population size ", length(solutions))
    result = [solutions[i] for i in randperm(length(solutions))[1:matingPoolSize]]
    
    return result
  end
end

## Variation components
function crossoverAndMutationVariation(solutions::Vector{Solution}, matingPool::Vector{Solution}, parameters::NamedTuple)::Vector{Solution}
  parents = collect(zip(matingPool[1:2:end], matingPool[2:2:end]))

  crossedSolutions = [parameters.crossover(parent[1], parent[2], parameters.crossoverParameters) for parent in parents]
  solutionsToMutate = collect(flatten(crossedSolutions))
  offpring = [parameters.mutation(solutionsToMutate[i], parameters.mutationParameters) for i in range(1, parameters.offspringPopulationSize)]

  return offpring
end

## Replacement components
function muPlusLambdaReplacement(x::Vector{Solution}, y::Vector{Solution}, parameters::NamedTuple)
  jointVector = vcat(x,y)
  sort!(jointVector, lt=((a,b) -> parameters.comparator(a,b) <= 0))
  return jointVector[1:length(x)]
end


function compareRankingAndCrowdingDistance(x::Solution, y::Solution)::Int
  result = compareRanking(x, y)
  if (result == 0)
    result = compareCrowdingDistance(x,y)
  end
  return result
end

function rankingAndDensityEstimatorReplacement(x::Vector{T}, y::Vector{T}, 
  parameters::NamedTuple)::Vector{T} where {T <: Solution}
  jointVector = vcat(x,y)
  
  ranking = computeRanking(jointVector)
  for rank in ranking.rank
    computeCrowdingDistanceEstimator!(rank)
  end

  sort!(jointVector, lt=((x,y) -> parameters.comparator(x,y) < 0))
  return jointVector[1:length(x)]
end

