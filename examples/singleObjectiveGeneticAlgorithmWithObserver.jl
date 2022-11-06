include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/binaryProblem.jl")
include("../src/algorithm.jl")
include("../src/component.jl")
include("../src/utils.jl")

using Dates

# Genetic algorithm example applied to problem OneMax
problem = oneMax(512)

solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
solver.name = "Genetic Algorithm"
solver.problem = problem
solver.populationSize = 100
solver.offspringPopulationSize = 100

solver.solutionsCreation = DefaultSolutionsCreation((problem = solver.problem, numberOfSolutionsToCreate = solver.populationSize))

solver.evaluation = SequentialEvaluation((problem = solver.problem, ))

solver.termination = TerminationByEvaluations((numberOfEvaluationsToStop = 40000, ))

mutation = BitFlipMutation((probability=1.0/numberOfVariables(problem),))
crossover = SinglePointCrossover((probability=1.0,))
solver.variation = CrossoverAndMutationVariation((offspringPopulationSize = solver.offspringPopulationSize, crossover = crossover, mutation = mutation))

solver.selection = BinaryTournamentSelection((matingPoolSize = solver.variation.matingPoolSize, comparator = compareIthObjective))

solver.replacement = MuPlusLambdaReplacement((comparator = compareIthObjective, ))

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
