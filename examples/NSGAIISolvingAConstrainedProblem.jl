include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/algorithm.jl")
include("../src/component.jl")
include("../src/utils.jl")
include("../src/constrainedProblem.jl")

using Dates

# NSGA-II algorithm example configured from the NSGA-II template

problem = constrExProblem()

solver::NSGAII = NSGAII()
solver.problem = problem
solver.populationSize = 100

solver.termination = TerminationByEvaluations((numberOfEvaluationsToStop = 25000, ))

solver.mutation = PolynomialMutation((probability=1.0/numberOfVariables(problem), distributionIndex=20.0, bounds=problem.bounds))
solver.crossover = SBXCrossover((probability=1.0, distributionIndex=20.0, bounds=problem.bounds))

solver.dominanceComparator = compareForConstraintsAndDominance

startingTime = Dates.now()
optimize(solver)
endTime = Dates.now()

foundSolutions = solver.foundSolutions

objectivesFileName = "FUN.csv"
variablesFileName = "VAR.csv"

println("Algorithm: ", name(solver))

println("Objectives stored in file ", objectivesFileName)
printObjectivesToCSVFile(objectivesFileName, foundSolutions)

println("Variables stored in file ", variablesFileName)
printVariablesToCSVFile(variablesFileName, foundSolutions)
println("Computing time: ", (endTime - startingTime))