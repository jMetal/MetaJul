using MetaJul
using Dates
using Random

# NSGA-II algorithm configured from the evolutionary algorithm template
function main()
    Random.seed!(1)
    problem = ZDT4()

    solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
    solver.name = "NSGA-II"

    populationSize = 8
    offspringPopulationSize = 8

    solver.solutionsCreation = DefaultSolutionsCreation(problem, populationSize)
    solver.evaluation = SequentialEvaluation(problem)
    solver.termination = TerminationByEvaluations(20)

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