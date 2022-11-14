include("core.jl")
include("solution.jl")
include("operator.jl")
include("densityEstimator.jl")

using Base.Iterators
using Random

## Solution creation components

function defaultSolutionsCreation(parameters::NamedTuple{(:problem, :numberOfSolutionsToCreate), Tuple{Problem, Int64}})::Vector{Solution} 
  problem = parameters.problem
  numberOfSolutionsToCreate = parameters.numberOfSolutionsToCreate
  [createSolution(problem) for _ in range(1, numberOfSolutionsToCreate)]
end

struct DefaultSolutionsCreation <: SolutionsCreation
  parameters::NamedTuple{(:problem, :numberOfSolutionsToCreate), Tuple{Problem, Int64}} 
  create::Function

  function DefaultSolutionsCreation(parameters)
    return new(parameters, defaultSolutionsCreation)
  end
end

## Evaluation components
function sequentialEvaluation(solutions::Vector{S}, parameters::NamedTuple{(:problem, ), Tuple{P}})::Vector{Solution} where {S <: Solution, P <: Problem}
  problem::Problem = parameters.problem
  return [evaluate(solution, problem) for solution in solutions]
end

struct SequentialEvaluation <: Evaluation
  parameters::NamedTuple{(:problem, ), Tuple{Problem}} 

  evaluate::Function
  function SequentialEvaluation(parameters)
    return new(parameters, sequentialEvaluation)
  end
end

function sequentialEvaluationWithArchive(solutions::Vector{S}, parameters::NamedTuple{(:archive, :problem), Tuple{A, P}})::Vector{S} where {S <: Solution, A <: Archive, P <:Problem}
  archive = parameters.archive
  problem::Problem = parameters.problem
  for solution in solutions
    evaluate(solution, problem) 
    add!(archive, solution)
  end
  return solutions
end

struct SequentialEvaluationWithArchive <: Evaluation
  parameters::NamedTuple{(:archive, :problem), Tuple{Archive, Problem}} 

  evaluate::Function
  function SequentialEvaluationWithArchive(parameters)
    return new(parameters, sequentialEvaluationWithArchive)
  end
end

## Termination components
function terminationByEvaluations(algorithmAttributes::Dict, parameters::NamedTuple)::Bool
  return get(algorithmAttributes, "EVALUATIONS",0) >= parameters.numberOfEvaluationsToStop
end

struct TerminationByEvaluations <: Termination
  parameters::NamedTuple{(:numberOfEvaluationsToStop,), Tuple{Int}} 

  isMet::Function
  function TerminationByEvaluations(parameters)
    return new(parameters, terminationByEvaluations)
  end
end

function terminationByComputingTime(algorithmAttributes::Dict, parameters::NamedTuple)::Bool
  return get(algorithmAttributes, "COMPUTING_TIME",0) >= parameters.computingTime
end

struct TerminationByComputingTime <: Termination
  parameters::NamedTuple

  isMet::Function
  function TerminationByComputingTime(parameters)
    return new(parameters, terminationByComputingTime)
  end
end

## Selection components
function binaryTournamentMatingPoolSelection(solutions::Vector{S}, parameters::NamedTuple{(:matingPoolSize, :comparator), Tuple{Int, Function}})::Vector{S} where {S <: Solution}
  matingPoolSize::Int = parameters.matingPoolSize
  selectionOperator = BinaryTournamentSelectionOperator((comparator = parameters.comparator,))
  return [selectionOperator.compute(solutions, selectionOperator.parameters) for _ in range(1,matingPoolSize)]
end

struct BinaryTournamentSelection <: Selection
  parameters::NamedTuple{(:matingPoolSize, :comparator), Tuple{Int, Function}} 

  select::Function
  function BinaryTournamentSelection(parameters)
    return new(parameters, binaryTournamentMatingPoolSelection)
  end
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

struct RandomSelection <: Selection
  parameters::NamedTuple{(:matingPoolSize, :withReplacement), Tuple{Int, Bool}} 

  select::Function
  function RandomSelection(parameters)
    return new(parameters, randomMatingPoolSelection)
  end
end

## Variation components
function crossoverAndMutationVariation(solutions::Vector{Solution}, matingPool::Vector{Solution}, parameters::NamedTuple{(:offspringPopulationSize, :crossover, :mutation), Tuple{Int, C, M}})::Vector{Solution} where {C <: CrossoverOperator, M <: MutationOperator}
  parents = collect(zip(matingPool[1:2:end], matingPool[2:2:end]))

  crossover = parameters.crossover
  mutation = parameters.mutation
  offspringPopulationSize = parameters.offspringPopulationSize

  crossedSolutions = [crossover.execute(parent[1], parent[2], crossover.parameters) for parent in parents]
  solutionsToMutate = collect(flatten(crossedSolutions))
  offpring = [mutation.execute(solutionsToMutate[i], mutation.parameters) for i in range(1, offspringPopulationSize)]

  return offpring
end

struct CrossoverAndMutationVariation <: Variation
  parameters::NamedTuple{(:offspringPopulationSize, :crossover, :mutation), Tuple{Int, CrossoverOperator, MutationOperator}}
  matingPoolSize::Int

  variate::Function
  function CrossoverAndMutationVariation(parameters)
    offspringPopulationSize = parameters.offspringPopulationSize
    crossover = parameters.crossover

    matingPoolSize = offspringPopulationSize * numberOfRequiredParents(crossover) / numberOfDescendants(crossover)

    remainder = matingPoolSize % numberOfRequiredParents(crossover)
    if remainder != 0 
      matingPoolSize += remainder
    end

    return new(parameters, matingPoolSize, crossoverAndMutationVariation)
  end
end


## Replacement components
function muPlusLambdaReplacement(x::Vector{Solution}, y::Vector{Solution}, parameters::NamedTuple{(:comparator,), Tuple{Function}})
  jointVector = vcat(x,y)
  sort!(jointVector, lt=((a,b) -> parameters.comparator(a,b) <= 0))
  return jointVector[1:length(x)]
end

struct MuPlusLambdaReplacement <: Replacement
  parameters::NamedTuple{(:comparator, ), Tuple{Function}}

  replace::Function
  function MuPlusLambdaReplacement(parameters)
    return new(parameters, muPlusLambdaReplacement)
  end
end

function compareRankingAndCrowdingDistance(x::Solution, y::Solution)::Int
  result = compareRanking(x, y)
  if (result == 0)
    result = compareCrowdingDistance(x,y)
  end
  return result
end

function rankingAndDensityEstimatorReplacement(x::Vector{T}, y::Vector{T}, 
  parameters::NamedTuple{(:dominanceComparator,), Tuple{Function}})::Vector{T} where {T <: Solution}
  jointVector = vcat(x,y)
  
  ranking = Ranking{T}(parameters.dominanceComparator)
  computeRanking!(ranking, jointVector)

  for rank in ranking.rank
    computeCrowdingDistanceEstimator!(rank)
  end

  sort!(jointVector, lt=((x,y) -> compareRankingAndCrowdingDistance(x,y) < 0))
  return jointVector[1:length(x)]
end

struct RankingAndDensityEstimatorReplacement <: Replacement
  parameters::NamedTuple{(:dominanceComparator,), Tuple{Function}}

  replace::Function
  function RankingAndDensityEstimatorReplacement(parameters)
    return new(parameters, rankingAndDensityEstimatorReplacement)
  end
end

