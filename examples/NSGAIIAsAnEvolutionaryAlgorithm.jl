include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/continuousProblem.jl")
include("../src/algorithm.jl")
include("../src/component.jl")
include("../src/utils.jl")

using Dates

# NSGA-II algorithm configured from the evolutionary algorithm template
problem = zdt1Problem()

solver::EvolutionaryAlgorithm = EvolutionaryAlgorithm()
solver.name = "NSGA-II"

solver.problem = problem
solver.populationSize = 100
solver.offspringPopulationSize = 100

solver.solutionsCreation = DefaultSolutionsCreation((problem = solver.problem, numberOfSolutionsToCreate = solver.populationSize))

solver.evaluation = SequentialEvaluation((problem = solver.problem, ))

solver.termination = TerminationByEvaluations((numberOfEvaluationsToStop = 25000, ))

mutation = PolynomialMutation((probability=1.0/numberOfVariables(problem), distributionIndex=20.0, bounds=problem.bounds))

#mutation = UniformMutation((probability=1.0/numberOfVariables(problem), perturbation=20.0, bounds=problem.bounds))

"""
crossover = BLXAlphaCrossover((probability=1.0, alpha=0.5, bounds=problem.bounds))
"""
crossover = SBXCrossover((probability=0.9, distributionIndex=20.0, bounds=problem.bounds))

solver.variation = CrossoverAndMutationVariation((offspringPopulationSize = solver.offspringPopulationSize, crossover = crossover, mutation = mutation))

solver.selection = BinaryTournamentSelection((matingPoolSize = solver.variation.matingPoolSize, comparator = compareRankingAndCrowdingDistance))

solver.replacement = RankingAndDensityEstimatorReplacement((dominanceComparator = compareForDominance, ))

startingTime = Dates.now()
#optimize(solver)
foundSolutions = evolutionaryAlgorithm(solver)
endTime = Dates.now()

#foundSolutions = solver.foundSolutions

objectivesFileName = "FUN.csv"
variablesFileName = "VAR.csv"

println("Algorithm: ", name(solver))

println("Objectives stored in file ", objectivesFileName)
printObjectivesToCSVFile(objectivesFileName, foundSolutions)

println("Variables stored in file ", variablesFileName)
printVariablesToCSVFile(variablesFileName, foundSolutions)
println("Computing time: ", (endTime - startingTime))
