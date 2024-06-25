function localSearchIsProperlyInitialized()
    problem = schaffer()
    startingSolution = createSolution(problem)
    mutation = PolynomialMutation(probability = 1.0 / numberOfVariables(problem), distributionIndex = 20.0, bounds = problem.bounds)
    termination = TerminationByIterations(1000)

    algorithm = LocalSearch(startingSolution, problem, termination = termination, mutation = mutation)

    return problem == algorithm.problem && termination == algorithm.termination && mutation == algorithm.mutation && startingSolution == algorithm.startingSolution
end

function localSearchWithZeroIterationsReturnsTheStartingSolution()
    problem = schaffer()
    startingSolution = createSolution(problem)
    mutation = UniformMutation(probability = 0.01, perturbation = 20.0, bounds = problem.bounds)

    algorithm = LocalSearch()
    algorithm.problem = problem
    algorithm.termination = TerminationByIterations(0)
    algorithm.startingSolution = startingSolution
    algorithm.mutation = mutation

    optimize!(algorithm)

    return startingSolution == algorithm.currentSolution
end

@testset "Constraint handling functions tests" begin
    @test localSearchIsProperlyInitialized()
    @test localSearchWithZeroIterationsReturnsTheStartingSolution()
end

