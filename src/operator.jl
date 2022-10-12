
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


function uniformMutationOperator(x::Array{T}, parameters)::Array{T} where {T <: Real}
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

function polynomialMutationOperator(x::Array{T}, parameters)::Array{T} where {T <: Real}
  probability::Real = parameters.probability
  distributionIndex::Real = parameters.distributionIndex
  bounds = parameters.bounds

  for i in 1:length(x)
    if rand() < probability
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
            deltaq = val ^ mutPow - 1.0
          else 
            xy = 1.0 - delta2
            val = 2.0 * (1.0 - rnd) + 2.0 * (rnd - 0.5) * (xy ^ (distributionIndex + 1.0))
            deltaq = 1.0 - val ^ mutPow
          end
          y = y + deltaq * (yu - yl)
        end
        x[i] = y
      end
  end
  x = restrict(x, bounds)
  return x
end

# Crossover operators
function blxAlphaCrossover(parent1::Vector{T}, parent2::Vector{T}, parameters)::Array{Array{T}} where {T <: Real}
  probability::Real = parameters.probability
  alpha::Real = parameters.alpha
  bounds = parameters.bounds

  child1 = deepcopy(parent1)
  child2 = deepcopy(parent2)

  if rand() < probability
    for i in 1:length(x)
      minValue = min(parent1[i], parent2[i])
      maxValue = max(parent1[i], parent2[i])
      range = maxValue - minValue

      minRange = min - range * alpha
      minRange = max + range * alpha

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
function randomSelection(x::Array, parameters = [])
  return x[rand(1:length(x))]
end

function binaryTournamentSelectionOperator(x::Array, parameters::NamedTuple)
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

"""

x = [1,3,5,7]
y = [2,4,6,8]

z = muPlusLambdaReplacement(x,y)
println(z)

function createContinuousSolution(numberOfObjectives::Int)::ContinuousSolution{Float64}
  objectives = [_ for _ in range(1, numberOfObjectives)]
  return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(1.0, 2.0)])
end

solution1 = createContinuousSolution(3)
solution1.objectives = [5.0, 2.0, 3.0]

solution2 = createContinuousSolution(3)
solution2.objectives = [2.0, 1.0, 1.0]

solution3 = createContinuousSolution(3)
solution3.objectives = [4.0, 0.0, 0.0]

solution4 = createContinuousSolution(3)
solution4.objectives = [3.0, 3.0, 3.0]

solutions1 = [solution1, solution2]
#ranking = computeRanking(solutions1)

solutions = [solution1, solution2,solution3, solution4]
sort!(solutions, lt = (x,y) -> objectiveComparator(x,y) <=0)

for s in solutions println(s.objectives) end

solutions2 = [solution3, solution4]
ranking = computeRanking(solutions2)

z1 = muCommaLambdaReplacement(solutions1,solutions2,
(x,y) -> dominanceComparator(solution1.objectives, solution2.objectives) <= 0)

for s in z1 println(s.objectives) end
"""