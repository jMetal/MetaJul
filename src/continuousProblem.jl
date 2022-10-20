
include("core.jl")
include("bounds.jl")
include("solution.jl")
include("operator.jl")

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

  #solution.objectives = [f(solution.variables) for f in problem.objectives]

  for i in 1:length(problem.constraints)
    solution.constraints[i] = problem.constraints[i](solution.variables)
  end

  return solution
end

function createSolution(problem::AbstractContinuousProblem{T})::ContinuousSolution{T} where {T<:Number}
  x = [problem.bounds[i].lowerBound + rand() * (problem.bounds[i].upperBound - problem.bounds[i].lowerBound) for i in 1:length(problem.bounds)]

  return ContinuousSolution{T}(x, zeros(numberOfObjectives(problem)), zeros(numberOfConstraints(problem)), Dict(), problem.bounds)
end

### Single objective problems
function schafferProblem()
  schaffer = ContinuousProblem{Float64}("Schaffer")

  f = x -> x[1] * x[1]
  g = x -> (x[1] - 2.0) * (x[1] - 2.0)

  addObjective(schaffer, f)
  addObjective(schaffer, g)
  addVariable(schaffer, Bounds{Float64}(-1000.0, 1000.0))

  return schaffer
end

function sphereProblem(numberOfVariables::Int)
  sphere = ContinuousProblem{Float64}("Sphere")

  f = x -> sum([v * v for v in x])

  addObjective(sphere, f)

  for i in 1:numberOfVariables
    addVariable(sphere, Bounds{Float64}(-5.12, 5.12))
  end

  return sphere
end

#### Multi-Objective problems
function fonsecaProblem()
  fonseca = ContinuousProblem{Float64}("Fonseca")

  numberOfVariables = 3
  for _ in 1:numberOfVariables
    addVariable(fonseca, Bounds{Float64}(-4.0, 4.0))
  end


  f1 = x -> begin
    sum1 = 0.0
    for i in range(1, numberOfVariables)
      sum1 += ^(x[i] - (1.0 / sqrt(1.0 * numberOfVariables)), 2.0)
    end
    return 1.0 - exp(-1.0 * sum1)
  end

  f2 = x -> begin
    sum2 = 0.0
    for i in range(1, numberOfVariables)
      sum2 += ^(x[i] + (1.0 / sqrt(1.0 * numberOfVariables)), 2.0)
    end

    return 1.0 - exp(-1.0 * sum2)
  end

  addObjective(fonseca, f1)
  addObjective(fonseca, f2)

  return fonseca
end

function kursaweProblem(numberOfVariables::Int=3)
  kursawe = ContinuousProblem{Float64}("Kursawe")

  for _ in 1:numberOfVariables
    addVariable(kursawe, Bounds{Float64}(-5.0, 5.0))
  end


  f1 = x -> begin
    sum1 = 0.0
    for i in range(1, numberOfVariables - 1)
      xi = x[i] * x[i]
      xj = x[i+1] * x[i+1]
      aux = (-0.2) * sqrt(xi + xj)
      sum1 += (-10.0) * exp(aux)
    end

    return sum1
  end

  f2 = x -> begin
    sum2 = 0.0
    for i in range(1, numberOfVariables)
      sum2 += ^(abs(x[i]), 0.8) + 5.0 * sin(^(x[i], 3.0))
    end
    return sum2

  end

  addObjective(kursawe, f1)
  addObjective(kursawe, f2)

  return kursawe
end

################### 
# ZDT benchmark

function zdt1Problem(numberOfVariables::Int=30)
  zdt1 = ContinuousProblem{Float64}("ZDT1")

  for _ in 1:numberOfVariables
    addVariable(zdt1, Bounds{Float64}(0.0, 1.0))
  end

  function evalG(x::Vector{Float64})
    g = sum(x[2:length(x)])
    return g * 9.0 / (length(x) - 1) + 1.0
  end

  f1 = x -> x[1]
  f2 = x -> begin
    g = evalG(x)
    h = 1.0 - sqrt(x[1]/ g)

    return h * g
  end

  addObjective(zdt1, f1)
  addObjective(zdt1, f2)

  return zdt1
end

function zdt2Problem(numberOfVariables::Int=30)
  zdt2 = ContinuousProblem{Float64}("ZDT2")

  for _ in 1:numberOfVariables
    addVariable(zdt2, Bounds{Float64}(0.0, 1.0))
  end

  function evalG(x::Vector{Float64})
    g = sum(x[2:length(x)])
    return g * 9.0 / (length(x) - 1) + 1.0
  end

  f1 = x -> x[1]
  f2 = x -> begin
    g = evalG(x)
    h = 1.0 - ^(x[1]/ g, 2.0)

    return h * g
  end

  addObjective(zdt2, f1)
  addObjective(zdt2, f2)

  return zdt2
