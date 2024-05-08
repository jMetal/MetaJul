numberOfBits = 128
problem = oneMax(numberOfBits)
solution = createSolution(problem)
@testset "OneMax problem tests" begin    
    @test numberOfVariables(problem) == 128
    @test numberOfObjectives(problem) == 1
    @test numberOfConstraints(problem) == 0
    @test name(problem) == "OneMax"

    @test length(solution.variables) == numberOfVariables(problem)
    @test length(solution.objectives) == numberOfObjectives(problem)
    @test length(solution.constraints) == numberOfConstraints(problem)
end