abstract type AbstractPermutationProblem <: Problem{PermutationSolution} end

mutable struct PermutationProblem <: AbstractPermutationProblem
  permutationLength::Int64
  objectives::Vector{Function}
  constraints::Vector{Function}
  name::String
end

function PermutationProblem(problemName::String) 
  return PermutationProblem([], [], [], problemName)
end

function numberOfVariables(problem::PermutationProblem) 
  return problem.permutationLength
end

function numberOfObjectives(problem::PermutationProblem) 
  return length(problem.objectives)
end

function numberOfConstraints(problem::PermutationProblem) 
  return length(problem.constraints)
end

function name(problem::PermutationProblem) 
  return problem.name
end

function addObjective(problem::PermutationProblem, objective::Function)
  push!(problem.objectives, objective)

  return Nothing
end

function addConstraint(problem::PermutationProblem, constraint::Function)
  push!(problem.constraints, constraint)

  return Nothing
end

function setName(problem::PermutationProblem, name::String) 
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

function createSolution(problem::T)::PermutationSolution where {T <: PermutationProblem}
  solution = PermutationSolution(problem.permutationLength)
  solution.objectives = zeros(numberOfObjectives(problem))
  solution.constraints = zeros(numberOfConstraints(problem))
  solution.attributes = Dict()

  return solution
end





