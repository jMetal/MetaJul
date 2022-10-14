include("../src/solution.jl")
include("../src/densityEstimator.jl")

using Test

function computingTheCrowdingDistanceRaisesAnExceptionIfTheSolutionListIsEmpty()
    computeCrowdingDistanceEstimator!(Vector{ContinuousSolution{Float64}}(undef, 0))
end

function computingTheCrowdingDistanceOnAListWithASolutionAssignsTheMaxValueToTheSolution()
    solutions = [createContinuousSolution([1.0, 2.0])]

    computeCrowdingDistanceEstimator!(solutions)

    return getCrowdingDistance(solutions[1]) == typemax(Float64)
end

function computingTheCrowdingDistanceOnAListWithTwoSolutionAssignsTheMaxValueToThem()
    solutions = [createContinuousSolution([1.0, 2.0]), createContinuousSolution([2.0, 1.0])]

    computeCrowdingDistanceEstimator!(solutions)

    return getCrowdingDistance(solutions[1]) == typemax(Float64)
    return getCrowdingDistance(solutions[2]) == typemax(Float64)
end

function computingTheCrowdingDistanceOnAListWithThreeBiObjectiveSolutionAssignsTheRightValues()
    solution1 = createContinuousSolution(3)
    solution2 = createContinuousSolution(3)
    solution3 = createContinuousSolution(3)
    solutions = [solution1, solution2, solution3]

    computeCrowdingDistanceEstimator!(solutions)

    return getCrowdingDistance(solutions[1])== typemax(Float64)
    return getCrowdingDistance(solutions[2]) == 2.0
    return getCrowdingDistance(solutions[3]) == typemax(Float64)
end

@testset "Crowding distance estimator test cases" begin    
    @test_throws "The solution list is empty" computingTheCrowdingDistanceRaisesAnExceptionIfTheSolutionListIsEmpty()
    
    @test computingTheCrowdingDistanceOnAListWithASolutionAssignsTheMaxValueToTheSolution()
    @test computingTheCrowdingDistanceOnAListWithTwoSolutionAssignsTheMaxValueToThem()
    @test computingTheCrowdingDistanceOnAListWithThreeBiObjectiveSolutionAssignsTheRightValues()
end

function compareTwoSolutionsWithEqualCrowdingDistanceReturnsZero()
    solution1 = createContinuousSolution(2)
    solution2 = createContinuousSolution(2)

    setCrowdingDistance(solution1, 1.0)
    setCrowdingDistance(solution2, 1.0)

    return compareCrowdingDistance(solution1, solution2) == 0
end

function compareTwoSolutionsReturnMinusOneIfTheFirstSolutionHasAHigherCrowdingDistance()
    solution1 = createContinuousSolution(2)
    solution2 = createContinuousSolution(2)

    setCrowdingDistance(solution1, 20.0)
    setCrowdingDistance(solution2, 1.0)

    return compareCrowdingDistance(solution1, solution2) == -1
end

function compareTwoSolutionsReturnOneIfTheFirstSolutionHasALowerCrowdingDistance()
    solution1 = createContinuousSolution(2)
    solution2 = createContinuousSolution(2)

    setCrowdingDistance(solution1, 1.0)
    setCrowdingDistance(solution2, 2.0)

    return compareCrowdingDistance(solution1, solution2) == 1
end

@testset "Ranking comparators tests" begin    
    @test compareTwoSolutionsWithEqualCrowdingDistanceReturnsZero()

    @test compareTwoSolutionsReturnMinusOneIfTheFirstSolutionHasAHigherCrowdingDistance()
    @test compareTwoSolutionsReturnOneIfTheFirstSolutionHasALowerCrowdingDistance()
end