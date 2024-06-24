using MetaJul

# Local search example 
function main()
    problem = sphere(10)
    startingSolution::Solution = createSolution(problem)
    startingSolution = evaluate(startingSolution, problem)

    termination = TerminationByIterations(100000) 
    mutation = UniformMutation(0.1, 0.5, problem.bounds)

    solver::LocalSearch = LocalSearch(
        startingSolution, 
        problem, 
        termination = termination, 
        mutation = mutation)
    
    optimize(solver)

    foundSolution = solver.currentSolution

    println("Local search result: ", foundSolution)
    println("Fitness of the starting solution: ", startingSolution.objectives[1])
    println("Fitness of the found solution: ", foundSolution.objectives[1])
    println("Computing time: ", computingTime(solver))

end