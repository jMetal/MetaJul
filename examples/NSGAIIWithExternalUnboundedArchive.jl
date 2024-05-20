using metajul
using Dates

# NSGA-II algorithm configured from the evolutionary algorithm template. It incorporates an external archive to store the non-dominated solution found. This archive will be the algorithm output.

function main()
    problem = ZDT1()

    solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
    solver.name = "NSGA-II"
    populationSize = 100
    offspringPopulationSize = 100

    solver.solutionsCreation = DefaultSolutionsCreation(problem, populationSize)

    externalArchive = NonDominatedArchive(ContinuousSolution{Float64})
    solver.evaluation = SequentialEvaluationWithArchive(problem, externalArchive)

    solver.termination = TerminationByEvaluations(25000)

    mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)

    crossover = SBXCrossover(0.9, 20.0, problem.bounds)

    solver.variation = CrossoverAndMutationVariation(offspringPopulationSize, crossover, mutation)

    solver.selection = BinaryTournamentSelection(solver.variation.matingPoolSize, DefaultDominanceComparator())

    solver.replacement = RankingAndDensityEstimatorReplacement(DominanceRanking(DefaultDominanceComparator()), CrowdingDistanceDensityEstimator())

    startingTime = Dates.now()
    optimize(solver)
    foundSolutions = solver.foundSolutions
    endTime = Dates.now()

    foundSolutions = getSolutions(externalArchive)

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, foundSolutions)

    println("Variavbles stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, foundSolutions)
    println("Computing time: ", (endTime - startingTime))
end