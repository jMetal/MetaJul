
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

function ContinuousProblem{T}(problemName::String) where {T <: Number}
  return ContinuousProblem{T}([],[],[], problemName)
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

function createSolution(problem::AbstractContinuousProblem{T})::ContinuousSolution{T} where {T <: Number}
  x = [problem.bounds[i].lowerBound + rand()*(problem.bounds[i].upperBound-problem.bounds[i].lowerBound) for i in 1:length(problem.bounds)]

  return ContinuousSolution{T}(x, zeros(numberOfObjectives(problem)), zeros(numberOfConstraints(problem)), Dict(), problem.bounds)
end

### Single objective problems
function schafferProblem() 
  schaffer = ContinuousProblem{Real}("Schaffer")

  f = x -> x[1] * x[1]
  g = x -> (x[1] - 2.0) * (x[1] - 2.0)

  addObjective(schaffer, f)
  addObjective(schaffer, g)
  addVariable(schaffer, Bounds{Real}(-1000.0, 1000.0))

  return schaffer
end

function sphereProblem(numberOfVariables::Int) 
  sphere = ContinuousProblem{Real}("Sphere")

  f = x -> sum([v * v for v in x])

  addObjective(sphere, f)

  for i in 1:numberOfVariables
    addVariable(sphere, Bounds{Real}(-5.12, 5.12))
  end

  return sphere
end

#### Multi-Objective problems
function fonsecaProblem()
  fonseca = ContinuousProblem{Real}("Fonseca")

  numberOfVariables = 3
  for _ in 1:numberOfVariables
    addVariable(fonseca, Bounds{Real}(-4.0, 4.0))
  end


  f1 = x -> begin
  sum1 = 0.0
  for i in range(1, numberOfVariables)
    sum1 += ^(x[i] - (1.0/sqrt(1.0 * numberOfVariables)), 2.0)

    return 1.0 - exp(-1.0*sum1)
  end
  end

  f2 = x -> begin
  sum2 = 0.0
  for i in range(1, numberOfVariables)
    sum2 += ^(x[i] + (1.0/sqrt(1.0 * numberOfVariables)), 2.0)

    return 1.0 - exp(-1.0*sum2)
  end
  end

  addObjective(fonseca, f1)
  addObjective(fonseca, f2)

  return fonseca
end

function kursaweProblem(numberOfVariables::Int = 3)
  kursawe = ContinuousProblem{Real}("Kursawe")

  for _ in 1:numberOfVariables
    addVariable(kursawe, Bounds{Real}(-5.0, 5.0))
  end


  f1 = x -> begin
  sum1 = 0.0
  for i in range(1, numberOfVariables-1)
    xi = x[i] * x[i]
    xj = x[i + 1] * x[i + 1]
    aux = (-0.2) * sqrt(xi + xj)
    sum1 += (-10.0) * exp(aux)

    return sum1
  end
end

f2 = x -> begin
sum2 = 0.0
for i in range(1, numberOfVariables)
  sum2 += ^(abs(x[i]), 0.8) + 5.0 * sin(^(x[i], 3.0))

  return sum2
end
end

  addObjective(kursawe, f1)
  addObjective(kursawe, f2)

  return kursawe
end

"""
struct Fonseca <: AbstractContinuousProblem{Float64}
  bounds::Vector{Bounds}
  numberOfObjectives
  numberOfConstraints 
  name::String
  function Fonseca() 
    x = new()
    x.bounds = [Bounds{Float64}(-4.0, 4.0) for _ in range(1,3)]
    x.numberOfObjectives = 2
    x.numberOfConstraints = 0
    x.name = "Fonseca"

    return x
  end
end

function evaluate(solution::ContinuousSolution{Float64}, problem::Fonseca)::ContinuousSolution{Float64}
  sum1 = 0.0
  for x in solution.variables
    sum1 += Ba
  end
end
"""