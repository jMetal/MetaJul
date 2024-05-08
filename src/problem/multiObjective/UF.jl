function UF1(numberOfVariables::Int = 30)
  uf1 = ContinuousProblem{Float64}("UF1")

  # Setting the variable bounds
  addVariable(uf1, Bounds{Float64}(0.0, 1.0))  # For the first variable
  for _ in 2:numberOfVariables
    addVariable(uf1, Bounds{Float64}(-1.0, 1.0))
  end

  # Objective functions
  f1 = x -> begin
    sum1 = 0.0
    count1 = 0
    for j in 2:numberOfVariables
      yj = x[j] - sin(6.0 * π * x[1] + j * π / numberOfVariables)
      yj *= yj
      if j % 2 != 0
        sum1 += yj
        count1 += 1
      end
    end
    return x[1] + 2.0 * sum1 / count1
  end

  f2 = x -> begin
    sum2 = 0.0
    count2 = 0
    for j in 2:numberOfVariables
      yj = x[j] - sin(6.0 * π * x[1] + j * π / numberOfVariables)
      yj *= yj
      if j % 2 == 0
        sum2 += yj
        count2 += 1
      end
    end
    return 1.0 - sqrt(x[1]) + 2.0 * sum2 / count2
  end

  addObjective(uf1, f1)
  addObjective(uf1, f2)

  return uf1
end




