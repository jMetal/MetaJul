using Test

function computingTheCrowdingDistanceRaisesAnExceptionIfTheSolutionListIsEmpty()
    densityEstimator = CrowdingDistanceDensityEstimator()
    compute!(densityEstimator, Vector{ContinuousSolution{Float64}}(undef, 0))
end

function computingTheCrowdingDistanceOnAListWithASolutionAssignsTheMaxValueToTheSolution()
    solutions = [createContinuousSolution([1.0, 2.0])]

    densityEstimator = CrowdingDistanceDensityEstimator()
    compute!(densityEstimator, solutions)

    return getCrowdingDistance(solutions[1]) == maxCrowdingDistanceValue()
end

function computingTheCrowdingDistanceOnAListWithTwoSolutionAssignsTheMaxValueToThem()
    solutions = [createContinuousSolution([1.0, 2.0]), createContinuousSolution([2.0, 1.0])]

    densityEstimator = CrowdingDistanceDensityEstimator()
    compute!(densityEstimator, solutions)

    return getCrowdingDistance(solutions[1]) == maxCrowdingDistanceValue()
    return getCrowdingDistance(solutions[2]) == maxCrowdingDistanceValue()
end

function computingTheCrowdingDistanceOnAListOfSixSolutionAssignsTheRightValues()
    objectiveValues = [
        [0.9228750336383887, 4.368497851779355],
        [0.8409372615592949, 4.7393211155296315],
        [0.4814413714745963, 4.814059473570379],
        [0.07336635446929285, 4.955242979343399],
        [0.06050659328388003, 4.97308823770029],
        [0.022333588871048637, 5.357300649511081] 
    ]

    solutions = [createContinuousSolution(objectives) for objectives in objectiveValues]
    densityEstimator = CrowdingDistanceDensityEstimator()
    compute!(densityEstimator, solutions)

    return getCrowdingDistance(solutions[1]) == maxCrowdingDistanceValue()
    return getCrowdingDistance(solutions[6]) == maxCrowdingDistanceValue()
end


function computingTheCrowdingDistanceOnAListWithThreeBiObjectiveSolutionAssignsTheRightValues()
    solution1 = createContinuousSolution(3)
    solution2 = createContinuousSolution(3)
    solution3 = createContinuousSolution(3)
    solutions = [solution1, solution2, solution3]

    densityEstimator = CrowdingDistanceDensityEstimator()
    compute!(densityEstimator, solutions)

    return getCrowdingDistance(solutions[1]) == maxCrowdingDistanceValue()
    return getCrowdingDistance(solutions[2]) == 2.0
    return getCrowdingDistance(solutions[3]) == maxCrowdingDistanceValue()
end

@testset "Crowding distance estimator test cases" begin
    @test_throws "The solution list is empty" computingTheCrowdingDistanceRaisesAnExceptionIfTheSolutionListIsEmpty()

    @test computingTheCrowdingDistanceOnAListWithASolutionAssignsTheMaxValueToTheSolution()
    @test computingTheCrowdingDistanceOnAListWithTwoSolutionAssignsTheMaxValueToThem()
    @test computingTheCrowdingDistanceOnAListWithThreeBiObjectiveSolutionAssignsTheRightValues()
    @test computingTheCrowdingDistanceOnAListOfSixSolutionAssignsTheRightValues()
end

function compareTwoSolutionsWithEqualCrowdingDistanceReturnsZero()
    solution1 = createContinuousSolution(2)
    solution2 = createContinuousSolution(2)

    setCrowdingDistance(solution1, 1.0)
    setCrowdingDistance(solution2, 1.0)

    return compare(CrowdingDistanceComparator(), solution1, solution2) == 0
end

function compareTwoSolutionsReturnMinusOneIfTheFirstSolutionHasAHigherCrowdingDistance()
    solution1 = createContinuousSolution(2)
    solution2 = createContinuousSolution(2)

    setCrowdingDistance(solution1, 20.0)
    setCrowdingDistance(solution2, 1.0)

    return compare(CrowdingDistanceComparator(), solution1, solution2)  == -1
end

function compareTwoSolutionsReturnOneIfTheFirstSolutionHasALowerCrowdingDistance()
    solution1 = createContinuousSolution(2)
    solution2 = createContinuousSolution(2)

    setCrowdingDistance(solution1, 1.0)
    setCrowdingDistance(solution2, 2.0)

    return compare(CrowdingDistanceComparator(), solution1, solution2)  == 1
end

@testset "Ranking comparators tests" begin
    @test compareTwoSolutionsWithEqualCrowdingDistanceReturnsZero()

    @test compareTwoSolutionsReturnMinusOneIfTheFirstSolutionHasAHigherCrowdingDistance()
    @test compareTwoSolutionsReturnOneIfTheFirstSolutionHasALowerCrowdingDistance()
end


