include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/continuousProblem.jl")
include("../src/algorithm.jl")
include("../src/component.jl")
include("../src/utils.jl")

using Dates

# Genetic algorithm example applied to problem Sphere
problem = sphereProblem(100)

solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
solver.problem = problem
solver.populationSize = 100
solver.offspringPopulationSize = 100

solver.solutionsCreation = defaultSolutionsCreation
solver.solutionsCreationParameters = (problem = solver.problem, numberOfSolutionsToCreate = solver.populationSize)

solver.evaluation = sequentialEvaluation
solver.evaluationParameters = (problem = solver.problem, )

solver.termination = terminationByEvaluations
solver.terminationParameters = (numberOfEvaluationToStop = 75000, )

solver.selection = solver.selection = binaryTournamentMatingPoolSelection
solver.selectionParameters = (matingPoolSize = 100, comparator = compareIthObjective)

solver.variation = crossoverAndMutationVariation
solver.variationParameters = (offspringPopulationSize = 100, mutation = polynomialMutation, mutationParameters = (probability=1.0/numberOfVariables(problem), distributionIndex = 20.0, bounds=problem.bounds),
crossover = blxAlphaCrossover, crossoverParameters = (probability = 0.9, alpha = 0.5, bounds=problem.bounds))

solver.replacement = solver.replacement = muPlusLambdaReplacement
solver.replacementParameters = (comparator = compareIthObjective, )

startingTime = Dates.now()
optimize(solver)
endTime = Dates.now()

foundSolutions = solver.foundSolutions

printObjectivesToCSVFile("FUN.csv", [foundSolutions[1]])
printVariablesToCSVFile("VAR.csv", [foundSolutions[1]])

println("Best solution found: ", foundSolutions[1].objectives[1])
println("Computing time: ", (endTime - startingTime))
