function oneMax(numberOfBits::Int) 
  problem = BinaryProblem(numberOfBits, "OneMax")

  f = x -> -1.0 * length([i for i in x.bits if i])

  addObjective(problem, f)

  return problem
end
