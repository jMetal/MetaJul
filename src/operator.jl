
include("solution.jl")

struct Operator
    execute::Function
end


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

function binaryTournamentSelection(x::Array)
  index1 = rand(1:length(x))
  index2 = rand(1:length(x))

  println("index1 :" , index1, ". Index2: " , index2)
  result = x[index1] < x[index2] ? x[index1] : x[index2]

  return result
end