include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/binaryProblem.jl")
include("../src/algorithm.jl")
include("../src/component.jl")

using Dates

# Genetic algorithm example applied to problem OneMax
problem = oneMax(1024)

solver::GeneticAlgorithm = GeneticAlgorithm()
solver.problem = problem
solver.numberOfEvaluations = 40000
solver.populationSize = 100
solver.offspringPopulationSize = 100
solver.mutation = bitFlipMutation
solver.mutationParameters = (probability=1.0/numberOfVariables(problem),)
solver.crossover = singlePointCrossover
solver.crossoverParameters = (probability = 1.0,)

solver.solutionsCreation = defaultSolutionsCreation

solver.evaluation = sequentialEvaluation

solver.termination = terminationByEvaluations

solver.selection = binaryTournamentSelection
solver.selectionParameters = (matingPoolSize = 100, comparator = objectiveComparator)

solver.variation = crossoverAndMutationVariation

solver.replacement = muPlusLambdaReplacement
solver.replacementComparator = objectiveComparator

startingTime = Dates.now()
optimize(solver)
endTime = Dates.now()

foundSolutions = solver.foundSolutions

println("GA result: ", length(foundSolutions))
println("Result: ", foundSolutions[1].objectives)
println("Result: ", foundSolutions[1].variables)
println("Computing time: ", (endTime - startingTime))
