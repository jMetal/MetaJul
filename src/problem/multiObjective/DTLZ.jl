struct ProblemDTLZ1 <: AbstractContinuousProblem{Float64}
  bounds::Vector{Bounds{Float64}}
  numberOfObjectives::Int
  name::String
end

function DTLZ1(; numberOfVariables::Int=7, numberOfObjectives::Int=3)
  bounds = [Bounds{Float64}(0.0, 1.0) for _ in 1:numberOfVariables]
  return ProblemDTLZ1(bounds, numberOfObjectives, "DTLZ1")
end

function numberOfVariables(problem::ProblemDTLZ1)
  return length(problem.bounds)
end

function numberOfObjectives(problem::ProblemDTLZ1)
  return problem.numberOfObjectives
end

function numberOfConstraints(problem::ProblemDTLZ1)
  return 0
end

function name(problem::ProblemDTLZ1)
  return problem.name
end

function evaluate(solution::ContinuousSolution{Float64}, problem::ProblemDTLZ1)::ContinuousSolution{Float64}
  x = solution.variables
  n = numberOfVariables(problem)
  m = numberOfObjectives(problem)
  k = n - m + 1

  g = 0.0
  for i in (n - k + 1):n
    g += (x[i] - 0.5)^2 - cos(20.0 * π * (x[i] - 0.5))
  end
  g = 100.0 * (k + g)

  for i in 1:m
    f = (1.0 + g) * 0.5
    for j in 1:(m - i)
      f *= x[j]
    end
    if i > 1
      f *= 1.0 - x[m - i + 1]
    end
    solution.objectives[i] = f
  end

  return solution
end
