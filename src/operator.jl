
include("solution.jl")
include("comparator.jl")
include("ranking.jl")

# Mutation operators

function mutationProbability(mutationOperator::T)::Float64 where {T <: MutationOperator}
  return mutationOperator.parameters.probability
end

function bitFlipMutation(x::BitVector, parameters)::BitVector
  probability::Real = parameters.probability
  for i in 1:length(x)
    r = rand()
    if r < probability
      bitFlip(x, i)
    end
  end

  return x
end

function bitFlipMutation(solution::BinarySolution, parameters::NamedTuple)::BinarySolution
  solution.variables = bitFlipMutation(solution.variables, parameters)
  return solution
end

struct BitFlipMutation <: MutationOperator
  parameters::NamedTuple{(:probability, ),Tuple{Float64}} 
  execute::Function
  function BitFlipMutation(mutationParameters)
    new(mutationParameters, bitFlipMutation)
  end
end

"""
function BitFlipMutation(parameters::NamedTuple)
  return BitFlipMutation(parameters, bitFlipMutation)
end
"""

function uniformMutation(x::Vector{T}, parameters::NamedTuple)::Vector{T} where {T<:Real}
  probability::Real = parameters.probability
  perturbation::Real = parameters.perturbation
  bounds = parameters.bounds
  for i in 1:length(x)
    if rand() < probability
      x[i] += (rand() - 0.5) * perturbation
    end
  end

  x = restrict(x, bounds)
  return x
end

function uniformMutation(solution::ContinuousSolution, parameters::NamedTuple)::ContinuousSolution
  solution.variables = uniformMutation(solution.variables, parameters)
  return solution
end

struct UniformMutation <: MutationOperator
  parameters::NamedTuple{(:probability, :perturbation, :bounds),Tuple{Float64, Float64, Vector{Bounds{Float64}}}}
  execute::Function
  function UniformMutation(mutationParameters)
    new(mutationParameters, uniformMutation)
  end
end

function getPerturbation(mutation::UniformMutation)
  return mutation.parameters.perturbation
end

"""
function UniformMutation(parameters::NamedTuple)
  return UniformMutation(parameters, uniformMutation)
end
"""

function polynomialMutation(x::Vector{T}, parameters)::Vector{T} where {T<:Real}
  probability::Real = parameters.probability
  distributionIndex::Real = parameters.distributionIndex
  bounds = parameters.bounds

  for i in 1:length(x)
    if rand() <= probability
      y = x[i]
      yl = bounds[i].lowerBound
      yu = bounds[i].upperBound
      if (yl == yu)
        y = yl
      else
        delta1 = (y - yl) / (yu - yl)
        delta2 = (yu - y) / (yu - yl)
        rnd = rand()
        mutPow = 1.0 / (distributionIndex + 1.0)
        if (rnd <= 0.5)
          xy = 1.0 - delta1
          val = 2.0 * rnd + (1.0 - 2.0 * rnd) * (xy^(distributionIndex + 1.0))
          deltaq = (val^mutPow) - 1.0
        else
          xy = 1.0 - delta2
          val = 2.0 * (1.0 - rnd) + 2.0 * (rnd - 0.5) * (xy^(distributionIndex + 1.0))
          deltaq = 1.0 - (val^mutPow)
        end
        y = y + deltaq * (yu - yl)
      end
      x[i] = y
    end
  end
  x = restrict(x, bounds)
  return x
end

function polynomialMutation(solution::ContinuousSolution, parameters)::ContinuousSolution
  solution.variables = polynomialMutation(solution.variables, parameters)
  return solution
end

struct PolynomialMutation <: MutationOperator
  parameters::NamedTuple{(:probability, :distributionIndex, :bounds),Tuple{Float64, Float64,Vector{Bounds{Float64}}}} 
  execute::Function
  function PolynomialMutation(crossoverParameters)
    new(crossoverParameters, polynomialMutation)
  end
end

function getDistributionIndex(mutation::PolynomialMutation)
  return mutation.parameters.distributionIndex
end

