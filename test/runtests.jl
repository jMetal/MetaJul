include("../src/bounds.jl")

using Test

@testset "Bounds tests" begin
    @test restrict(4, Bounds{Int64}(1, 5)) == 4
    @test restrict(1.0, Bounds{Float32}(1.2, 5.9)) == 1.2f0
    @test restrict(10.0, Bounds{Float32}(1.2, 5.9)) == 5.9f0
end