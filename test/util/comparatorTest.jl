# Test cases for comparators

@testset "Compare elements at the same position tests" begin
    @test_throws "The vectors have a different length" compare(ElementAtComparator(1), [1,2,3], [4,5])
    @test_throws "The index is out of range" compare(ElementAtComparator(-1), [1,2,3], [1,2,3])
    @test_throws "The index is out of range" compare(ElementAtComparator(4), [1,2,3], [1,2,3])

    @test compare(ElementAtComparator(1), [1.0,2.0,3.1], [4.0,5.2,0.5]) == -1
    @test compare(ElementAtComparator(2), [1.0,2.1,3], [4.1,1.4,3.1]) ==  1
    @test compare(ElementAtComparator(3), [1,2,3], [4,5,3]) ==  0
end


dominanceComparator = DefaultDominanceComparator()
@testset "Default Dominance comparison tests" begin
    @test_throws "The vectors have a different length" compare(dominanceComparator, [1,2,3], [4,5])
    
    @test compare(dominanceComparator, [1.0], [1.0]) == 0
    @test compare(dominanceComparator, [1.0], [2.0]) == -1
    @test compare(dominanceComparator, [2.0], [1.0]) == 1

    @test compare(dominanceComparator, [1.0, 2.0], [1.0, 1.0]) == 1
    @test compare(dominanceComparator, [2.0, 2.0], [2.0, 1.0]) == 1
    @test compare(dominanceComparator, [1.0, 2.0], [2.0, 1.0]) == 0
    @test compare(dominanceComparator, [1.0, 2.0], [1.0, 2.0]) == 0
    @test compare(dominanceComparator, [1.0, 1.0], [1.0, 2.0]) == -1

    @test compare(dominanceComparator, [1.0,2.0,3.1], [1.0,2.0,3.1]) == 0
    
    @test compare(dominanceComparator, [1.0,3.1,4.0], [4.2,2.0,4.0]) == 0
    @test compare(dominanceComparator, [1.0,2.0,3.1], [1.0,2.0,3.2]) == -1
    @test compare(dominanceComparator, [1.0,2.0,3.2], [1.0,2.0,3.0]) == 1
end


