using MetaJul
using Dates

# NSGA-II algorithm example configured from the NSGA-II template
function main()
    problem = integerProblem()

    solver::NSGAII = NSGAII()
    solver.problem = problem
    solver.populationSize = 50

    solver.termination = TerminationByEvaluations(2500)

    solver.mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)
    solver.crossover = IntegerSBXCrossover(1.0, 20.0, problem.bounds)

    solver.dominanceComparator = ConstraintsAndDominanceComparator()

    startingTime = Dates.now()
    optimize(solver)
    endTime = Dates.now()

    foundSolutions = solver.foundSolutions
    for solution in foundSolutions
        solution.objectives[1] = -1 * solution.objectives[1]
    end

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, foundSolutions)

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, foundSolutions)
    println("Computing time: ", (endTime - startingTime))
end