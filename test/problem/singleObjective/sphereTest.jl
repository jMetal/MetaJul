numberOfVariablesForSphere = 10
problem = sphere(numberOfVariablesForSphere)
solution = createSolution(problem)
@testset "Sphere problem tests" begin    
    @test numberOfVariables(problem) == numberOfVariablesForSphere
    @test numberOfObjectives(problem) == 1
    @test numberOfConstraints(problem) == 0
    @test name(sphere) == "Sphere"

    @test length(solution.variables) == numberOfVariables(problem)
    @test length(solution.objectives) == numberOfObjectives(problem)
    @test length(solution.constraints) == numberOfConstraints(problem)

    @test solution.bounds == problem.bounds
    @test solution.variables[1] <= bounds(problem)[1].upperBound
    @test solution.variables[1] >= bounds(problem)[1].lowerBound
end
