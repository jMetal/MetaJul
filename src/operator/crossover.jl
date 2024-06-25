
# BLX-Alpha crossover
struct BLXAlphaCrossover <: CrossoverOperator
  probability::Float64
  alpha::Float64
  bounds::Vector{Bounds{Float64}} 

  function BLXAlphaCrossover(;probability = 0.9, alpha = 0.5, bounds = [])
    @assert bounds != [] "The bounds list is empty"

    return new(probability, alpha, bounds)
  end
end

function numberOfRequiredParents(crossover::BLXAlphaCrossover)
  return 2 
end

function numberOfDescendants(crossover::BLXAlphaCrossover)
  return 2
end

function recombine(parent1::ContinuousSolution, parent2::ContinuousSolution, crossoverOperator::BLXAlphaCrossover)::Vector{ContinuousSolution}
  probability::Real = crossoverOperator.probability
  alpha::Real = crossoverOperator.alpha
  bounds = crossoverOperator.bounds

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

# Simulated binary crossover (SBX)
struct SBXCrossover <: CrossoverOperator
  probability::Float64
  distributionIndex:: Float64
  bounds::Vector{Bounds{T}} where {T <: Number}

  function SBXCrossover(;probability = 0.9, distributionIndex = 20.0, bounds = [])
    @assert bounds != [] "The bounds list is empty"

    return new(probability, distributionIndex, bounds)
  end

end

function numberOfRequiredParents(crossover::SBXCrossover)
  return 2 
end

function numberOfDescendants(crossover::SBXCrossover)
  return 2
end

function recombine(parent1::ContinuousSolution{T}, parent2::ContinuousSolution{T}, crossoverOperator::SBXCrossover)::Vector{ContinuousSolution{T}} where {T <: Real}
  EPSILON = 1.0e-14
  probability::Real = crossoverOperator.probability
  distributionIndex::Real = crossoverOperator.distributionIndex
  bounds = crossoverOperator.bounds

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

function recombine(parent1::ContinuousSolution{T}, parent2::ContinuousSolution{T}, crossoverOperator::SBXCrossover)::Vector{ContinuousSolution{T}} where {T <: Int}
  EPSILON = 1.0e-14
  probability::Real = crossoverOperator.probability
  distributionIndex::Real = crossoverOperator.distributionIndex
  bounds = crossoverOperator.bounds

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

          c1 = restrict(round(Int, c1), bounds[i])
          c2 = restrict(round(Int, c2), bounds[i])

          if rand() <= 0.5
            child1.variables[i] = round(Int, c2)
            child2.variables[i] = round(Int, c1)
          else
            child1.variables[i] = round(Int, c1)
            child2.variables[i] = round(Int, c2)
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


# Single point crossover
struct SinglePointCrossover <: CrossoverOperator
  probability::Real 
end

function numberOfRequiredParents(crossover::SinglePointCrossover)
  return 2 
end

function numberOfDescendants(crossover::SinglePointCrossover)
  return 2
end


function recombine(parent1::BinarySolution, parent2::BinarySolution, crossoverOperator::SinglePointCrossover)::Vector{BinarySolution}
  @assert length(parent1.variables) == length(parent2.variables) "The length of the two binary solutions to recombine is not equal"

  probability::Real = crossoverOperator.probability

  child1 = copySolution(parent1)
  child2 = copySolution(parent2)

  x = child1.variables
  y = child2.variables
  if rand() < probability
    cuttingPoint = rand(1:length(x))

    tmp = x.bits[cuttingPoint:end]
    x.bits[cuttingPoint:end] = y.bits[cuttingPoint:end]
    y.bits[cuttingPoint:end] = tmp
  end

  child1.variables = x
  child2.variables = y

  return [child1, child2]
end
