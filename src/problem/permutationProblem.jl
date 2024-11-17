abstract type AbstractPermutationProblem <: Problem{PermutationSolution} end

mutable struct PermutationProblem <: AbstractPermutationProblem
  permutationLength::Int64
  objectives::Vector{Function}
  constraints::Vector{Function}
  name::String
end

function PermutationProblem{T}(problemName::String) where {T<:Number}
  return PermutationProblem{T}([], [], [], problemName)
end

function numberOfVariables(problem::PermutationProblem{T}) where {T}
  return problem.permutationLength
end

function numberOfObjectives(problem::PermutationProblem{T}) where {T}
  return length(problem.objectives)
end

function numberOfConstraints(problem::PermutationProblem{T}) where {T}
  return length(problem.constraints)
end

function name(problem::PermutationProblem{T}) where {T}
  return problem.name
end

function addObjective(problem::PermutationProblem{T}, objective::Function) where {T<:Number}
  push!(problem.objectives, objective)

  return Nothing
end

function addConstraint(problem::PermutationProblem{T}, constraint::Function) where {T<:Number}
  push!(problem.constraints, constraint)

  return Nothing
end

function setName(problem::Problem{T}, name::String) where {T}
  problem.name = name

  return Nothing
end

"""
function evaluate(solution::PermutationSolution, problem::PermutationProblem)::PermutationSolution
  for i in 1:length(problem.objectives)
    solution.objectives[i] = problem.objectives[i](solution.variables)
  end

  for i in 1:length(problem.constraints)
    solution.constraints[i] = problem.constraints[i](solution.variables)
  end

  return solution
end
"""

function evaluate(solution::PermutationSolution, problem::PermutationProblem)::PermutationSolution
  solution.objectives .= map(obj -> obj(solution.variables), problem.objectives)
  solution.constraints .= map(constr -> constr(solution.variables), problem.constraints)
  return solution
end

function createSolution(problem::PermutationProblem)::PermutationSolution
  solution = PermutationSolution(problem.permutationLength)
  solution.objectives = zeros(numberOfObjectives(problem))
  solution.constraints = zeros(numberOfConstraints(problem))
  solution.attributes = Dict()

  return solution
end





