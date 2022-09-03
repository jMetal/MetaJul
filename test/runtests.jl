include("../src/bounds.jl")
include("../src/solution.jl")
include("../src/problem.jl")

using Test

@testset "Bounds tests" begin
    @test restrict(4, Bounds{Int64}(1, 5)) == 4
    @test restrict(1.0, Bounds{Float64}(1.2, 5.9)) == 1.2
    @test restrict(10.0, Bounds{Float64}(1.2, 5.9)) == 5.9

    @test valueIsWithinBounds(10.0, Bounds{Float64}(1.2, 5.9)) == false
    @test valueIsWithinBounds(3.0, Bounds{Float64}(1.2, 5.9)) == true


    @test Bounds{Float64}(4.0, 6.0).lowerBound == 4.0
    @test Bounds{Int}(4, 6).upperBound == 6

    @test_throws "The lower bound 5.0 is higher than the upper bound 3.0" Bounds{Float64}(5.0, 3.0)
end

continuousSolution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [0.1], Dict("ranking" => 5.0, "name" => "bestSolution"), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
copiedSolution = deepcopy(continuousSolution)
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

continuousProblem = ContinuousProblem{Float64}([Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2.0, 3.0), Bounds{Float64}(45.2, 97.5)], 3, 2)
@testset "ContinuousProblem tests" begin    
    @test numberOfVariables(continuousProblem) == 3
    @test continuousProblem.numberOfObjectives == 3
    @test continuousProblem.numberOfConstraints == 2
end