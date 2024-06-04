abstract type AbstractContinuousProblem{T<:Number} <: Problem{T} end

mutable struct ContinuousProblem{T} <: AbstractContinuousProblem{T}
  bounds::Vector{Bounds{T}}
  objectives::Vector{Function}
  constraints::Vector{Function}
  name::String
end

function ContinuousProblem{T}(problemName::String) where {T<:Number}
  return ContinuousProblem{T}([], [], [], problemName)
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

function bounds(problem::ContinuousProblem{T}) where {T}
  return problem.bounds
end

function addObjective(problem::ContinuousProblem{T}, objective::Function) where {T<:Number}
  push!(problem.objectives, objective)

  return Nothing
end

function addConstraint(problem::ContinuousProblem{T}, constraint::Function) where {T<:Number}
  push!(problem.constraints, constraint)

  return Nothing
end

function addVariable(problem::ContinuousProblem{T}, bounds::Bounds{T}) where {T<:Number}
  push!(problem.bounds, bounds)
  return Nothing
end

function setName(problem::Problem{T}, name::String) where {T}
  problem.name = name

  return Nothing
end

function evaluate(solution::ContinuousSolution{T}, problem::ContinuousProblem{T})::ContinuousSolution{T} where {T<:Number}
  for i in 1:length(problem.objectives)
    solution.objectives[i] = problem.objectives[i](solution.variables)
  end

  for i in 1:length(problem.constraints)
    solution.constraints[i] = problem.constraints[i](solution.variables)
  end

  return solution
end

function createSolution(problem::AbstractContinuousProblem{T})::ContinuousSolution{T} where {T<:Real}
  x = [problem.bounds[i].lowerBound + rand() * (problem.bounds[i].upperBound - problem.bounds[i].lowerBound) for i in 1:length(problem.bounds)]

  return ContinuousSolution{T}(x, zeros(numberOfObjectives(problem)), zeros(numberOfConstraints(problem)), Dict(), problem.bounds)
end

function createSolution(problem::AbstractContinuousProblem{T})::ContinuousSolution{T} where {T<: Int}
  x = [floor(Int, problem.bounds[i].lowerBound + rand() * (problem.bounds[i].upperBound - problem.bounds[i].lowerBound)) for i in 1:length(problem.bounds)]

  return ContinuousSolution{T}(x, zeros(numberOfObjectives(problem)), zeros(numberOfConstraints(problem)), Dict(), problem.bounds)
end




