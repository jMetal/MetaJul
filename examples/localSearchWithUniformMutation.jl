using metajul

# Local search example 
function main()
    problem = sphere(10)
    solution::Solution = createSolution(problem)
    solution = evaluate(solution, problem)

    solver::LocalSearch = LocalSearch()
    solver.startingSolution = solution
    solver.problem = problem
    solver.numberOfIterations = 10000
    solver.mutation = UniformMutation(0.1, 0.5, problem.bounds)

    optimize(solver)

    foundSolution = solver.foundSolution

    println("Local search result: ", foundSolution)
    println("Fitness of the starting solution: ", solution.objectives[1])
    println("Fitness of the found solution: ", foundSolution.objectives[1])
end