function compareForOverallConstraintViolationDegreeReturnsZeroIfBothSolutionsHasNoConstraints()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.0, 5.0], [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    solution2 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [-1.0, 5.0], [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    comparator = OverallConstraintViolationDegreeComparator() 
    return compare(comparator, solution1, solution2) == 0
end

function compareForOverallConstraintViolationDegreeReturnsZeroIfBothSolutionsAreFeasible()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.0, 5.0], [0.0, 0.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    solution2 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [-1.0, 5.0], [0.0, 0.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    comparator = OverallConstraintViolationDegreeComparator() 
    return compare(comparator, solution1, solution2) == 0
end

function compareForOverallConstraintViolationDegreeReturnsMinusOneIfASolutionIsFeasibleAndTheOtherIsNot()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.0, 5.0], [0.0, 0.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    solution2 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [-1.0, 5.0], [-1.0, 0.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    comparator = OverallConstraintViolationDegreeComparator() 
    return compare(comparator, solution1, solution2) == -1
end

function compareForOverallConstraintViolationDegreeReturnsOneIfASolutionIsNotFeasibleAndTheOtherIs()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.0, 5.0], [-1.0, 0.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    solution2 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [-1.0, 5.0], [0.0, 0.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    comparator = OverallConstraintViolationDegreeComparator() 
    return compare(comparator, solution1, solution2) == 1
end

function compareForOverallConstraintViolationDegreeReturnsOneIfTheSecondSolutionHasALowerViolationDegree()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.0, 5.0], [-1.0, -3.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    solution2 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [-1.0, 5.0], [-1.0, 1.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    comparator = OverallConstraintViolationDegreeComparator() 
    return compare(comparator, solution1, solution2) == 1
end

function compareForOverallConstraintViolationDegreeReturnsMinusOneIfTheFirstSolutionHasALowerViolationDegree()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.0, 5.0], [-1.0, -1.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    solution2 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [-1.0, 5.0], [-1.0, -5.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    comparator = OverallConstraintViolationDegreeComparator() 
    return compare(comparator, solution1, solution2) == -1
end

function compareForOverallConstraintViolationDegreeReturnsZeroIfBothSolutionsHasTheSameViolationDegree()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.0, 5.0], [-2.0, -4.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    solution2 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [-1.0, 5.0], [-1.0, -5.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    comparator = OverallConstraintViolationDegreeComparator() 
    return compare(comparator, solution1, solution2) == 0
end

@testset "Comparing for overall constraint violation degree tests" begin
    @test compareForOverallConstraintViolationDegreeReturnsZeroIfBothSolutionsHasNoConstraints()
    @test compareForOverallConstraintViolationDegreeReturnsZeroIfBothSolutionsAreFeasible()
    @test compareForOverallConstraintViolationDegreeReturnsMinusOneIfASolutionIsFeasibleAndTheOtherIsNot()
    @test compareForOverallConstraintViolationDegreeReturnsOneIfASolutionIsNotFeasibleAndTheOtherIs()
    @test compareForOverallConstraintViolationDegreeReturnsOneIfTheSecondSolutionHasALowerViolationDegree()
    @test compareForOverallConstraintViolationDegreeReturnsMinusOneIfTheFirstSolutionHasALowerViolationDegree()
    @test compareForOverallConstraintViolationDegreeReturnsZeroIfBothSolutionsHasTheSameViolationDegree()
end

function compareForConstraintsAndDominanceIgnoreTheConstraintsIfBothSolutionsAreFeasible()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.0, 5.0], [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    solution2 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [-1.0, 5.0], [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    comparator = ConstraintsAndDominanceComparator() 
    return compare(comparator, solution1, solution2) == 1
end

function compareForConstraintsAndDominanceIgnoreTheConstraintsIfBothSolutionsTheSameViolationDegree()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.0, 5.0], [-2.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    solution2 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [-1.0, 5.0], [-1.0, -1.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    comparator = ConstraintsAndDominanceComparator() 
    return compare(comparator, solution1, solution2) == 1
end

function compareForConstraintsAndDominanceReturnsMinusOneIfTheFirstSolutionABetterViolationDegreeValue()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.0, 5.0], [-1.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    solution2 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [-1.0, 5.0], [-2.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    comparator = ConstraintsAndDominanceComparator() 
    return compare(comparator, solution1, solution2) == -1
end

function compareForConstraintsAndDominanceReturnsOneIfTheSecondSolutionABetterViolationDegreeValue()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.0, 5.0], [-4.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    solution2 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [-1.0, 5.0], [-2.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    comparator = ConstraintsAndDominanceComparator() 
    return compare(comparator, solution1, solution2) == 1
end


@testset "Comparing for constraints and dominance tests" begin
    @test compareForConstraintsAndDominanceIgnoreTheConstraintsIfBothSolutionsAreFeasible()
    @test compareForConstraintsAndDominanceIgnoreTheConstraintsIfBothSolutionsTheSameViolationDegree()
    @test compareForConstraintsAndDominanceReturnsMinusOneIfTheFirstSolutionABetterViolationDegreeValue()
    @test compareForConstraintsAndDominanceReturnsOneIfTheSecondSolutionABetterViolationDegreeValue()
end

####################################################
# Compare ranking and crowding distance unit tests
####################################################

function compareTwoSolutionsWithDifferentRankingIgnoreTheCrowdingDistance()
    solution1 = createContinuousSolution(3)
    setRank(solution1, 2)
    setCrowdingDistance(solution1, 10.0)

    solution2 = createContinuousSolution(3)
    setRank(solution2, 3)
    setCrowdingDistance(solution2, 20.0)

    comparator = RankingAndCrowdingDistanceComparator()
    return compare(comparator, solution1, solution2) == -1
end

function compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase1()
    solution1 = createContinuousSolution(3)
    setRank(solution1, 4)
    setCrowdingDistance(solution1, 10.0)

    solution2 = createContinuousSolution(3)
    setRank(solution2, 4)
    setCrowdingDistance(solution2, 20.0)

    comparator = RankingAndCrowdingDistanceComparator()
    return compare(comparator, solution1, solution2) == 1
end

function compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase2()
    solution1 = createContinuousSolution(3)
    setRank(solution1, 4)
    setCrowdingDistance(solution1, 20.0)

    solution2 = createContinuousSolution(3)
    setRank(solution2, 4)
    setCrowdingDistance(solution2, 20.0)

    comparator = RankingAndCrowdingDistanceComparator()
    return compare(comparator, solution1, solution2) == 0
end

function compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase3()
    solution1 = createContinuousSolution(3)
    setRank(solution1, 4)
    setCrowdingDistance(solution1, 20.0)

    solution2 = createContinuousSolution(3)
    setRank(solution2, 4)
    setCrowdingDistance(solution2, 10.0)

    comparator = RankingAndCrowdingDistanceComparator()
    return compare(comparator, solution1, solution2) == -1
end

@testset "Comparing ranking and crowding distance tests" begin    
    @test compareTwoSolutionsWithDifferentRankingIgnoreTheCrowdingDistance()
    @test compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase1()
    @test compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase2()
    @test compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase3()
end
