function localSearchIsProperlyInitialized()
    problem = schaffer()
    startingSolution = createSolution(problem)
    mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)
    termination = TerminationByIterations(1000)

    algorithm = LocalSearch(startingSolution, problem, termination = termination, mutation = mutation)

    return problem == algorithm.problem && termination == algorithm.termination && mutation == algorithm.mutation && startingSolution == algorithm.startingSolution
end

function localSearchWithZeroIterationsReturnsTheStartingSolution()
    problem = schaffer()
    startingSolution = createSolution(problem)
    mutation = UniformMutation(0.01, 20.0, problem.bounds)

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

