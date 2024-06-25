using MetaJul

# Local search example 
function main()
    problem = sphere(20)
    startingSolution::Solution = createSolution(problem)
    startingSolution = evaluate(startingSolution, problem)

    mutation = PolynomialMutation(probability = 1.0 / numberOfVariables(problem), distributionIndex = 20.0, bounds = problem.bounds)
    termination = TerminationByIterations(10000) 

    solver::LocalSearch = LocalSearch(
        startingSolution, 
        problem,
        termination = termination, 
        mutation = mutation)
   
    optimize!(solver)

    foundSolution = solver.currentSolution

    println("Local search result: ", foundSolution)
    println("Fitness of the starting solution: ", startingSolution.objectives[1])
    println("Fitness of the found solution: ", foundSolution.objectives[1])
    println("Computing time: ", computingTime(solver))
end