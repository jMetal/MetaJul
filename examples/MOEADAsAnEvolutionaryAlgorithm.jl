using MetaJul
using Dates
using Random

# MOEA/D algorithm configured from the evolutionary algorithm template
function main()
    problem = ZDT4()

    solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
    solver.name = "MOEA/D"

    populationSize = 100
    neighborhoodSize = 20
    offspringPopulationSize = 1
    maximumNumberOfReplacedSolutions = 2
    normalizeObjectives = false

    solver.solutionsCreation = DefaultSolutionsCreation(problem, populationSize)
    solver.evaluation = SequentialEvaluation(problem)
    solver.termination = TerminationByEvaluations(25000)

    mutation = PolynomialMutation(probability = 1.0 / numberOfVariables(problem), distributionIndex = 20.0, bounds = problem.bounds)
    crossover = SBXCrossover(probability = 0.9, distributionIndex = 20.0, bounds = problem.bounds)

    """
    mutation = UniformMutation(1.0/numberOfVariables(problem), 20.0, problem.bounds)
    crossover = BLXAlphaCrossover(probability = 1.0, alpha = 0.5, bounds = problem.bounds)
    """

    solver.variation = CrossoverAndMutationVariation(offspringPopulationSize, crossover, mutation)

    neighborhood = WeightVectorNeighborhood(populationSize, neighborhoodSize)

    sequenceGenerator = IntegerPermutationGenerator(populationSize)

    selectCurrentSolution = true
    solver.selection = PopulationAndNeighborhoodSelection(solver.variation.matingPoolSize, sequenceGenerator, neighborhood, 0.9, selectCurrentSolution)

    aggregationFunction = PenaltyBoundaryIntersection(5.0, normalizeObjectives)
    #aggregationFunction = Tschebyscheff()
    
    solver.replacement = MOEADReplacement(solver.selection, neighborhood, aggregationFunction, sequenceGenerator, maximumNumberOfReplacedSolutions, normalizeObjectives)
    
    optimize!(solver)

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