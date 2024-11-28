
# Mutation operators

# Bit flit mutation
struct BitFlipMutation <: MutationOperator
  probability::Float64

  BitFlipMutation(;probability = 0.01) = new(probability)
end

function mutate!(solution::BinarySolution, mutationOperator::BitFlipMutation)::BinarySolution
  solution.variables = bitFlipMutation(solution.variables, mutationOperator.probability)
  return solution
end

function bitFlipMutation(x::BitVector, probability::Float64)::BitVector
  for i in 1:length(x)
    r = rand()
    if r < probability
      bitFlip(x, i)
    end
  end

  return x
end

# Uniform mutation
struct UniformMutation <: MutationOperator
  probability::Float64
  perturbation::Float64
  variableBounds::Vector{Bounds{Float64}}

  function UniformMutation(;probability = 0.01, perturbation = 0.5, bounds = [])
    @assert bounds != [] "The bounds list is empty"
    @assert probability >= 0.0 string("The probability ", probability, " must be equal or greater than zero")
    @assert perturbation >= 0 string("The perturbation value ", perturbation, " cannot be negative")

    return new(probability, perturbation, bounds)
  end

end

function uniformMutation(x::Vector{T}, mutationOperator::UniformMutation)::Vector{T} where {T<:Real}
  probability::Real = mutationOperator.probability
  perturbation::Real = mutationOperator.perturbation
  bounds = mutationOperator.variableBounds
  for i in 1:length(x)
    if rand() < probability
      x[i] += (rand() - 0.5) * perturbation
    end
  end

  x = restrict(x, bounds)
  return x
end

function mutate!(solution::ContinuousSolution, mutationOperator::UniformMutation)::ContinuousSolution
  solution.variables = uniformMutation(solution.variables, mutationOperator)
  return solution
end

# Polynomial mutation
struct PolynomialMutation <: MutationOperator
  probability::Float64
  distributionIndex::Float64
  variableBounds::Vector{Bounds{T}} where {T <: Number}

  function PolynomialMutation(;probability = 0.01, distributionIndex = 20.0, bounds = [])
    @assert bounds != [] "The bounds list is empty"
    @assert probability >= 0.0 string("The probability ", probability, " must be equal or greater than zero")
    @assert distributionIndex >= 0 string("The distributionIndex value ", perturbation, " cannot be negative")

    return new(probability, distributionIndex, bounds)
  end

end

function polynomialMutation(x::Vector{T}, mutationOperator::PolynomialMutation)::Vector{T} where {T<:Real}
  probability::Real = mutationOperator.probability
  distributionIndex::Real = mutationOperator.distributionIndex
  bounds = mutationOperator.variableBounds

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
  return restrict(x, bounds)
end

function polynomialMutation(x::Vector{T}, mutationOperator::PolynomialMutation)::Vector{T} where {T<:Int}
  probability::Real = mutationOperator.probability
  distributionIndex::Real = mutationOperator.distributionIndex
  bounds = mutationOperator.variableBounds

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
      x[i] = round(Int, y)
    end
  end
  return restrict(x, bounds)
end


function mutate!(solution::ContinuousSolution, mutationOperator::PolynomialMutation)::ContinuousSolution
  solution.variables = polynomialMutation(solution.variables, mutationOperator)
  return solution
end

struct PermutationSwapMutation <: MutationOperator
  probability::Float64

  PermutationSwapMutation(;probability = 0.01) = new(probability)
end

function mutate!(solution::PermutationSolution, mutationOperator::PermutationSwapMutation)::PermutationSolution
  solution.variables = permutationSwapMutation(solution.variables, mutationOperator.probability)
  return solution
end

function permutationSwapMutation(x::Vector{Int64}, probability::Float64)::Vector{Int64}
  permutationLength = length(x)

  if permutationLength > 2
    if rand() < probability
      cuttingPoint1 = rand(1:permutationLength)
      cuttingPoint2 = rand(1:permutationLength)

      while cuttingPoint1 == cuttingPoint2
        if cuttingPoint1 == permutationLength
          cuttingPoint2 = rand(1:(permutationLength - 1))
        else
          cuttingPoint2 = rand(cuttingPoint1:permutationLength)
        end
      end

      x[cuttingPoint1], x[cuttingPoint2] = x[cuttingPoint2], x[cuttingPoint1]
    end
  end

  return x
end
