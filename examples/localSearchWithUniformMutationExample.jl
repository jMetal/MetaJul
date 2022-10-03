include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/continuousProblem.jl")
include("../src/algorithm.jl")

# Local search example 
problem = sphereProblem(10)
solution::Solution = createSolution(problem)
solution = evaluate(solution, problem)

solver::LocalSearch = LocalSearch()
solver.startingSolution = solution
solver.problem = problem
solver.numberOfIterations = 10000
solver.mutation = uniformMutationOperator
solver.mutationParameters = (probability=0.1, perturbation=0.5, bounds=problem.bounds)

optimize(solver)

foundSolution = solver.foundSolution

println("Local search result: ", foundSolution)
println("Fitness of the starting solution: ", solution.objectives[1])
println("Fitness of the found solution: ", foundSolution.objectives[1])