"""
function PolinomialMutation(parameters::NamedTuple)
  return PolinomialMutation(parameters, polynomialMutation)
end
"""

# Crossover operators
function crossoverProbability(crossoverOperator::T)::Float64 where {T <: CrossoverOperator}
  return crossoverOperator.parameters.probability
end

function numberOfRequiredParents(crossoverOperator::T)::Float64 where {T <: CrossoverOperator}
  return crossoverOperator.numberOfRequiredParents
end

function numberOfDescendants(crossoverOperator::T)::Float64 where {T <: CrossoverOperator}
  return crossoverOperator.numberOfDescendants
end

function blxAlphaCrossover(parent1::ContinuousSolution, parent2::ContinuousSolution, parameters::NamedTuple)::Vector{ContinuousSolution}
  probability::Real = parameters.probability
  alpha::Real = parameters.alpha
  bounds = parameters.bounds

  child1 = copySolution(parent1)
  child2 = copySolution(parent2)

  if rand() < probability
    for i in range(1, length(parent1.variables))
      minValue = min(parent1.variables[i], parent2.variables[i])
      maxValue = max(parent1.variables[i], parent2.variables[i])
      range = maxValue - minValue

      minRange = minValue - range * alpha
      maxRange = maxValue + range * alpha

      random = rand()
      child1.variables[i] = minRange + random * (maxRange - minRange)
      random = rand()
      child2.variables[i] = minRange + random * (maxRange - minRange)
    end
  end

  child1.variables = restrict(child1.variables, bounds)
  child2.variables = restrict(child2.variables, bounds)

  return [child1, child2]
end

struct BLXAlphaCrossover <: CrossoverOperator
  parameters::NamedTuple{(:probability, :alpha, :bounds), Tuple{Float64, Float64, Vector{Bounds{Float64}}}} 
  numberOfRequiredParents::Int
  numberOfDescendants::Int
  execute::Function
  function BLXAlphaCrossover(crossoverParameters)
    new(crossoverParameters, 2, 2, blxAlphaCrossover)
  end
end

"""
function BLXAlphaCrossover(parameters::NamedTuple)
  return BLXAlphaCrossover(parameters, 2, 2, blxAlphaCrossover)
end
"""

"""
    sbxCrossover(parent1::ContinuousSolution, parent2::ContinuousSolution, parameters::NamedTuple)::Vector{ContinuousSolution}

Simulated binary crossover operator
"""

function sbxCrossover(parent1::ContinuousSolution, parent2::ContinuousSolution, parameters::NamedTuple)::Vector{ContinuousSolution}
  EPSILON = 1.0e-14
  probability::Real = parameters.probability
  distributionIndex::Real = parameters.distributionIndex
  bounds = parameters.bounds

  child1 = copySolution(parent1)
  child2 = copySolution(parent2)

  if rand() <= probability  
    for i in range(1, length(parent1.variables))
      x1 = parent1.variables[i]
      x2 = parent2.variables[i]

      y1 = 0.0
      y2 = 0.0
      if (rand() <= 0.5)
        if (abs(x1 - x2) > EPSILON)
          if (x1 < x2)
            y1 = x1
            y2 = x2
          else
            y1 = x2
            y2 = x1
          end

          random = rand()
          beta = 1.0 + (2.0 * (y1 - bounds[i].lowerBound) / (y2 - y1))
          alpha = 2.0 - ^(beta, -(distributionIndex + 1.0))
        
          betaq = 0.0
          if random <= (1.0 / alpha)
            betaq = ^(random * alpha, (1.0 / distributionIndex + 1.0))
          else
            betaq = ^(1.0 / (2.0 - random * alpha), 1.0 / (distributionIndex + 1.0))
          end
          c1 = 0.5 * (y1 + y2 - betaq * (y2 - y1))

          beta = 1.0 + (2.0 * (bounds[i].upperBound - y2) / (y2 - y1))
          alpha = 2.0 - ^(beta, -(distributionIndex + 1.0))

          if random <= (1.0 / alpha)
            betaq = ^(random * alpha, (1.0 / distributionIndex + 1.0))
          else
            betaq = ^(1.0 / (2.0 - random * alpha), 1.0 / (distributionIndex + 1.0))
          end
          c2 = 0.5 * (y1 + y2 - betaq * (y2 - y1))

          c1 = restrict(c1, bounds[i])
          c2 = restrict(c2, bounds[i])

          if rand() <= 0.5
            child1.variables[i] = c2
            child2.variables[i] = c1
          else
            child1.variables[i] = c1
            child2.variables[i] = c2
          end
        else
          child1.variables[i] = x1
          child2.variables[i] = x2
        end
      else
        child1.variables[i] = x2
        child2.variables[i] = x1
      end
    end
  end

  return [child1, child2]
