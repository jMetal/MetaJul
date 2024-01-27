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

function binh2Problem()
  binh2 = ContinuousProblem{Float64}("Binh2")

  # Setting the variable bounds
  addVariable(binh2, Bounds{Float64}(0.0, 5.0))
  addVariable(binh2, Bounds{Float64}(0.0, 3.0))

  # Objective functions
  f1 = x -> 4.0 * x[1] * x[1] + 4.0 * x[2] * x[2]
  f2 = x -> (x[1] - 5.0) * (x[1] - 5.0) + (x[2] - 5.0) * (x[2] - 5.0)

  addObjective(binh2, f1)
  addObjective(binh2, f2)

  # Constraints
  c1 = x -> -((x[1] - 5.0) * (x[1] - 5.0) + x[2] * x[2] - 25.0)
  c2 = x -> (x[1] - 8.0) * (x[1] - 8.0) + (x[2] + 3.0) * (x[2] + 3.0) - 7.7

  addConstraint(binh2, c1)
  addConstraint(binh2, c2)

  return binh2
end

function tanakaProblem()
  tanaka = ContinuousProblem{Float64}("Tanaka")

  # Setting the variable bounds
  for _ in 1:2
    addVariable(tanaka, Bounds{Float64}(10e-5, π))
  end

  # Objective functions
  f1 = x -> x[1]
  f2 = x -> x[2]

  addObjective(tanaka, f1)
  addObjective(tanaka, f2)

  # Constraints
  c1 = x -> x[1] * x[1] + x[2] * x[2] - 1.0 - 0.1 * cos(16.0 * atan(x[1] / x[2]))
  c2 = x -> -2.0 * ((x[1] - 0.5) * (x[1] - 0.5) + (x[2] - 0.5) * (x[2] - 0.5) - 0.5)

  addConstraint(tanaka, c1)
  addConstraint(tanaka, c2)

  return tanaka
end

function osyczka2Problem()
  osyczka2 = ContinuousProblem{Float64}("Osyczka2")

  # Setting the variable bounds
  bounds = [(0.0, 10.0), (0.0, 10.0), (1.0, 5.0), (0.0, 6.0), (1.0, 5.0), (0.0, 10.0)]
  for (lower, upper) in bounds
    addVariable(osyczka2, Bounds{Float64}(lower, upper))
  end

  # Objective functions
  f1 = x -> -(25.0 * (x[1] - 2.0)^2 + (x[2] - 2.0)^2 + (x[3] - 1.0)^2 + (x[4] - 4.0)^2 + (x[5] - 1.0)^2)
  f2 = x -> x[1]^2 + x[2]^2 + x[3]^2 + x[4]^2 + x[5]^2 + x[6]^2

  addObjective(osyczka2, f1)
  addObjective(osyczka2, f2)

  # Constraints
  c1 = x -> (x[1] + x[2]) / 2.0 - 1.0
  c2 = x -> (6.0 - x[1] - x[2]) / 6.0
  c3 = x -> (2.0 - x[2] + x[1]) / 2.0
  c4 = x -> (2.0 - x[1] + 3.0 * x[2]) / 2.0
  c5 = x -> (4.0 - (x[3] - 3.0)^2 - x[4]) / 4.0
  c6 = x -> ((x[5] - 3.0)^2 + x[6] - 4.0) / 4.0

  addConstraint(osyczka2, c1)
  addConstraint(osyczka2, c2)
  addConstraint(osyczka2, c3)
  addConstraint(osyczka2, c4)
  addConstraint(osyczka2, c5)
  addConstraint(osyczka2, c6)

  return osyczka2
end

function golinskiProblem()
  golinski = ContinuousProblem{Float64}("Golinski")

  # Setting the variable bounds
  bounds = [(2.6, 3.6), (0.7, 0.8), (17.0, 28.0), (7.3, 8.3), (7.3, 8.3), (2.9, 3.9), (5.0, 5.5)]
  for (lower, upper) in bounds
    addVariable(golinski, Bounds{Float64}(lower, upper))
  end

  # Objective functions
  f1 = x -> 0.7854 * x[1] * x[2]^2 * ((10 * x[3]^2) / 3.0 + 14.933 * x[3] - 43.0934) -
          1.508 * x[1] * (x[6]^2 + x[7]^2) +
          7.477 * (x[6]^3 + x[7]^3) +
          0.7854 * (x[4] * x[6]^2 + x[5] * x[7]^2)

  aux = x -> 745.0 * x[4] / (x[2] * x[3])
  f2 = x -> sqrt((aux(x))^2 + 1.69e7) / (0.1 * x[6]^3)

  addObjective(golinski, f1)
  addObjective(golinski, f2)

  # Constraints
  c = Vector{Function}(undef, 11)

  c[1] = x -> -((1.0 / (x[1] * x[2]^2 * x[3])) - (1.0 / 27.0))
  c[2] = x -> -((1.0 / (x[1] * x[2]^2 * x[3]^2)) - (1.0 / 397.5))
  c[3] = x -> -((x[4]^4) / (x[2] * x[3]^2 * x[6]^6) - (1.0 / 1.93))
  c[4] = x -> -((x[5]^4) / (x[2] * x[3] * x[7]^6) - (1.0 / 1.93))
  c[5] = x -> -(x[2] * x[3] - 40.0)
  c[6] = x -> -((x[1] / x[2]) - 12.0)
  c[7] = x -> -(5.0 - (x[1] / x[2]))
  c[8] = x -> -(1.9 - x[4] + 1.5 * x[6])
  c[9] = x -> -(1.9 - x[5] + 1.1 * x[7])
  c[10] = x -> -(f2(x) - 1300)
  c[11] = x -> begin
    a = 745.0 * x[5] / (x[2] * x[3])
    b = 1.575e8
    -(sqrt(a * a + b) / (0.1 * x[7]^3) - 1100.0)
  end

  for constraint in c
    addConstraint(golinski, constraint)
  end

  return golinski
end
