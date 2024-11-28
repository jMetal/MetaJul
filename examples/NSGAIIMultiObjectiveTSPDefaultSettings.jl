using MetaJul

# NSGA-II algorithm example configured from the NSGA-II template
function main()
    tsp_data_dir = joinpath(@__DIR__, "..", "resources/tspDataFiles")

    problem = multiObjectiveTSP("kroAB100", [joinpath(tsp_data_dir, "kroA100.tsp"), joinpath(tsp_data_dir, "kroB100.tsp")])

    solver::NSGAII = NSGAII(problem)

    optimize!(solver)

    front = foundSolutions(solver)

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName,     front)

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, front)
    println("Computing time: ", computingTime(solver))
end