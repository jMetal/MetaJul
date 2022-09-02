include("../src/bounds.jl")

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

end
