using MetaJul

# NSGA-II algorithm example configured from the NSGA-II template

function main()

    problem = srinivas()

    solver::NSGAII = NSGAII(
        problem,
        populationSize = 50, 
        termination = TerminationByEvaluations(20000),
        crossover = SBXCrossover(probability = 1.0, distributionIndex = 20.0, bounds = problem.bounds),
        mutation = PolynomialMutation(probability = 1.0 / numberOfVariables(problem), distributionIndex = 20.0, bounds = problem.bounds))

    solver.dominanceComparator = ConstraintsAndDominanceComparator()

    optimize!(solver)

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, foundSolutions(solver))

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, foundSolutions(solver))
    println("Computing time: ", computingTime(solver))
end