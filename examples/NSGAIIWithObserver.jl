using MetaJul
using Dates

# NSGA-II algorithm example configured from the NSGA-II template
function main()
    problem = ZDT1()

    solver::NSGAII = NSGAII()
    solver.problem = problem
    solver.populationSize = 100

    solver.termination = TerminationByEvaluations(20000)

    solver.mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)
    solver.crossover = SBXCrossover(1.0, 20.0, problem.bounds)

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
    println("Computing time: ", status(solver)["COMPUTING_TIME"])
end