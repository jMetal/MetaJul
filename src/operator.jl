
include("solution.jl")

function uniformMutation(x::Array{T}, probability::T, perturbation::T)::Array{T} where {T <: Real}
  if rand() < probability
    for i in 1:length(x)
      x[i] += (rand() - 0.5) * perturbation
    end
  end

  return x
end


function randomSelection(x::Array)
  return x[rand(1:length(x))]
end

"""
function objectiveComparator(solution1::Solution, solution2::Solution, objectiveId::Int)::Int
  result = 0 ;
  if solution1.objectives[objectiveId] < solution2.objectives[objectiveId]
    result = -1 ;
  elseif solution1.objectives[objectiveId] > solution2.objectives[objectiveId]
    result = 1
  end

  return result
end
"""

function dominanceComparator(x::Array{T}, y::Array{T})::Int where {T <: Number}
  @assert length(x) == length(y) "The arrays have a different length"

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
end


function dominanceComparator(solution1::Solution, solution2::Solution)::Int
  return dominanceComparator(solution1.objectives, solution2.objectives)
end

function binaryTournamentSelection(x::Array{T}, comparator::Function) where {T}
  index1 = rand(1:length(x))
  index2 = rand(1:length(x))

  if comparator(x[index1], x[index2]) < 0 
    result = x[index1]
  else
    result = x[index2]
  end

  return result
end
