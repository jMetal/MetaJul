
include("core.jl")
include("bounds.jl")
include("solution.jl")
include("operator.jl")

abstract type AbstractBinaryProblem <: Problem{BinarySolution} end

mutable struct BinaryProblem <: AbstractBinaryProblem
  numberOfBits::Int
  objectives::Vector{Function}
  constraints::Vector{Function}
  name::String
end

function numberOfVariables(problem::BinaryProblem) 
  return problem.numberOfBits
end

function numberOfObjectives(problem::BinaryProblem) 
  return length(problem.objectives)
end
  
function numberOfConstraints(problem::BinaryProblem)
  return length(problem.constraints)
end

function name(problem::BinaryProblem) 
  return problem.name
end

function addObjective(problem::BinaryProblem, objective::Function) 
  push!(problem.objectives, objective)

  return Nothing ;
end

function addConstraint(problem::BinaryProblem, constraint::Function)
  push!(problem.constraints, constraint)

  return Nothing ;
end


function evaluate(solution::BinarySolution, problem::BinaryProblem)::BinarySolution 
  for i in 1:length(problem.objectives)
    solution.objectives[i] =  problem.objectives[i](solution.variables)
  end

  #solution.objectives = [f(solution.variables) for f in problem.objectives]

  for i in 1:length(problem.constraints)
    solution.constraints[i] =  problem.constraints[i](solution.variables)
  end

  return solution
end

function createSolution(problem::BinaryProblem) 
  x = initBitVector(problem.numberOfBits)

  return BinarySolution(x, zeros(numberOfObjectives(problem)), zeros(numberOfConstraints(problem)), Dict())
end

function oneMax(numberOfBits::Int) 
  oneMax = BinaryProblem(numberOfBits,[],[], "OneMax")

  f = x -> length([i for i in x.bits if i])

  addObjective(oneMax, f)

  return oneMax
end

function oneZeroMax(numberOfBits::Int) 
  problem = BinaryProblem(numberOfBits,[],[], "OneZeroMax")

  f = x -> length([i for i in x.bits if i])
  g = y -> length([j for j in y.bits if !j])

  addObjective(problem, f)
  addObjective(problem, g)

  return problem
end

problem = oneZeroMax(5)
println(problem)

binarySolution = createSolution(problem)
println(binarySolution)
println(evaluate(binarySolution, problem))
