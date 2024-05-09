using metajul

using Dates

# Local search example 
problem = oneMax(1024)
solution::Solution = createSolution(problem)
solution = evaluate(solution, problem)

solver::LocalSearch = LocalSearch()
solver.startingSolution = solution
solver.problem = problem
solver.numberOfIterations = 20000
solver.mutation = BitFlipMutation(1.0/numberOfVariables(problem))

startingTime = Dates.now()
optimize(solver)
endTime = Dates.now()

foundSolution = solver.foundSolution

println("Local search result: ", foundSolution)
println("Fitness of the starting solution: ", solution.objectives[1])
println("Fitness of the found solution: ", foundSolution.objectives[1])
println("Computing time: ", (endTime - startingTime))
