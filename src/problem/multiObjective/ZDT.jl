
function ZDT1(numberOfVariables::Int=30)
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

function ZDT2(numberOfVariables::Int=30)
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

function ZDT3(numberOfVariables::Int=30)
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


function ZDT4(numberOfVariables::Int=10)
  zdt4 = ContinuousProblem{Float64}("ZDT4")

  addVariable(zdt4, Bounds{Float64}(0.0, 1.0))
  for _ in range(2, numberOfVariables)
    addVariable(zdt4, Bounds{Float64}(-5.0, 5.0))
  end

  function evalG(x::Vector{Float64})
    g = 0.0

    for i in 2:length(x)
      g += x[i]^2 - 10.0 * cos(4.0 * π * x[i])
    end

    #g = 1.0 +10.0 * (length(x) - 1)+ sum([(^(x[i],2.0) -10.0 * cos(4.0*pi*x[i])) for i in range(2,length(x))])

    constant = 1.0 + 10.0 * (length(x) - 1)

    return g + constant
  end

  function evalH(v::Float64, g::Float64)
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
function ZDT6(numberOfVariables::Int=10)
  zdt6 = ContinuousProblem{Float64}("ZDT6")

  addVariable(zdt6, Bounds{Float64}(0.0, 1.0))
  for _ in range(2, numberOfVariables)
    addVariable(zdt6, Bounds{Float64}(-5.0, 5.0))
  end

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

  f1 = x -> 1.0 - exp(-4.0*x[1]) * ^(sin(6*pi*x[1]),6.0)
  g = evalG(x)
  h = evalH(f1, g)
  f2 = g * h
 
  addObjective(zdt6, f1)
  addObjective(zdt6, f2)

  return zdt6
end
"""

struct ProblemZDT6 <: AbstractContinuousProblem{Float64}
  bounds::Vector{Bounds{Float64}}
end

function ZDT6(numberOfVariables::Int=10)
  bounds = [Bounds{Float64}(0.0, 1.0) for _ in range(1, numberOfVariables)]

  return ProblemZDT6(bounds)
end

function numberOfVariables(problem::ProblemZDT6)
  return length(problem.bounds)
end

function numberOfObjectives(problem::ProblemZDT6)
  return 2
end

function numberOfConstraints(problem::ProblemZDT6)
  return 0
end

function bounds(problem::ProblemZDT6)
  return problem.bounds
end

function name(problem::ProblemZDT6)
  return "ZDT6"
end

function evaluate(solution::ContinuousSolution{Float64}, problem::ProblemZDT6)::ContinuousSolution{Float64}
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