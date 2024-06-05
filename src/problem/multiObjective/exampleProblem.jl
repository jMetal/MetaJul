function exampleProblem()
    problem = ContinuousProblem{Int64}("exampleProblem")

    addVariable(problem, Bounds{Int64}(0, 20))  # Assuming some bounds for x1
    addVariable(problem, Bounds{Int64}(0, 20))  # Assuming some bounds for x2

    f1 = x -> -1.0 * (x[1] + x[2])
    f2 = x -> x[1] + 3 * x[2]

    addObjective(problem, f1)
    addObjective(problem, f2)

    c1 = x -> -2 * x[1] - 3 * x[2] + 30.0
    c2 = x -> -3 * x[1] - 2 * x[2] + 30.0
    c3 = x -> -x[1] + x[2] + 5.5

    addConstraint(problem, c1)
    addConstraint(problem, c2)
    addConstraint(problem, c3)

    return problem
end
