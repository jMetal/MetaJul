include("../src/bounds.jl")
include("../src/solution.jl")

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

@testset "ContinuousSolution tests" begin
    function getContinuousSolution() :: ContinuousSolution
        return ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [0.1], Dict("ranking" => 5.0, "name" => "bestSolution"), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
    end

    @test getContinuousSolution().variables == [1.0, 2.0, 3.0]
    @test getContinuousSolution().objectives == [1.5, 2.5]
    @test getContinuousSolution().constraints == [0.1]
    @test getContinuousSolution().attributes == Dict("ranking" => 5.0, "name" => "bestSolution")

    function copiedSolution(solution::ContinuousSolution) :: ContinuousSolution
        newSolution = deepcopy(solution)
        newSolution.variables = [2.5, 5.6, 1.5]

        return newSolution
    end

    @test copiedSolution(getContinuousSolution()).variables == [2.5, 5.6, 1.5]
    @test copiedSolution(getContinuousSolution()).objectives == [1.5, 2.5]
    @test copiedSolution(getContinuousSolution()).constraints == [0.1]
    @test copiedSolution(getContinuousSolution()).attributes == Dict("ranking" => 5.0, "name" => "bestSolution")


end
