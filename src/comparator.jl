include("core.jl")

function singleObjectiveComparator(solution1::Solution, solution2::Solution)::Int
    result = 0 ;
    if solution1.objectives[0] < solution2.objectives[0]
      result = -1 ;
    elseif solution1.objectives[0] > solution2.objectives[0]
      result = 1
    end
  
    return result
  end
  
  function dominanceComparator(x::Array{T}, y::Array{T})::Int where {T <: Number}
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
  
  
  function dominanceComparator(solution1::Solution, solution2::Solution)::Int
    return dominanceComparator(solution1.objectives, solution2.objectives)
  end