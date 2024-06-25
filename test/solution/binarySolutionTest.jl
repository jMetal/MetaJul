binarySolution = BinarySolution(initBitVector("1010"), [1.0, 2.0, 3.0], [-1], Dict("fitness" => 1.24))

copiedBinarySolution = copySolution(binarySolution)
copiedBinarySolution.variables = bitFlip(copiedBinarySolution.variables, 1)
duplicatedSolution = BinarySolution(initBitVector("1010"), [1.0, 2.0, 3.0], [-1], Dict("fitness" => 1.24))

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

    @test isequal(binarySolution, duplicatedSolution)
end

