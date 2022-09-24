
include("bounds.jl")
include("solution.jl")

abstract type Problem{T} end

mutable struct ContinuousProblem{T <: Number} <: Problem{T}
  bounds::Array{Bounds{T}}
  objectives::Array{Function}
  constraints::Array{Function}
  name::String
end

function numberOfObjectives(problem::Problem{T}) where {T}
  return length(problem.objectives)
end
  
function addObjective(problem::ContinuousProblem{T}, objective::Function) where {T <: Number}
  push!(problem.objectives, objective)

  return Nothing ;
end

function addVariable(problem::ContinuousProblem{T}, bounds::Bounds{T}) where {T <: Number}
  push!(problem.bounds, bounds)
  return Nothing
end

function evaluate(solution::ContinuousSolution{T}, problem::ContinuousProblem{T})::ContinuousSolution{T} where {T <: Number}
  for i in 1:length(problem.objectives)
    solution.objectives[i] =  problem.objectives[i](solution.variables)
  end

  return solution
end

schaffer = ContinuousProblem{Float64}([],[],[], "Schaffer")

f(x::Vector{Float64}) =  x -> x[1] * x[1]
g(x::Vector{Float64}) =  x -> (x[1] - 2.0) * (x[1] - 2.0)


addObjective(schaffer, f)
addObjective(schaffer, g)
addVariable(schaffer, Bounds{Float64}(-100000.0, 100000.0))


solution = ContinuousSolution{Float64}([12.0], [0.0, 0.0], [], Dict(), schaffer.bounds)


println("Solution: ", solution)
println()
println("Problem: ", schaffer)
println()
#solution = evaluate(solution, schaffer)
#println("FF: ", f([3.3]))

#solution.objectives[1] = 4
println("Solution: ", solution)
