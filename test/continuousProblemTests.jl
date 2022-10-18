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

numberOfVariablesForSphere = 10
sphere = sphereProblem(numberOfVariablesForSphere)
sphereSolution = createSolution(sphere)
@testset "Sphere problem tests" begin    
    @test numberOfVariables(sphere) == numberOfVariablesForSphere
    @test numberOfObjectives(sphere) == 1
    @test numberOfConstraints(sphere) == 0

    @test length(sphereSolution.variables) == numberOfVariables(sphere)
    @test length(sphereSolution.objectives) == numberOfObjectives(sphere)
    @test length(sphereSolution.constraints) == numberOfConstraints(sphere)

    @test sphereSolution.bounds == sphere.bounds
    @test sphereSolution.variables[1] <= sphere.bounds[1].upperBound
    @test sphereSolution.variables[1] >= sphere.bounds[1].lowerBound
end

schaffer = schafferProblem()
schafferSolution = createSolution(schaffer)
@testset "Schaffer problem tests" begin    
    @test numberOfVariables(schaffer) == 1
    @test numberOfObjectives(schaffer) == 2
    @test numberOfConstraints(schaffer) == 0
    @test bounds(schaffer)[1].lowerBound == -10000.0
    @test bounds(schaffer)[1].upperBound == 10000.0

    @test length(schafferSolution.variables) == numberOfVariables(schaffer)
    @test length(schafferSolution.objectives) == numberOfObjectives(schaffer)
    @test length(schafferSolution.constraints) == numberOfConstraints(schaffer)

    @test schafferSolution.bounds == schafferSolution.bounds
    @test schafferSolution.variables[1] <= schafferSolution.bounds[1].upperBound
    @test schafferSolution.variables[1] >= schafferSolution.bounds[1].lowerBound
end