using MetaJul

using Dates

# NSGA-II algorithm example configured from the NSGA-II template
function main()
    problem = oneZeroMax(512)

    solver::NSGAII = NSGAII(problem)

    optimize!(solver)

    front = foundSolutions(solver)

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, front)

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, front)
    println("Computing time: ", computingTime(solver))

end