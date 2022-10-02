# Test cases for struct Bounds

include("../src/comparator.jl")

"""
function valueIsInBoundsReturnsTrue()
    return valueIsWithinBounds(3.0, Bounds{Real}(1.2, 5.9)) == true
end

function createBoundsRaiseAnExceptionIfTheLengthOfTheLowerAndUpperBoundsArraysIsNotTheSame()
    return createBounds([1, 2], [2, 3, 4, 5])
end
"""

@testset "Objective comparator tests" begin
    @test_throws "The arrays have a different length" objectiveComparator([1,2,3], [4,5], 1)
    @test_throws "The objective id is out of range" objectiveComparator([1,2,3], [1,2,3], -1)
    @test_throws "The objective id is out of range" objectiveComparator([1,2,3], [1,2,3], 4)

    @test objectiveComparator([1.0,2.0,3.1], [4.0,5.2,0.5], 1) == -1
    @test objectiveComparator([1.0,2.1,3], [4.1,1.4,3.1], 2) ==  1
    @test objectiveComparator([1,2,3], [4,5,3], 3) ==  0
end

@testset "Dominance comparator tests" begin
    @test_throws "The arrays have a different length" dominanceComparator([1,2,3], [4,5])

    @test dominanceComparator([1.0], [1.0]) == 0
    @test dominanceComparator([1.0], [2.0]) == -1
    @test dominanceComparator([2.0], [1.0]) == 1

    @test dominanceComparator([1.0,2.0,3.1], [1.0,2.0,3.1]) == 0
    
    @test dominanceComparator([1.0,3.1,4.0], [4.2,2.0,4.0]) == 0
    @test dominanceComparator([1.0,2.0,3.1], [1.0,2.0,3.2]) == -1
    @test dominanceComparator([1.0,2.0,3.2], [1.0,2.0,3.0]) == 1

end
