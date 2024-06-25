using MetaJul

# NSGA-II algorithm example configured from the NSGA-II template

function main()

    problem = srinivas()

    solver::NSGAII = NSGAII()
    solver.problem = problem
    solver.populationSize = 100

    solver.termination = TerminationByEvaluations(25000)

    solver.mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)
    solver.crossover = SBXCrossover(probability = 1.0, distributionIndex = 20.0, bounds = problem.bounds)

    solver.dominanceComparator = ConstraintsAndDominanceComparator()

    optimize(solver)

    foundSolutions = solver.foundSolutions

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, foundSolutions)

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, foundSolutions)
    println("Computing time: ", computingTime(solver))
end