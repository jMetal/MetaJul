problem = schaffer()
schafferSolution = createSolution(problem)
@testset "Schaffer problem tests" begin    
    @test numberOfVariables(problem) == 1
    @test numberOfObjectives(problem) == 2
    @test numberOfConstraints(problem) == 0
    @test bounds(problem)[1].lowerBound == -1000.0
    @test bounds(problem)[1].upperBound == 1000.0
    @test name(problem) == "Schaffer"

    @test length(schafferSolution.variables) == numberOfVariables(problem)
    @test length(schafferSolution.objectives) == numberOfObjectives(problem)
    @test length(schafferSolution.constraints) == numberOfConstraints(problem)

    @test schafferSolution.bounds == schafferSolution.bounds
    @test schafferSolution.variables[1] <= schafferSolution.bounds[1].upperBound
    @test schafferSolution.variables[1] >= schafferSolution.bounds[1].lowerBound
end