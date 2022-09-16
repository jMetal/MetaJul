include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/problem.jl")

using Test

include("boundsTests.jl")

@testset "createBounds() tests" begin
    @test length(createBounds([1, 2, 3], [4, 5, 6])) == 3
    @test_throws "The length of the lowerbound and upperbound arrays are different: 2, 4" createBounds([1, 2], [2, 3, 4, 5])
end

continuousSolution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [0.1], Dict("ranking" => 5.0, "name" => "bestSolution"), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

copiedSolution = copySolution(continuousSolution)
copiedSolution.variables =  [2.5, 5.6, 1.5]
@testset "ContinuousSolution tests" begin
    @test continuousSolution.variables == [1.0, 2.0, 3.0]
    @test continuousSolution.objectives == [1.5, 2.5]
    @test continuousSolution.constraints == [0.1]
    @test continuousSolution.attributes == Dict("ranking" => 5.0, "name" => "bestSolution")

    @test copiedSolution.variables == [2.5, 5.6, 1.5]
    @test copiedSolution.objectives == [1.5, 2.5]
    @test copiedSolution.constraints == [0.1]
    @test copiedSolution.attributes == Dict("ranking" => 5.0, "name" => "bestSolution")
end

const continuousProblem = ContinuousProblem{Float64}([Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2.0, 3.0), Bounds{Float64}(45.2, 97.5)], 3, 2)
@testset "ContinuousProblem tests" begin    
    @test numberOfVariables(continuousProblem) == 3
    @test continuousProblem.numberOfObjectives == 3
    @test continuousProblem.numberOfConstraints == 2
end

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
