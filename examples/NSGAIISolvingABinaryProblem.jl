using metajul

using Dates

# NSGA-II algorithm example configured from the NSGA-II template
function main()
    problem = oneZeroMax(512)

    solver::NSGAII = NSGAII()
    solver.problem = problem
    solver.populationSize = 100

    solver.termination = TerminationByEvaluations(25000)

    solver.mutation = BitFlipMutation(1.0 / numberOfVariables(problem))
    solver.crossover = SinglePointCrossover(1.0)

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