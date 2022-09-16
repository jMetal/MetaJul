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

function restrictReturnTheValueIfTheValueIsWithinTheBounds()
    return restrict(4, Bounds{Int}(1, 5)) == 4
end

function restrictReturnTheLowerBoundIsTheValueIsTheLowerBound()
    return restrict(1, Bounds{Int}(1, 5)) == 1
end

function restrictReturnTheLowerBoundIsTheValueIsTheUpperBound()
    return restrict(5.0, Bounds{Real}(1.0, 5.0)) == 5.0
end

function restrictReturnTheLowerBoundIsTheValueIsLowerThanTheLowerBound()
    return restrict(1.0, Bounds{Real}(1.2, 5.9)) == 1.2
end

function restrictReturnTheUpperBoundIsTheValueIsHigherThanTheUpperBound()
    return restrict(10.0, Bounds{Real}(1.2, 5.9)) == 5.9
end

function valueIsInBoundsReturnsFalse()
    return valueIsWithinBounds(10.0, Bounds{Real}(1.2, 5.9)) == false
end

function valueIsInBoundsReturnsTrue()
    return valueIsWithinBounds(3.0, Bounds{Real}(1.2, 5.9)) == true
end


@testset "Bounds tests" begin
    @test createBoundsAssignTheRightLowerBoundValue()
    @test createBoundsAssignTheRightUpperBoundValue()

    @test_throws "The lower bound 5.0 is higher than the upper bound 3.0" createBoundsWithLowerBoundHigherThanTheLowerBoundRaisesAndException()

    @test restrictReturnTheValueIfTheValueIsWithinTheBounds()
    @test restrictReturnTheLowerBoundIsTheValueIsTheLowerBound()
    @test restrictReturnTheLowerBoundIsTheValueIsTheUpperBound()

    @test restrictReturnTheLowerBoundIsTheValueIsLowerThanTheLowerBound()
    @test restrictReturnTheLowerBoundIsTheValueIsLowerThanTheLowerBound()

    @test valueIsInBoundsReturnsFalse()
    @test valueIsInBoundsReturnsTrue()
end
