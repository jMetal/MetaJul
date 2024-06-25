using MetaJul
using Dates
using Random

# NSGA-II algorithm configured from the evolutionary algorithm template
function main()
    problem = ZDT1()

    solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
    solver.name = "NSGA-II"

    populationSize = 100
    offspringPopulationSize = 100

    solver.solutionsCreation = DefaultSolutionsCreation(problem, populationSize)
    solver.evaluation = SequentialEvaluation(problem)
    solver.termination = TerminationByEvaluations(25000)

    mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)
    crossover = SBXCrossover(probability = 0.9, distributionIndex = 20.0, bounds = problem.bounds)

    """
    mutation = UniformMutation(1.0/numberOfVariables(problem), 20.0, problem.bounds)
    crossover = BLXAlphaCrossover(probability = 1.0, alpha = 0.5, bounds = problem.bounds)
    """

    solver.variation = CrossoverAndMutationVariation(offspringPopulationSize, crossover, mutation)
    solver.selection = BinaryTournamentSelection(solver.variation.matingPoolSize, DefaultDominanceComparator())

    solver.replacement = RankingAndDensityEstimatorReplacement(DominanceRanking(DefaultDominanceComparator()), CrowdingDistanceDensityEstimator())
    
    optimize(solver)

    foundSolutions = solver.foundSolutions

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))
    println("Computing time: ", computingTime(solver))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, foundSolutions)

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, foundSolutions)
end