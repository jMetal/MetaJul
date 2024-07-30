"""
    Comparator ElementAtComparator(index)

Compare the values in the same position (`index`) of two numeric vectors `x` and `y`. The result value is 0, -1, or 
+1 depending, respectively, on the conditions `x[index] == y[index]`, `x[index] < y[index]` or `x[index] > y[index]`

"""

struct ElementAtComparator <: Comparator
  index::Int
end

function compare(comparator::ElementAtComparator, solution1, solution2)
  return compare(comparator, solution1.objectives, solution2.objectives)
end

function compare(comparator::ElementAtComparator, x::Vector, y::Vector)
  index = comparator.index

  @assert length(x) == length(y) "The vectors have a different length"
  @assert index in range(1, length(x)) "The index is out of range"

  result = 0
  if x[index] < y[index]
    result = -1
  elseif x[index] > y[index]
    result = 1
  end

  return result
end

"""
    DefaulDominanceComparator

Compare two numerics vectors `x` and `y` according to the dominance relationship. The result is 0 if both vectors are non-dominated, -1 if vector `x` dominates vector `y`, and +1 if vector `x` is dominated by vector `y`. The dominance comparison assumes minimization, i.e., the lower the compared values, the better.

"""

struct DefaultDominanceComparator <: Comparator end

function compare(comparator::DefaultDominanceComparator, solution1, solution2)
  return compare(comparator, solution1.objectives, solution2.objectives)
end

function compare(comparator::DefaultDominanceComparator, vector1::Vector{T}, vector2::Vector{T})::Int where {T<:Number}
  @assert length(vector1) == length(vector2) "The vectors have a different length"

  """
  x==y && return 0

  all(t->(t[1]≤t[2]), zip(x, y)) && return -1
  all(t->(t[1]≤t[2]), zip(y, x)) && return  1
  return 0
  """

  vector1_dominates = false
  vector2_dominates = false

  @inbounds for i in eachindex(vector1, vector2)
    if vector1[i] < vector2[i]
      vector1_dominates = true
    elseif vector1[i] > vector2[i]
      vector2_dominates = true
    end

    if vector1_dominates && vector2_dominates
      return 0  # Neither dominates
    end
  end

  if vector1_dominates
    return -1  # vector1 dominates
  elseif vector2_dominates
    return 1   # vector2 dominates
  else
    return 0   # Vectors are equal
  end
end

mutable struct IthObjectiveComparator <: Comparator
  index::Int
  elementAtComparator::ElementAtComparator

  IthObjectiveComparator(index) = new(index, ElementAtComparator(index))
end

function setIndex(comparator::IthObjectiveComparator, index::Int)
  comparator.index = index
end

function compare(comparator::IthObjectiveComparator, solution1::Solution, solution2::Solution)::Int
  return compare(comparator.elementAtComparator, solution1.objectives, solution2.objectives)
end

struct OverallConstraintViolationDegreeComparator <: Comparator end

function compare(comparator::OverallConstraintViolationDegreeComparator, solution1::Solution, solution2::Solution)::Int
  constraintViolationSolution1 = overallConstraintViolationDegree(solution1)
  constraintViolationSolution2 = overallConstraintViolationDegree(solution2)

  result = 0
  if constraintViolationSolution1 == 0.0 && constraintViolationSolution2 < 0.0
    result = -1
  elseif constraintViolationSolution1 < 0.0 && constraintViolationSolution2 == 0.0
    result = 1
  elseif constraintViolationSolution1 < constraintViolationSolution2
    result = 1
  elseif constraintViolationSolution1 > constraintViolationSolution2
    result = -1
  end

  return result
end

struct ConstraintsAndDominanceComparator <: Comparator
  dominanceComparator::Comparator
  overallConstraintViolationDegreeComparator::OverallConstraintViolationDegreeComparator

  ConstraintsAndDominanceComparator() = new(DefaultDominanceComparator(), OverallConstraintViolationDegreeComparator())
end

function compare(constraintsAndDominanceComparator::ConstraintsAndDominanceComparator, solution1::Solution, solution2::Solution)::Int
  result = compare(constraintsAndDominanceComparator.overallConstraintViolationDegreeComparator, solution1, solution2)
  if result == 0
    result = compare(constraintsAndDominanceComparator.dominanceComparator, solution1, solution2)
  end

  return result
end

struct RankingAndCrowdingDistanceComparator <: Comparator
  rankingComparator::Comparator
  crowdingDistanceComparator::CrowdingDistanceComparator

  RankingAndCrowdingDistanceComparator() = new(DominanceRankingComparator(), CrowdingDistanceComparator())
end

function compare(rankingAndCrowdingDistanceComparator::RankingAndCrowdingDistanceComparator, x::Solution, y::Solution)::Int
  result = compare(rankingAndCrowdingDistanceComparator.rankingComparator, x, y)
  if (result == 0)
    result = compare(rankingAndCrowdingDistanceComparator.crowdingDistanceComparator, x, y)
  end
  return result
end
