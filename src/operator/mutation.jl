
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
