


@testset "checkIfPermutationIsValid tests" begin
    # Test with a valid permutation
    @test checkIfPermutationIsValid([3, 1, 2]) == true

    # Test with an invalid permutation (missing number)
    @test checkIfPermutationIsValid([3, 1, 4]) == false

    # Test with an invalid permutation (duplicate number)
    @test checkIfPermutationIsValid([1, 2, 2]) == false

    # Test with an empty array
    @test checkIfPermutationIsValid(Int64[]) == true

    # Test with a single-element array
    @test checkIfPermutationIsValid([1]) == true

    # Test with a larger valid permutation
    @test checkIfPermutationIsValid([5, 3, 2, 1, 4]) == true

    # Test with a larger invalid permutation (missing number)
    @test checkIfPermutationIsValid([5, 3, 2, 6, 4]) == false
end


permutationSolution = PermutationSolution([3, 2, 1], [1.5, 2.5], [0.1], Dict("ranking" => 5.0, "name" => "bestSolution"))

copiedSolution = copySolution(permutationSolution)
copiedSolution.variables =  [2, 1, 3]

@testset "PermutationSolution tests" begin
    @test permutationSolution.variables == [3, 2, 1]
    @test permutationSolution.objectives == [1.5, 2.5]
    @test permutationSolution.constraints == [0.1]
    @test permutationSolution.attributes == Dict("ranking" => 5.0, "name" => "bestSolution")

    @test copiedSolution.variables == [2, 1, 3]
    @test copiedSolution.objectives == [1.5, 2.5]
    @test copiedSolution.constraints == [0.1]
    @test copiedSolution.attributes == Dict()

    @test isequal(permutationSolution, copiedSolution) == false
    @test isequal(permutationSolution, permutationSolution) == true
end