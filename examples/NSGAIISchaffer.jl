include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/continuousProblem.jl")
include("../src/algorithm.jl")
include("../src/component.jl")
include("../src/utils.jl")

using Dates

# Genetic algorithm example applied to problem Schaffer
problem = kursaweProblem()

solver::GeneticAlgorithm = GeneticAlgorithm()
solver.problem = problem
solver.numberOfEvaluations = 25000
solver.populationSize = 100
solver.offspringPopulationSize = 100

solver.solutionsCreation = defaultSolutionsCreation

solver.evaluation = sequentialEvaluation

solver.termination = terminationByEvaluations

solver.selection = solver.selection = binaryTournamentMatingPoolSelection
solver.selectionParameters = (matingPoolSize = 100, comparator = compareRankingAndCrowdingDistance)

solver.variation = crossoverAndMutationVariation
solver.mutation = polynomialMutation
solver.mutationParameters = (probability=1.0/numberOfVariables(problem), distributionIndex = 20.0, bounds=problem.bounds)
solver.crossover = blxAlphaCrossover
solver.crossoverParameters = (probability = 0.9, alpha = 0.5, bounds=problem.bounds)

solver.replacement = rankingAndDensityEstimatorReplacement
solver.replacementComparator = compareRankingAndCrowdingDistance

startingTime = Dates.now()
optimize(solver)
endTime = Dates.now()

foundSolutions = solver.foundSolutions

printObjectivesToCSVFile("FUN.csv", foundSolutions)

println("GA result: ", length(foundSolutions))
println("Best found solution: ", foundSolutions[1].objectives[1])
println("Computing time: ", (endTime - startingTime))
