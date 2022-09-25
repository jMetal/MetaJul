
include("solution.jl")
include("comparator.jl")

# Mutation operators
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

