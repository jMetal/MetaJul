using MetaJul
using Dates

# Local search example 
function main()
    problem = sphere(20)
    startingSolution::Solution = createSolution(problem)
    startingSolution = evaluate(startingSolution, problem)

    mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)

    solver::LocalSearch = LocalSearch(
        startingSolution, 
        problem,
        numberOfIterations = 200000,
        mutation)
   
    startingTime = Dates.now()
    optimize(solver)
    endTime = Dates.now()

    foundSolution = solver.foundSolution

    println("Local search result: ", foundSolution)
    println("Fitness of the starting solution: ", startingSolution.objectives[1])
    println("Fitness of the found solution: ", foundSolution.objectives[1])
    println("Computing time: ", (endTime - startingTime))
end