end

function zdt3Problem(numberOfVariables::Int=30)
  zdt3 = ContinuousProblem{Float64}("ZDT3")

  for _ in 1:numberOfVariables
    addVariable(zdt3, Bounds{Float64}(0.0, 1.0))
  end

  function evalG(x::Vector{Float64})
    g = sum(x[2:length(x)])
    return g * 9.0 / (length(x) - 1) + 1.0
  end

  function evalH(v::Float64, g::Float64)
    return 1.0 - sqrt(v/g) - (v/g)*sin(10.0 * pi * v)
  end

  f1 = x -> x[1]
  f2 = x -> begin
    g = evalG(x)
    h = evalH(x[1], g)

    return h * g
  end

  addObjective(zdt3, f1)
  addObjective(zdt3, f2)

  return zdt3
end


function zdt4Problem(numberOfVariables::Int=10)
  zdt4 = ContinuousProblem{Float64}("ZDT4")

  addVariable(zdt4, Bounds{Float64}(0.0, 1.0))
  for _ in range(2, numberOfVariables)
    addVariable(zdt4, Bounds{Float64}(-5.0, 5.0))
  end

  function evalG(x::Vector{Float64})
    g = 1.0 +10.0 * (length(x) - 1)+ sum([(^(x[i],2.0) -10.0 * cos(4.0*pi*x[i])) for i in range(2,length(x))])

    return g 
  end

  function evalH(v::Real, g::Float64)
    return 1.0 - sqrt(v/g)
  end

  f1 = x -> x[1]
  f2 = x -> begin
    g = evalG(x)
    h = evalH(x[1], g)

    return h * g
  end

  addObjective(zdt4, f1)
  addObjective(zdt4, f2)

  return zdt4
end

"""

struct ZDT4 <: AbstractContinuousProblem{Float64}
  bounds::Vector{Bounds{Float64}}
  name::String
end

function zdt4Problem(numberOfVariables::Int = 10)
  bounds = vcat([Bounds{Float64}(0.0, 1.0)], [Bounds{Float64}(-5.0, 5.0) for _ in range(2, numberOfVariables)])

  return ZDT4(bounds,"ZDT4")
end

function numberOfVariables(problem::ZDT4)
  return length(problem.bounds)
end

function numberOfObjectives(problem::ZDT4)
  return 2
end

function numberOfConstraints(problem::ZDT4)
  return 0
end

function evaluate(solution::ContinuousSolution{Float64}, problem::ZDT4)::ContinuousSolution{Float64}
  x = solution.variables
  @assert length(x) == numberOfVariables(problem) "The number of variables of the solution to be evaluated is not correct"

  function evalG(x::Vector{Float64})
    g = sum([(^(x[i],2.0) -10.0 * cos(4.0*pi*x[i])) for i in range(2,length(x))])

    return g + 1.0 +10.0 * (length(x) - 1)
  end

  function evalH(v::Float64, g::Float64)
    return 1.0 - sqrt(v/g)
  end

  f1 = x[1]
  g = evalG(x)
  h = evalH(x[1], g)

  f2 = g * h
 
  solution.objectives = [f1, f2]

  return solution
end
"""

struct ZDT6 <: AbstractContinuousProblem{Float64}
  bounds::Vector{Bounds{Float64}}
  name::String
end

function zdt6Problem(numberOfVariables::Int=10)
  bounds = [Bounds{Float64}(0.0, 1.0) for _ in range(1, numberOfVariables)]

  return ZDT6(bounds,"ZDT6")
end

function numberOfVariables(problem::ZDT6)
  return length(problem.bounds)
end

function numberOfObjectives(problem::ZDT6)
  return 2
end

function numberOfConstraints(problem::ZDT6)
  return 0
end

function evaluate(solution::ContinuousSolution{Float64}, problem::ZDT6)::ContinuousSolution{Float64}
  x = solution.variables
  @assert length(x) == numberOfVariables(problem) "The number of variables of the solution to be evaluated is not correct"

  function evalG(x::Vector{Float64})
    g = sum(x[i] for i in range(2,length(x)))
    g = g / (length(x) - 1.0)

    g = ^(g, 0.25)
    g = 9.0 * g
    g = 1.0 + g

    return g
  end

  function evalH(v::Float64, g::Float64)
    return 1.0 - ^(v/g, 2.0)
  end

  f1 = 1.0 - exp(-4.0*x[1]) * ^(sin(6*pi*x[1]),6.0)
  g = evalG(x)
  h = evalH(f1, g)
  f2 = g * h
 
  solution.objectives = [f1, f2]

  return solution
end


