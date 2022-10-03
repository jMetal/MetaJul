# Test cases for continuous problems

include("../src/continuousProblem.jl")

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
end

continuousTestSolution = createSolution(continuousTestProblem)
"""
numberOfVariablesForSphere = 10
sphereProblem = ContinuousProblem{Float64}(createBounds([-5.12 for i in 1:numberOfVariablesForSphere],[5.12 for i in 1:numberOfVariablesForSphere]), 1, 0)

sphereSolution = createSolution(sphereProblem)
@testset "Sphere problem tests" begin    
    @test numberOfVariables(sphereProblem) == numberOfVariablesForSphere
    @test sphereProblem.numberOfObjectives == 1
    @test sphereProblem.numberOfConstraints == 0

    @test length(sphereSolution.variables) == numberOfVariables(sphereProblem)
    @test length(sphereSolution.objectives) == sphereProblem.numberOfObjectives
    @test length(sphereSolution.constraints) == sphereProblem.numberOfConstraints

    @test sphereSolution.bounds == sphereProblem.bounds
    @test sphereSolution.variables[1] <= sphereProblem.bounds[1].upperBound
    @test sphereSolution.variables[1] >= sphereProblem.bounds[1].lowerBound
end

schafferProblem = ContinuousProblem{Float64}(createBounds([-10000.0],[10000.0]), 1, 0)
schafferSolution = createSolution(schafferProblem)
@testset "Schaffer problem tests" begin    
    @test numberOfVariables(schafferProblem) == 1
    @test schafferProblem.numberOfObjectives == 1
    @test schafferProblem.numberOfConstraints == 0
    @test schafferProblem.bounds[1].lowerBound == -10000.0
    @test schafferProblem.bounds[1].upperBound == 10000.0

    @test length(schafferSolution.variables) == numberOfVariables(schafferProblem)
    @test length(schafferSolution.objectives) == schafferProblem.numberOfObjectives
    @test length(schafferSolution.constraints) == schafferProblem.numberOfConstraints

    @test schafferSolution.bounds == schafferSolution.bounds
    @test schafferSolution.variables[1] <= schafferSolution.bounds[1].upperBound
    @test schafferSolution.variables[1] >= schafferSolution.bounds[1].lowerBound
end
"""