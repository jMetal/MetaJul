using MetaJul

# NSGA-II algorithm example configured from the NSGA-II template
function main()
    tsp_data_dir = joinpath(@__DIR__, "..", "resources/tspDataFiles")

    problem = multiObjectiveTSP("kroAB100", [joinpath(tsp_data_dir, "kroA100.tsp"), joinpath(tsp_data_dir, "kroB100.tsp")])

    solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
    solver.name = "NSGA-II"

    populationSize = 100
    offspringPopulationSize = 100

    solver.solutionsCreation = DefaultSolutionsCreation(problem, populationSize)
    solver.evaluation = SequentialEvaluation(problem)
    solver.termination = TerminationByEvaluations(300000)

    mutation = PermutationSwapMutation(probability = 1.0 / numberOfVariables(problem))
    crossover = PMXCrossover(probability = 0.9)

    solver.variation = CrossoverAndMutationVariation(offspringPopulationSize, crossover, mutation)
    
    solver.selection = BinaryTournamentSelection(solver.variation.matingPoolSize, DefaultDominanceComparator())

    solver.replacement = RankingAndDensityEstimatorReplacement(DominanceRanking(DefaultDominanceComparator()), CrowdingDistanceDensityEstimator())


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