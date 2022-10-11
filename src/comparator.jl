include("core.jl")


"""
    multiComparator(comparators::Vector{Function}, x:: Vector, y::Vector)

TBW
"""
function multiComparator(comparators::Vector{Function}, x:: Vector, y::Vector)
  result = 0 
  for comparator in comparators
    result = comparator(x,y)
    if result != 0
      break
    end
  end
  return result 
end


"""
    objectiveComparator(x, y, index)

Compare the values in the same position (`index`) of two numeric arrays `x` and `y`. The result value is 0, -1, or 
+1 depending, respectively, on the conditions `x[index] == y[index]`, `x[index] < y[index]` or `x[index] > y[index]`

"""
function objectiveComparator(x::Array{T}, y::Array{T}, index::Int = 1)::Int where {T <: Number}
  @assert length(x) == length(y) "The arrays have a different length"
  @assert index in range(1, length(x)) "The objective id is out of range"

  result = 0 ;
  if x[index] < y[index]
    result = -1 ;
  elseif x[index] > y[index]
    result = 1
  end

  return result
end

"""
    dominanceComparator(x, y)

Compare two numerics vectors `x` and `y` according to the dominance relationship. The result is 0 if both vectors are non-dominated, -1 if vector `x` dominates vector `y`, and +1 if vector `x` is dominated by vector `y`. The dominance comparison assumes minimization, i.e., the lower the compared values, the better.

"""
function dominanceComparator(x::Vector{T}, y::Vector{T})::Int where {T <: Number}
    @assert length(x) == length(y) "The arrays have a different length"
  
    x==y && return 0
  
    all(t->(t[1]≤t[2]), zip(x, y)) && return -1
    all(t->(t[1]≤t[2]), zip(y, x)) && return  1
    return 0
  
    """
    bestIsSolution1 = 0
    bestIsSolution2 = 0
    result = 0 
  
    for i in 1:length(x)
      if x[i] != y[i]
        if x[i] < y[i]
          y[i]
          bestIsSolution1 = 1
        end
        if x[i] > y[i]
          bestIsSolution2 = 1
        end
      end
    end
  
    if bestIsSolution1 > bestIsSolution2
      result = -1
    elseif bestIsSolution1 < bestIsSolution2
      result = 1
    end
  
    return result
    """
  end
  
  """
  function dominanceComparator(solution1::Solution, solution2::Solution)::Int
    return dominanceComparator(solution1.objectives, solution2.objectives)
  end
  """
  function objectiveComparator(solution1::Solution, solution2::Solution, objectiveId::Int=1)::Int
    return objectiveComparator(solution1.objectives, solution2.objectives, objectiveId)
  end
