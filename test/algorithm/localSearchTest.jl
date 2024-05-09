function localSearchIsProperlyInitialized()
    problem = schaffer()
    startingSolution = createSolution(problem)
    numberOfIterations = 10
    mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)

    algorithm = LocalSearch(startingSolution, problem, numberOfIterations, mutation)

    return problem == algorithm.problem && numberOfIterations == algorithm.numberOfIterations && mutation == algorithm.mutation && startingSolution == algorithm.startingSolution
end

function localSearchWithZeroIterationsReturnsTheStartingSolution()
    problem = schaffer()
    startingSolution = createSolution(problem)
    numberOfIterations = 0
    mutation = UniformMutation(0.01, 20.0, problem.bounds)

    algorithm = LocalSearch()
    algorithm.problem = problem
    algorithm.numberOfIterations = numberOfIterations
    algorithm.startingSolution = startingSolution
    algorithm.mutation = mutation
    optimize(algorithm)

    return startingSolution == algorithm.foundSolution
end

@testset "Constraint handling functions tests" begin
    @test localSearchIsProperlyInitialized()
    @test localSearchWithZeroIterationsReturnsTheStartingSolution()
end

