
function kursawe(numberOfVariables::Int=3)
  problem = ContinuousProblem{Float64}("Kursawe")

  for _ in 1:numberOfVariables
    addVariable(problem, Bounds{Float64}(-5.0, 5.0))
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

  addObjective(problem, f1)
  addObjective(problem, f2)

  return problem
end
