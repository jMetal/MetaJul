numberOfBits = 128
problem = oneZeroMax(numberOfBits)
solution = createSolution(problem)
@testset "OneZeroMax problem tests" begin    
    @test numberOfVariables(problem) == 128
    @test numberOfObjectives(problem) == 2
    @test numberOfConstraints(problem) == 0
    @test name(problem) == "OneZeroMax"

    @test length(solution.variables) == numberOfVariables(problem)
    @test length(solution.objectives) == numberOfObjectives(problem)
    @test length(solution.constraints) == numberOfConstraints(problem)
end