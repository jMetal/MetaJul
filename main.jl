include("src/bounds.jl")
include("src/solution.jl")
include("src/operator.jl")
include("src/problem.jl")
include("src/ranking.jl")
include("src/algorithm.jl")

# Local search example 
problem = sphereProblem(10)
solution = createSolution(problem)
solution = evaluate(solution, problem)
#println("Local search: ", localSearch(solution, problem, 10000, uniformMutationOperator, (probability=0.1, perturbation=0.5, bounds=problem.bounds)))

println("Local search: ", localSearch(solution, problem, 10000, polynomialMutationOperator, (probability=0.1, distributionIndex=20.0, bounds=problem.bounds)))
