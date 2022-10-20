include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/continuousProblem.jl")
include("../src/algorithm.jl")
include("../src/component.jl")
include("../src/utils.jl")

using Dates

# NSGA-II algorithm example configured from the NSGA-II template

problem = zdt1Problem()

solver::NSGAII = NSGAII()
solver.problem = problem
solver.populationSize = 100

solver.solutionsCreation = defaultSolutionsCreation
solver.solutionsCreationParameters = (problem = solver.problem, numberOfSolutionsToCreate = solver.populationSize)

solver.evaluation = sequentialEvaluation
solver.evaluationParameters = (problem = solver.problem, )

solver.termination = terminationByEvaluations
solver.terminationParameters = (numberOfEvaluationToStop = 25000, )

solver.selection = solver.selection = binaryTournamentMatingPoolSelection
solver.selectionParameters = (matingPoolSize = 100, comparator = compareRankingAndCrowdingDistance)

solver.mutation = mutation = polynomialMutation
solver.mutationParameters = (probability=1.0/numberOfVariables(problem), distributionIndex = 20.0, bounds=problem.bounds)

"""
solver.crossover = blxAlphaCrossover
solver.crossoverParameters = (probability = 0.9, alpha = 0.5, bounds=problem.bounds)
"""

solver.crossover = sbxCrossover
solver.crossoverParameters = (probability = 1.0, distributionIndex = 20.0, bounds=problem.bounds)

startingTime = Dates.now()
optimize(solver)
endTime = Dates.now()

foundSolutions = solver.foundSolutions

objectivesFileName = "FUN.csv"
variablesFileName = "VAR.csv"

println("Objectives stored in file ", objectivesFileName)
printObjectivesToCSVFile(objectivesFileName, foundSolutions)

println("Variables stored in file ", variablesFileName)
printVariablesToCSVFile(variablesFileName, foundSolutions)
println("Computing time: ", (endTime - startingTime))
