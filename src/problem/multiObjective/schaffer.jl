
function schaffer()
  problem = ContinuousProblem{Float64}("Schaffer")

  f = x -> x[1] * x[1]
  g = x -> (x[1] - 2.0) * (x[1] - 2.0)

  addObjective(problem, f)
  addObjective(problem, g)
  addVariable(problem, Bounds{Float64}(-1000.0, 1000.0))

  return problem
end
