function oneZeroMax(numberOfBits::Int) 
  problem = BinaryProblem(numberOfBits, "OneZeroMax")

  f = x -> length([i for i in x.bits if i])
  g = y -> length([j for j in y.bits if !j])

  addObjective(problem, f)
  addObjective(problem, g)

  return problem
end