end


struct SBXCrossover <: CrossoverOperator
  parameters::NamedTuple{(:probability, :distributionIndex, :bounds), Tuple{Float64, Float64, Vector{Bounds{Float64}}}} 
  numberOfRequiredParents::Int
  numberOfDescendants::Int
  execute::Function
  function SBXCrossover(crossoverParameters)
    new(crossoverParameters, 2, 2, sbxCrossover)
  end
end

#function SBXCrossover(parameters::NamedTuple)
#  return SBXCrossover(parameters, 2, 2, sbxCrossover)
#end

"""
sol1 = ContinuousSolution{Float64}([1.0, 2.0], [1.5, 2.5], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
sol2 = ContinuousSolution{Float64}([2.0, 3.0], [1.5, 2.5], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

crossoverParameters = (probability = 1.0, distributionIndex = 20.0, bounds =[Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
crossover = SBXCrossover(crossoverParameters)
println("Crossover: " , crossover)

childs = crossover.compute(sol1, sol2, crossover.parameters)
println("CHILDS: ", childs)
"""

function singlePointCrossover(parent1::BinarySolution, parent2::BinarySolution, parameters::NamedTuple)::Vector{BinarySolution}
  @assert length(parent1.variables) == length(parent2.variables) "The length of the two binary solutions to recombine is not equal"

  probability::Real = parameters.probability

  child1 = copySolution(parent1)
  child2 = copySolution(parent2)

  x = child1.variables
  y = child2.variables
  if rand() < parameters.probability
    cuttingPoint = rand(1:length(x))

    tmp = x.bits[cuttingPoint:end]
    x.bits[cuttingPoint:end] = y.bits[cuttingPoint:end]
    y.bits[cuttingPoint:end] = tmp
  end

  child1.variables = x
  child2.variables = y

  return [child1, child2]
end

struct SinglePointCrossover <: CrossoverOperator
  parameters::NamedTuple{(:probability,),Tuple{Float64}} 
  numberOfRequiredParents::Int
  numberOfDescendants::Int
  execute::Function
  function SinglePointCrossover(crossoverParameters)
    new(crossoverParameters, 2, 2, singlePointCrossover)
  end
end

"""
function SPXCrossover(parameters::NamedTuple)
  return SBXCrossover(parameters, 2, 2, singlePointCrossover)
end
"""

# Selection operators
function randomSelection(x::Vector, parameters=[])
  return x[rand(1:length(x))]
end

struct RandomSelectionOperator <: SelectionOperator
  parameters::NamedTuple
  compute::Function
  function RandomSelection(parameters)
    new(parameters, randomSelection)
  end
end


function binaryTournamentSelection(x::Vector{S}, parameters::NamedTuple{(:comparator,), Tuple{Function}}) where {S <: Solution}
  comparator = parameters.comparator
  index1 = rand(1:length(x))
  index2 = rand(1:length(x))

  if comparator(x[index1], x[index2]) < 0
    result = x[index1]
  else
    result = x[index2]
  end

  return result
end

struct BinaryTournamentSelectionOperator <: SelectionOperator
  parameters::NamedTuple{(:comparator,), Tuple{Function}}
  compute::Function
  function BinaryTournamentSelectionOperator(parameters)
    new(parameters, binaryTournamentSelection)
  end
end

