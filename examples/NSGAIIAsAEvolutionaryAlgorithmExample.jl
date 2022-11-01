include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/continuousProblem.jl")
include("../src/algorithm.jl")
include("../src/component.jl")
include("../src/utils.jl")

using Dates

# NSGA-II algorithm configured from a generic evolutionary algorithm template
problem = zdt1Problem()

solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
solver.problem = problem
solver.populationSize = 100
solver.offspringPopulationSize = 100

solver.solutionsCreation = DefaultSolutionsCreation((problem = solver.problem, numberOfSolutionsToCreate = solver.populationSize))

solver.evaluation = SequentialEvaluation((problem = solver.problem, ))

solver.termination = TerminationByEvaluations((numberOfEvaluationToStop = 25000, ))

solver.selection = BinaryTournamentSelection((matingPoolSize = 100, comparator = compareRankingAndCrowdingDistance))

mutation = PolynomialMutation((probability=1.0/numberOfVariables(problem), distributionIndex=20.0, bounds=problem.bounds))
"""
crossover = BLXAlphaCrossover((probability=1.0, alpha=0.5, bounds=problem.bounds))
"""
crossover = SBXCrossover((probability=1.0, distributionIndex=20.0, bounds=problem.bounds))

solver.variation = CrossoverAndMutationVariation((offspringPopulationSize = solver.offspringPopulationSize, crossover = crossover, mutation = mutation))

solver.replacement = RankingAndDensityEstimatorReplacement((comparator = compareRankingAndCrowdingDistance, ))

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
