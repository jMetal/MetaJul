using MetaJul

using Dates

# Local search example 
function main()
    problem = oneMax(512)
    startingSolution::Solution = createSolution(problem)
    startingSolution = evaluate(startingSolution, problem)

    numberOfIterations = 10000
    mutation = BitFlipMutation(1.0 / numberOfVariables(problem))

    solver::LocalSearch = LocalSearch(startingSolution, problem, numberOfIterations, mutation)

    startingTime = Dates.now()
    optimize(solver)
    endTime = Dates.now()

    foundSolution = solver.foundSolution

    println("Local search result: ", foundSolution)
    println("Fitness of the starting solution: ", -1.0startingSolution.objectives[1])
    println("Fitness of the found solution: ", -1.0 * foundSolution.objectives[1])
    println("Computing time: ", (endTime - startingTime))
end
