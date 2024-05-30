using MetaJul
using Dates
using Random

# NSGA-II algorithm configured from the evolutionary algorithm template
function main()
    problem = ZDT2()

    solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
    solver.name = "NSGA-II"

    populationSize = 100
    offspringPopulationSize = 100

    solver.solutionsCreation = DefaultSolutionsCreation(problem, populationSize)
    solver.evaluation = SequentialEvaluation(problem)
    solver.termination = TerminationByEvaluations(25000)

    mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)
    crossover = SBXCrossover(0.9, 20.0, problem.bounds)

    """
    mutation = UniformMutation(1.0/numberOfVariables(problem), 20.0, problem.bounds)
    crossover = BLXAlphaCrossover(1.0, 0.5, problem.bounds)
    """

    solver.variation = CrossoverAndMutationVariation(offspringPopulationSize, crossover, mutation)
    solver.selection = BinaryTournamentSelection(solver.variation.matingPoolSize, DefaultDominanceComparator())

    solver.replacement = RankingAndDensityEstimatorReplacement(DominanceRanking(DefaultDominanceComparator()), CrowdingDistanceDensityEstimator())
    
    startingTime = Dates.now()
    optimize(solver)
    endTime = Dates.now()

    foundSolutions = solver.foundSolutions

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))
    println("Computing time: ", (endTime - startingTime))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, foundSolutions)

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, foundSolutions)
end