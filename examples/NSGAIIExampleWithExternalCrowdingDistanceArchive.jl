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

solver.solutionsCreation = DefaultSolutionsCreation((problem = solver.problem, numberOfSolutionsToCreate = solver.populationSize))

externalArchive = CrowdingDistanceArchive(solver.populationSize, ContinuousSolution{Float64})
solver.evaluation = sequentialEvaluationWithArchive
solver.evaluationParameters = (archive = externalArchive, problem = solver.problem)

solver.termination = terminationByEvaluations
solver.terminationParameters = (numberOfEvaluationToStop = 25000, )

solver.selection = solver.selection = binaryTournamentMatingPoolSelection
solver.selectionParameters = (matingPoolSize = 100, comparator = compareRankingAndCrowdingDistance)

solver.mutation = PolynomialMutation((probability=1.0, distributionIndex=20.0, bounds=problem.bounds))

"""
solver.crossover = BLXAlphaCrossover((probability=1.0, alpha=0.5, bounds=problem.bounds))
"""

solver.crossover = SBXCrossover((probability=1.0, distributionIndex=20.0, bounds=problem.bounds))

startingTime = Dates.now()
optimize(solver)
endTime = Dates.now()

foundSolutions = getSolutions(externalArchive)

objectivesFileName = "FUN.csv"
variablesFileName = "VAR.csv"

println("Objectives stored in file ", objectivesFileName)
printObjectivesToCSVFile(objectivesFileName, foundSolutions)

println("Variables stored in file ", variablesFileName)
printVariablesToCSVFile(variablesFileName, foundSolutions)
println("Computing time: ", (endTime - startingTime))
