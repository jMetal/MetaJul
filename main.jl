include("src/bounds.jl")
include("src/solution.jl")
include("src/operator.jl")
include("src/problem.jl")
include("src/ranking.jl")
include("src/algorithm.jl")

println(dominanceComparator([1,2,3], [1,1,4]))

# Local search example 
solution = createSolution(sphereProblem(10))
solution = evaluate(solution, sphereProblem(10))
println("Local search: ", localSearch(solution, sphereProblem(10), 10000, uniformMutationOperator, (probability=0.2, perturbation=0.5)))

