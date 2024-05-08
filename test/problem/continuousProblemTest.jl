# Test cases for continuous problem
continuousTestProblem = ContinuousProblem{Real}([],[],[],"")
addObjective(continuousTestProblem, x -> x[1] + 1)
addObjective(continuousTestProblem, x -> x[2] + x[2])
addVariable(continuousTestProblem, Bounds{Real}(-1.0, 1.0))
addVariable(continuousTestProblem, Bounds{Real}(4.0, 8.0))
addVariable(continuousTestProblem, Bounds{Real}(15.2, 18.7))
addConstraint(continuousTestProblem, x -> x[1] < 2)
setName(continuousTestProblem, "TestProblem")

@testset "ContinuousProblem tests" begin    
    @test numberOfVariables(continuousTestProblem) == 3
    @test numberOfObjectives(continuousTestProblem) == 2
    @test numberOfConstraints(continuousTestProblem) == 1
    @test name(continuousTestProblem) == "TestProblem"

    @test length(continuousTestProblem.bounds) == 3
end
