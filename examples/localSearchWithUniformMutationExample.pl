include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/operator.jl")
include("../src/problem.jl")
include("../src/ranking.jl")
include("../src/algorithm.jl")

# Local search example 
problem = sphereProblem(10)
solution = createSolution(problem)
solution = evaluate(solution, problem)

foundSolution = localSearch(solution, problem, 10000, uniformMutationOperator, (probability=0.1, perturbation=0.5, bounds=problem.bounds))
println("Local search result: ", foundSolution)
println("Fitness of the starting solution: ", solution.objectives[1])
println("Fitness of the found solution: ", foundSolution.objectives[1])