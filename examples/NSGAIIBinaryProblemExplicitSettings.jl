using MetaJul

using Dates

# NSGA-II algorithm example configured from the NSGA-II template
function main()
    problem = oneZeroMax(512)

    solver::NSGAII = NSGAII(populationSize = 50, termination = TerminationByEvaluations(2000))
    solver.problem = problem

    solver.mutation = BitFlipMutation(1.0 / numberOfVariables(problem))
    solver.crossover = SinglePointCrossover(1.0)

    startingTime = Dates.now()
    optimize(solver)
    endTime = Dates.now()

    front = foundSolutions(solver)

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, front)

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, front)
    println("Computing time: ", (endTime - startingTime))
end