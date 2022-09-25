
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

