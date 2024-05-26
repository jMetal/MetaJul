using MetaJul
using Dates

# Genetic algorithm example applied to problem OneMax
function main()
    problem = oneMax(512)

    solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
    populationSize = 100
    offspringPopulationSize = 100

    solver.solutionsCreation = DefaultSolutionsCreation(problem, populationSize)

    solver.evaluation = SequentialEvaluation(problem)

    solver.termination = TerminationByEvaluations(40000)

    mutation = BitFlipMutation(1.0 / numberOfVariables(problem))
    crossover = SinglePointCrossover(1.0)
    solver.variation = CrossoverAndMutationVariation(offspringPopulationSize, crossover, mutation)

    solver.selection = BinaryTournamentSelection(solver.variation.matingPoolSize, IthObjectiveComparator(1))

    solver.replacement = MuPlusLambdaReplacement(IthObjectiveComparator(1))

    #observer = EvaluationObserver(4000)
    observer = FitnessObserver(500)
    register!(getObservable(solver), observer)

    startingTime = Dates.now()
    optimize(solver)
    endTime = Dates.now()

    foundSolutions = solver.foundSolutions

    println("Algorithm: ", name(solver))

    printObjectivesToCSVFile("FUN.csv", [foundSolutions[1]])
    printVariablesToCSVFile("VAR.csv", [foundSolutions[1]])

    println("Fitness: ", -1.0 * foundSolutions[1].objectives[1])
    println("Solution: ", foundSolutions[1].variables)
    println("Computing time: ", (endTime - startingTime))
end