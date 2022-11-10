include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/continuousProblem.jl")
include("../src/algorithm.jl")
include("../src/component.jl")
include("../src/utils.jl")

using Dates

# NSGA-II algorithm configured from the evolutionary algorithm template. It incorporates an external archive to store the non-dominated solution found. This archive will be the algorithm output.

problem = zdt4Problem()

solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
solver.name = "NSGA-II"
solver.problem = problem
solver.populationSize = 100
solver.offspringPopulationSize = 100

solver.solutionsCreation = DefaultSolutionsCreation((problem = solver.problem, numberOfSolutionsToCreate = solver.populationSize))

externalArchive = CrowdingDistanceArchive(solver.populationSize, ContinuousSolution{Float64})
solver.evaluation = SequentialEvaluationWithArchive((archive = externalArchive, problem = solver.problem))

solver.termination = TerminationByEvaluations((numberOfEvaluationsToStop = 25000, ))

mutation = PolynomialMutation((probability=1.0/numberOfVariables(problem), distributionIndex=20.0, bounds=problem.bounds))
"""
crossover = BLXAlphaCrossover((probability=1.0, alpha=0.5, bounds=problem.bounds))
"""
crossover = SBXCrossover((probability=1.0, distributionIndex=20.0, bounds=problem.bounds))

solver.variation = CrossoverAndMutationVariation((offspringPopulationSize = solver.offspringPopulationSize, crossover = crossover, mutation = mutation))

solver.selection = BinaryTournamentSelection((matingPoolSize = solver.variation.matingPoolSize, comparator = compareRankingAndCrowdingDistance))

solver.replacement = RankingAndDensityEstimatorReplacement((comparator = compareRankingAndCrowdingDistance, ))

startingTime = Dates.now()
optimize(solver)
endTime = Dates.now()

foundSolutions = getSolutions(externalArchive)

objectivesFileName = "FUN.csv"
variablesFileName = "VAR.csv"

println("Algorithm: ", name(solver))

println("Objectives stored in file ", objectivesFileName)
printObjectivesToCSVFile(objectivesFileName, foundSolutions)

println("Variavbles stored in file ", variablesFileName)
printVariablesToCSVFile(variablesFileName, foundSolutions)
println("Computing time: ", (endTime - startingTime))
