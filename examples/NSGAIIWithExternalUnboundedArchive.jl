using MetaJul

# NSGA-II algorithm configured from the evolutionary algorithm template. It incorporates an external archive to store the non-dominated solution found. This archive will be the algorithm output.

function main()
    problem = DTLZ1()

    solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
    solver.name = "NSGA-II"
    populationSize = 100
    offspringPopulationSize = 100

    solver.solutionsCreation = DefaultSolutionsCreation(problem, populationSize)

    externalArchive = NonDominatedArchive(ContinuousSolution{Float64})
    solver.evaluation = SequentialEvaluationWithArchive(problem, externalArchive)

    solver.termination = TerminationByEvaluations(50000)

    mutation = PolynomialMutation(probability = 1.0 / numberOfVariables(problem), distributionIndex = 20.0, bounds = problem.bounds)

    crossover = SBXCrossover(probability = 0.9, distributionIndex = 20.0, bounds = problem.bounds)

    solver.variation = CrossoverAndMutationVariation(offspringPopulationSize, crossover, mutation)

    solver.selection = BinaryTournamentSelection(solver.variation.matingPoolSize, DefaultDominanceComparator())

    solver.replacement = RankingAndDensityEstimatorReplacement(DominanceRanking(DefaultDominanceComparator()), CrowdingDistanceDensityEstimator())

    optimize!(solver)

    archiveSolutions = getSolutions(externalArchive)
    foundSolutions = distanceBasedSubsetSelection(archiveSolutions, populationSize)

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))
    println("Archive size: ", length(archiveSolutions), " → selected: ", length(foundSolutions))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, foundSolutions)

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, foundSolutions)
    println("Computing time: ", computingTime(solver))
end
main()
