# Test cases for comparators

using Test

include("../src/comparator.jl")

@testset "Compare elements at the same position tests" begin
    @test_throws "The vectors have a different length" compareElementAt([1,2,3], [4,5], 1)
    @test_throws "The index is out of range" compareElementAt([1,2,3], [1,2,3], -1)
    @test_throws "The index is out of range" compareElementAt([1,2,3], [1,2,3], 4)

    @test compareElementAt([1.0,2.0,3.1], [4.0,5.2,0.5], 1) == -1
    @test compareElementAt([1.0,2.1,3], [4.1,1.4,3.1], 2) ==  1
    @test compareElementAt([1,2,3], [4,5,3],3 ) ==  0
end

@testset "Dominance comparison tests" begin
    @test_throws "The vectors have a different length" compareForDominance([1,2,3], [4,5])
    
    @test compareForDominance([1.0], [1.0]) == 0
    @test compareForDominance([1.0], [2.0]) == -1
    @test compareForDominance([2.0], [1.0]) == 1

    @test compareForDominance([1.0, 2.0], [1.0, 1.0]) == 1

    @test compareForDominance([1.0,2.0,3.1], [1.0,2.0,3.1]) == 0
    
    @test compareForDominance([1.0,3.1,4.0], [4.2,2.0,4.0]) == 0
    @test compareForDominance([1.0,2.0,3.1], [1.0,2.0,3.2]) == -1
    @test compareForDominance([1.0,2.0,3.2], [1.0,2.0,3.0]) == 1
end

