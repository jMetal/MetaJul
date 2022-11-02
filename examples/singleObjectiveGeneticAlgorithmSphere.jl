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
solver.name = "GA"

solver.problem = problem
solver.populationSize = 100
solver.offspringPopulationSize = 100

solver.solutionsCreation = DefaultSolutionsCreation((problem = solver.problem, numberOfSolutionsToCreate = solver.populationSize))

solver.evaluation = SequentialEvaluation((problem = solver.problem, ))

solver.termination = TerminationByEvaluations((numberOfEvaluationsToStop = 500000, ))

mutation = PolynomialMutation((probability=1.0/numberOfVariables(problem), distributionIndex=20.0, bounds=problem.bounds))
"""
solver.crossover = BLXAlphaCrossover((probability=1.0, alpha=0.5, bounds=problem.bounds))
"""
crossover = SBXCrossover((probability=1.0, distributionIndex=20.0, bounds=problem.bounds))
solver.variation = CrossoverAndMutationVariation((offspringPopulationSize = solver.offspringPopulationSize, crossover = crossover, mutation = mutation))

solver.selection = BinaryTournamentSelection((solver.variation.matingPoolSize, comparator = compareIthObjective))

solver.replacement = MuPlusLambdaReplacement((comparator = compareIthObjective, ))

startingTime = Dates.now()
optimize(solver)
endTime = Dates.now()

foundSolutions = solver.foundSolutions

println("Algorithm: ", name(solver))

printObjectivesToCSVFile("FUN.csv", [foundSolutions[1]])
printVariablesToCSVFile("VAR.csv", [foundSolutions[1]])

println("Best solution found: ", foundSolutions[1].objectives[1])
println("Computing time: ", (endTime - startingTime))
