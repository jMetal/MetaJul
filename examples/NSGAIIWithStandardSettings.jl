using metajul

using Dates

# NSGA-II algorithm example configured from the NSGA-II template

function main()
    problem = ZDT1()

    solver::NSGAII = NSGAII()
    solver.populationSize = 100

    solver.termination = TerminationByEvaluations(25000)

    solver.mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)
    solver.crossover = SBXCrossover(1.0, 20.0, problem.bounds)

    """
    solver.crossover = BLXAlphaCrossover(1.0, 0.5, problem.bounds))
    """

    startingTime = Dates.now()
    optimize(solver)
    endTime = Dates.now()

    foundSolutions = solver.foundSolutions

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, foundSolutions)

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, foundSolutions)
    println("Computing time: ", (endTime - startingTime))
end