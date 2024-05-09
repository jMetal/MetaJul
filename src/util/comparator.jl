"""
    compareElementAt(x, y)

Compare the values in the same position (`index`) of two numeric vectors `x` and `y`. The result value is 0, -1, or 
+1 depending, respectively, on the conditions `x[index] == y[index]`, `x[index] < y[index]` or `x[index] > y[index]`

"""
function compareElementAt(x::Vector{T}, y::Vector{T}, index::Int=1)::Int where {T<:Number}
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
    compareForDominance(x, y)

Compare two numerics vectors `x` and `y` according to the dominance relationship. The result is 0 if both vectors are non-dominated, -1 if vector `x` dominates vector `y`, and +1 if vector `x` is dominated by vector `y`. The dominance comparison assumes minimization, i.e., the lower the compared values, the better.

"""
function compareForDominance(x::Vector{T}, y::Vector{T})::Int where {T<:Number}
  @assert length(x) == length(y) "The vectors have a different length"

  bestIsSolution1 = false
  bestIsSolution2 = false

  @inbounds for i in 1:length(x)
      if x[i] < y[i]
          bestIsSolution1 = true
      elseif x[i] > y[i]
          bestIsSolution2 = true
      end

      # Early exit if both flags are true
      if bestIsSolution1 && bestIsSolution2
          return 0
      end
  end

  if bestIsSolution1
      return -1
  elseif bestIsSolution2
      return 1
  else
      return 0
  end
end

function compareForDominance(solution1::Solution, solution2::Solution)::Int
  return compareForDominance(solution1.objectives, solution2.objectives)
end

function compareIthObjective(solution1::Solution, solution2::Solution, index::Int=1)::Int
  return compareElementAt(solution1.objectives, solution2.objectives, index)
end

function compareForOverallConstraintViolationDegree(solution1::Solution, solution2::Solution)::Int
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

function compareForConstraintsAndDominance(solution1::Solution, solution2::Solution)::Int
  result = compareForOverallConstraintViolationDegree(solution1, solution2)
  if result == 0
    result = compareForDominance(solution1, solution2)
  end

  return result ;
end

function compareRankingAndCrowdingDistance(x::Solution, y::Solution)::Int
  result = compareRanking(x, y)
  if (result == 0)
    result = compareCrowdingDistance(x,y)
  end
  return result
end
