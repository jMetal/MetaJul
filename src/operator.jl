
include("solution.jl")
include("comparator.jl")
include("ranking.jl")

# Mutation operators
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

function bitFlipMutation(solution::BinarySolution, parameters)::BinarySolution
  solution.variables = bitFlipMutation(solution.variables, parameters)
  return solution
end


function uniformMutation(x::Vector{T}, parameters)::Vector{T} where {T <: Real}
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

function uniformMutation(solution::ContinuousSolution, parameters)::ContinuousSolution
  solution.variables = uniformMutation(solution.variables, parameters)
  return solution
end


function polynomialMutation(x::Vector{T}, parameters)::Vector{T} where {T <: Real}
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
          delta1 = (y - yl) / (yu - yl);
          delta2 = (yu - y) / (yu - yl);
          rnd = rand()
          mutPow = 1.0 / (distributionIndex + 1.0)
          if (rnd <= 0.5) 
            xy = 1.0 - delta1
            val = 2.0 * rnd + (1.0 - 2.0 * rnd) * (xy^ (distributionIndex + 1.0))
            deltaq = (val ^ mutPow) - 1.0
          else 
            xy = 1.0 - delta2
            val = 2.0 * (1.0 - rnd) + 2.0 * (rnd - 0.5) * (xy ^ (distributionIndex + 1.0))
            deltaq = 1.0 - (val ^ mutPow)
          end
          y = y + deltaq * (yu - yl)
        end
        x[i] = y
      end
  end
  x = randomRestrict(x, bounds)
  return x
end

function polynomialMutation(solution::ContinuousSolution, parameters)::ContinuousSolution
  solution.variables = polynomialMutation(solution.variables, parameters)
  return solution
end

# Crossover operators
function blxAlphaCrossover(parent1::Vector{T}, parent2::Vector{T}, parameters)::Vector{Vector{T}} where {T <: Real}
  probability::Real = parameters.probability
  alpha::Real = parameters.alpha
  bounds = parameters.bounds

  child1 = deepcopy(parent1)
  child2 = deepcopy(parent2)

  if rand() < probability
    for i in range(1,length(parent1))
      minValue = min(parent1[i], parent2[i])
      maxValue = max(parent1[i], parent2[i])
      range = maxValue - minValue

      minRange = minValue - range * alpha
      maxRange = maxValue + range * alpha

      random = rand()
      child1[i] = minRange + random * (maxRange - minRange)
      random = rand()
      child2[i] = minRange + random * (maxRange - minRange)
    end
  end
  
  child1 = restrict(child1, bounds)
  child2 = restrict(child2, bounds)

  return [child1, child2]
end

function blxAlphaCrossover(solution1::ContinuousSolution, solution2::ContinuousSolution, parameters::NamedTuple)::Vector{ContinuousSolution}
  child1 = copySolution(solution1)
  child2 = copySolution(solution2)

  child1.variables, child2.variables = blxAlphaCrossover(child1.variables, child2.variables, parameters)

  return [child1, child2]
end

function singlePointCrossover(x::BitVector, y::BitVector, parameters::NamedTuple)::Vector{BitVector}
  @assert length(x) == length(y) "The length of the two vectors to recombine is not equal"

  probability::Real = parameters.probability
  child1 = deepcopy(x)
  child2 = deepcopy(y)

  if rand() < parameters.probability
    cuttingPoint = rand(1:length(x))

    tmp = child1.bits[cuttingPoint:end] 
    child1.bits[cuttingPoint:end] = child2.bits[cuttingPoint:end]
    child2.bits[cuttingPoint:end] = tmp
  end

  return [child1, child2]
end

function singlePointCrossover(solution1::BinarySolution, solution2::BinarySolution, parameters::NamedTuple)::Vector{BinarySolution}
  child1 = copySolution(solution1)
  child2 = copySolution(solution2)

  child1.variables, child2.variables = singlePointCrossover(child1.variables, child2.variables, parameters)

  return [child1, child2]
end


# Selection operators
function randomSelection(x::Vector, parameters = [])
  return x[rand(1:length(x))]
end

function binaryTournamentSelection(x::Vector{Solution}, parameters::NamedTuple)
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

# Replacement operators

"""
    muPlusLambdaReplacement(x::Vector, y::Vector, comparator::Function=isless)

TBW
"""
function muPlusLambdaReplacement(x::Vector, y::Vector, comparator::Function=isless)
  jointVector = vcat(x,y)
  sort!(jointVector, lt=comparator)
  return jointVector[1:length(x)]
end

"""
    muCommaLambdaReplacement(x::Vector, y::Vector, comparator::Function=isless)

TBW
"""
function muCommaLambdaReplacement(x::Vector, y::Vector, comparator::Function=isless)
  @assert length(x) >= length(y) "The length of the x vector is lower than the length of the y vector" 

  resultVector = Vector(y)
  sort!(resultVector, lt=comparator)

  return resultVector[1:length(x)]
end

