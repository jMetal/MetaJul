
include("solution.jl")
include("comparator.jl")

# Mutation operators
function bitFlipMutation()

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
function blxAlphaCrossover(parent1::Array{T}, parent2::Array{T}, parameters)::Array{Array{T}} where {T <: Real}
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

# Selection operators
function randomSelection(x::Array)
  return x[rand(1:length(x))]
end

function binaryTournamentSelectionOperator(x::Array, comparator::Function)
  index1 = rand(1:length(x))
  index2 = rand(1:length(x))

  if comparator(x[index1], x[index2]) < 0 
    result = x[index1]
  else
    result = x[index2]
  end

  return result
end

