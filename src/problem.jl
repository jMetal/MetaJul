
include("core.jl")
include("bounds.jl")
include("solution.jl")
include("operator.jl")

abstract type AbstractContinuousProblem{T <: Number} <: Problem{T} end

mutable struct ContinuousProblem{T} <: AbstractContinuousProblem{T}
  bounds::Vector{Bounds{T}}
  objectives::Vector{Function}
  constraints::Vector{Function}
  name::String
end

function numberOfVariables(problem::ContinuousProblem{T}) where {T}
  return length(problem.bounds)
end

function numberOfObjectives(problem::ContinuousProblem{T}) where {T}
  return length(problem.objectives)
end
  
function numberOfConstraints(problem::ContinuousProblem{T}) where {T}
  return length(problem.constraints)
end

function name(problem::ContinuousProblem{T}) where {T}
  return problem.name
end

function addObjective(problem::ContinuousProblem{T}, objective::Function) where {T <: Number}
  push!(problem.objectives, objective)

  return Nothing ;
end

function addConstraint(problem::ContinuousProblem{T}, constraint::Function) where {T <: Number}
  push!(problem.constraints, constraint)

  return Nothing ;
end

function addVariable(problem::ContinuousProblem{T}, bounds::Bounds{T}) where {T <: Number}
  push!(problem.bounds, bounds)
  return Nothing
end

function setName(problem::Problem{T}, name::String) where {T}
  problem.name = name

  return Nothing
end

function evaluate(solution::ContinuousSolution{T}, problem::ContinuousProblem{T})::ContinuousSolution{T} where {T <: Number}
  for i in 1:length(problem.objectives)
    solution.objectives[i] =  problem.objectives[i](solution.variables)
  end

  #solution.objectives = [f(solution.variables) for f in problem.objectives]

  for i in 1:length(problem.constraints)
    solution.constraints[i] =  problem.constraints[i](solution.variables)
  end

  return solution
end

function createSolution(problem::ContinuousProblem{T}) where {T <: Number}
  x = [problem.bounds[i].lowerBound + rand()*(problem.bounds[i].upperBound-problem.bounds[i].lowerBound) for i in 1:length(problem.bounds)]

  return ContinuousSolution{T}(x, zeros(numberOfObjectives(problem)), zeros(numberOfConstraints(problem)), Dict(), problem.bounds)
end

function schafferProblem() 
  schaffer = ContinuousProblem{Real}([],[],[], "Schaffer")

  f = x -> x[1] * x[1]
  g = x -> (x[1] - 2.0) * (x[1] - 2.0)

  addObjective(schaffer, f)
  addObjective(schaffer, g)
  addVariable(schaffer, Bounds{Real}(-100000.0, 100000.0))

  return schaffer
end

function sphereProblem(numberOfVariables::Int) 
  sphere = ContinuousProblem{Real}([],[],[], "Sphere")

  f = x -> sum([v * v for v in x])

  addObjective(sphere, f)

  for i in 1:numberOfVariables
    addVariable(sphere, Bounds{Real}(-5.12, 5.12))
  end

  return sphere
end

