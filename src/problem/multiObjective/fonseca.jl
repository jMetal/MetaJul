function fonseca()
  problem = ContinuousProblem{Float64}("Fonseca")

  numberOfVariables = 3
  for _ in 1:numberOfVariables
    addVariable(problem, Bounds{Float64}(-4.0, 4.0))
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

  addObjective(problem, f1)
  addObjective(problem, f2)

  return problem
end
