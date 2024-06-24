using MetaJul

# NSGA-II algorithm example configured from the NSGA-II template
function main()
    problem = ZDT1()

    solver::NSGAII = NSGAII(problem)

    observer = FrontPlotObserver(1000, name(problem), readFrontFromCSVFile("data/referenceFronts/ZDT1.csv"))
    register!(observable(solver), observer)

    optimize(solver)

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