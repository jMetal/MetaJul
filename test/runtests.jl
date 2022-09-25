include("../src/solution.jl")
include("../src/problem.jl")

using Test

include("boundsTests.jl")
include("problemTests.jl")

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

