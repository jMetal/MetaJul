# Test cases for struct Bounds
function createBoundsAssignTheRightLowerBoundValue() 
  return Bounds{Real}(4.0, 6.0).lowerBound == 4.0
end

function createBoundsAssignTheRightUpperBoundValue() 
    return Bounds{Int}(4, 6).upperBound == 6
end

function createBoundsWithLowerBoundHigherThanTheLowerBoundRaisesAndException() 
    return Bounds{Real}(5.0, 3.0)
end

function restrictReturnsTheValueIfTheValueIsWithinTheBounds()
    return restrict(4, Bounds{Int}(1, 5)) == 4
end

function restrictReturnsTheLowerBoundIsTheValueIsTheLowerBound()
    return restrict(1, Bounds{Int}(1, 5)) == 1
end

function restrictReturnsTheLowerBoundIsTheValueIsTheUpperBound()
    return restrict(5.0, Bounds{Real}(1.0, 5.0)) == 5.0
end

function restrictReturnsTheLowerBoundIsTheValueIsLowerThanTheLowerBound()
    return restrict(1.0, Bounds{Real}(1.2, 5.9)) == 1.2
end

function restrictReturnsTheUpperBoundIsTheValueIsHigherThanTheUpperBound()
    return restrict(10.0, Bounds{Real}(1.2, 5.9)) == 5.9
end

function valueIsInBoundsReturnsFalse()
    return valueIsWithinBounds(10.0, Bounds{Real}(1.2, 5.9)) == false
end

function valueIsInBoundsReturnsTrue()
    return valueIsWithinBounds(3.0, Bounds{Real}(1.2, 5.9)) == true
end

function createBoundsRaiseAnExceptionIfTheLengthOfTheLowerAndUpperBoundsArraysIsNotTheSame()
    return createBounds([1, 2], [2, 3, 4, 5])
end


@testset "Bounds tests" begin
    @test createBoundsAssignTheRightLowerBoundValue()
    @test createBoundsAssignTheRightUpperBoundValue()

    @test_throws "The lower bound 5.0 is higher than the upper bound 3.0" createBoundsWithLowerBoundHigherThanTheLowerBoundRaisesAndException()

    @test restrictReturnsTheValueIfTheValueIsWithinTheBounds()
    @test restrictReturnsTheLowerBoundIsTheValueIsTheLowerBound()
    @test restrictReturnsTheLowerBoundIsTheValueIsTheUpperBound()

    @test restrictReturnsTheLowerBoundIsTheValueIsLowerThanTheLowerBound()
    @test restrictReturnsTheLowerBoundIsTheValueIsLowerThanTheLowerBound()

    @test valueIsInBoundsReturnsFalse()
    @test valueIsInBoundsReturnsTrue()

    @test length(createBounds([1, 2, 3], [4, 5, 6])) == 3
    @test_throws "The length of the lowerbound and upperbound arrays are different: 2, 4" createBoundsRaiseAnExceptionIfTheLengthOfTheLowerAndUpperBoundsArraysIsNotTheSame()
end
