include("continuousProblem.jl")

#### Constrained problems
function constrExProblem()
  problem = ContinuousProblem{Float64}("ConstrEx")

  addVariable(problem, Bounds{Float64}(0.1, 1.0))
  addVariable(problem, Bounds{Float64}(1.0, 5.0))

  f1 = x -> x[1]
  f2 = x -> (1.0 + x[2]/x[1])

  addObjective(problem, f1)
  addObjective(problem, f2)

  c1 = x -> x[2] + 9 * x[1] - 6.0
  c2 = x -> -x[2] + 9 * x[1] - 1.0

  addConstraint(problem, c1)
  addConstraint(problem, c2)

  return problem
end


function srinivasProblem()
  problem = ContinuousProblem{Float64}("Srinivas")

  addVariable(problem, Bounds{Float64}(-20.0, 20.0))
  addVariable(problem, Bounds{Float64}(-20.0, 20.0))

  f1 = x ->  2.0 + (x[1] - 2.0) * (x[1] - 2.0) + (x[2] - 1.0) * (x[2] - 1.0)
  f2 = x -> 9.0 * x[1] - (x[2] - 1.0) * (x[2] - 1.0)

  addObjective(problem, f1)
  addObjective(problem, f2)

  c1 = x -> 1.0 - (x[1] * x[1] + x[2] * x[2]) / 225.0
  c2 = x -> (3.0 * x[2] - x[1]) / 10.0 - 1.0

  addConstraint(problem, c1)
  addConstraint(problem, c2)

  return problem
end
