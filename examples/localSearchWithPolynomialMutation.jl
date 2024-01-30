include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/continuousProblem.jl")
include("../src/algorithm.jl")

using Dates

# Local search example 
problem = sphereProblem(20)
solution::Solution = createSolution(problem)
solution = evaluate(solution, problem)

solver::LocalSearch = LocalSearch()
solver.startingSolution = solution
solver.problem = problem
solver.numberOfIterations = 10000
solver.mutation = polynomialMutation
solver.mutationParameters = (probability=0.1, distributionIndex=20.0, bounds=problem.bounds)

startingTime = Dates.now()
optimize(solver)
endTime = Dates.now()

foundSolution = solver.foundSolution

println("Local search result: ", foundSolution)
println("Fitness of the starting solution: ", solution.objectives[1])
println("Fitness of the found solution: ", foundSolution.objectives[1])
println("Computing time: ", (endTime - startingTime))
