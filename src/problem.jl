
include("bounds.jl")

abstract type Problem end

struct ContinuousProblem{T <: Number} <: Problem
    bounds::Array{Bounds{T}}
    numberOfObjectives::Int
    numberOfConstraints::Int
end

function numberOfVariables(problem:: ContinuousProblem) :: Int
  return length(problem.bounds)
end

