
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

