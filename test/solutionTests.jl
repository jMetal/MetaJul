include("../src/solution.jl")

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
    @test copiedSolution.attributes == Dict()

    @test isequal(continuousSolution, copiedSolution) == false
    @test isequal(continuousSolution, continuousSolution) == true
end

binarySolution = BinarySolution(initBitVector("1010"), [1.0, 2.0, 3.0], [-1], Dict("fitness" => 1.24))

copiedBinarySolution = copySolution(binarySolution)
copiedBinarySolution.variables = bitFlip(copiedBinarySolution.variables, 1)

@testset "BitVector tests" begin
    @test binarySolution.variables.bits == initBitVector("1010").bits
    @test binarySolution.objectives == [1.0, 2.0, 3.0]
    @test binarySolution.constraints == [-1]
    @test binarySolution.attributes == Dict("fitness" => 1.24)

    @test copiedBinarySolution.variables.bits == initBitVector("0010").bits
    @test copiedBinarySolution.objectives == [1.0, 2.0, 3.0]
    @test copiedBinarySolution.constraints == [-1]
    @test copiedBinarySolution.attributes == Dict()

    @test isequal(binarySolution, copiedBinarySolution) == false
    @test isequal(binarySolution, binarySolution) == true
end




