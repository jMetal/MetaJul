function sphere(numberOfVariables::Int)
    problem = ContinuousProblem{Float64}("Sphere")
  
    f = x -> sum([v * v for v in x])
  
    addObjective(problem, f)
  
    for i in 1:numberOfVariables
      addVariable(problem, Bounds{Float64}(-5.12, 5.12))
    end
  
    return problem
  end
  