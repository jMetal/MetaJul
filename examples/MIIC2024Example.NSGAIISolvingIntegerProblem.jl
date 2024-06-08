using MetaJul
using Dates

# NSGA-II algorithm example used in the MIC 2024 tutorial
    
problem = integerProblem()

solver::NSGAII = NSGAII(
    problem,
    populationSize = 30,
    termination = TerminationByEvaluations(2500),
    dominanceComparator = ConstraintsAndDominanceComparator())
    
solver.mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)
solver.crossover = IntegerSBXCrossover(1.0, 20.0, problem.bounds)

optimize(solver)

front = foundSolutions(solver)
for solution in front
    solution.objectives[1] = -1 * solution.objectives[1]
end

objectivesFileName = "FUN.csv"
variablesFileName = "VAR.csv"

println("Algorithm: ", name(solver))

println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, front)

println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, front)
    println("Computing time: ", (endTime - startingTime))
