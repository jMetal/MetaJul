using MetaJul
using Dates

# NSGA-II algorithm example used in the MIC 2024 tutorial
    
# Step 1: defining the problem
problem = ContinuousProblem{Int64}("integerProblem")

addVariable(problem, Bounds{Int64}(0, 20))  
addVariable(problem, Bounds{Int64}(0, 20)) 

f1 = x -> -1.0 * (x[1] + x[2]) # objective to maximize
f2 = x -> x[1] + 3 * x[2]      # objective to minimize

addObjective(problem, f1)
addObjective(problem, f2)

c1 = x -> -2 * x[1] - 3 * x[2] + 30.0
c2 = x -> -3 * x[1] - 2 * x[2] + 30.0
c3 = x -> -x[1] + x[2] + 5.5

addConstraint(problem, c1)
addConstraint(problem, c2)
addConstraint(problem, c3)

# Step 2: set NSGA-II parameters
solver::NSGAII = NSGAII(
    problem,
    populationSize = 30,
    termination = TerminationByEvaluations(2500))
    
solver.mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)
solver.crossover = IntegerSBXCrossover(1.0, 20.0, problem.bounds)

# Step 3: optimize
optimize(solver)

# Step 4: get found solutions
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
