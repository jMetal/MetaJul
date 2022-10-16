include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/continuousProblem.jl")
include("../src/algorithm.jl")
include("../src/component.jl")
include("../src/utils.jl")

using Dates

# NSGA-II algorithm configured from a generic evolutionary algorithm template
problem = kursaweProblem()

solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
solver.problem = problem
solver.populationSize = 100
solver.offspringPopulationSize = 100

solver.solutionsCreation = defaultSolutionsCreation
solver.solutionsCreationParameters = (problem = solver.problem, numberOfSolutionsToCreate = solver.populationSize)

solver.evaluation = sequentialEvaluation
solver.evaluationParameters = (problem = solver.problem, )

solver.termination = terminationByEvaluations
solver.terminationParameters = (numberOfEvaluationToStop = 25000, )

solver.selection = solver.selection = binaryTournamentMatingPoolSelection
solver.selectionParameters = (matingPoolSize = 100, comparator = compareRankingAndCrowdingDistance)

solver.variation = crossoverAndMutationVariation
solver.variationParameters = (offspringPopulationSize = solver.offspringPopulationSize, mutation = polynomialMutation, mutationParameters = (probability=1.0/numberOfVariables(problem), distributionIndex = 20.0, bounds=problem.bounds),
crossover = blxAlphaCrossover, crossoverParameters = (probability = 0.9, alpha = 0.5, bounds=problem.bounds))

solver.replacement = rankingAndDensityEstimatorReplacement
solver.replacementParameters = (comparator = compareRankingAndCrowdingDistance, )

startingTime = Dates.now()
optimize(solver)
endTime = Dates.now()

foundSolutions = solver.foundSolutions

objectivesFileName = "FUN.csv"
variablesFileName = "VAR.csv"

println("Objectives stored in file ", objectivesFileName)
printObjectivesToCSVFile(objectivesFileName, foundSolutions)

println("Variavbles stored in file ", variablesFileName)
printVariablesToCSVFile(variablesFileName, foundSolutions)
println("Computing time: ", (endTime - startingTime))