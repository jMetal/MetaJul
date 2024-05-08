using Test

function computingTheCrowdingDistanceRaisesAnExceptionIfTheSolutionListIsEmpty()
    computeCrowdingDistanceEstimator!(Vector{ContinuousSolution{Float64}}(undef, 0))
end

function computingTheCrowdingDistanceOnAListWithASolutionAssignsTheMaxValueToTheSolution()
    solutions = [createContinuousSolution([1.0, 2.0])]

    computeCrowdingDistanceEstimator!(solutions)

    return getCrowdingDistance(solutions[1]) == maxCrowdingDistanceValue()
end

function computingTheCrowdingDistanceOnAListWithTwoSolutionAssignsTheMaxValueToThem()
    solutions = [createContinuousSolution([1.0, 2.0]), createContinuousSolution([2.0, 1.0])]

    computeCrowdingDistanceEstimator!(solutions)

    return getCrowdingDistance(solutions[1]) == maxCrowdingDistanceValue()
    return getCrowdingDistance(solutions[2]) == maxCrowdingDistanceValue()
end

function computingTheCrowdingDistanceOnAListWithThreeBiObjectiveSolutionAssignsTheRightValues()
    solution1 = createContinuousSolution(3)
    solution2 = createContinuousSolution(3)
    solution3 = createContinuousSolution(3)
    solutions = [solution1, solution2, solution3]

    computeCrowdingDistanceEstimator!(solutions)

    return getCrowdingDistance(solutions[1]) == maxCrowdingDistanceValue()
    return getCrowdingDistance(solutions[2]) == 2.0
    return getCrowdingDistance(solutions[3]) == maxCrowdingDistanceValue()
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


#########################################################################
# Test cases for crowding distance archive
#########################################################################
function addASolutionToAnEmtpyCrowdingDistanceArchiveMakesItsLengthToBeOne()
    solution = createContinuousSolution(3)

    archiveCapacity = 10
    archive = CrowdingDistanceArchive(archiveCapacity, ContinuousSolution{Float64})
    add!(archive, solution)

    return length(archive) == 1 && capacity(archive) == archiveCapacity
end


function addASolutionToAnEmtpyCrowdingDistanceArchiveEffectivelyAddTheSolution()
    solution = createContinuousSolution(3)

    archiveCapacity = 10
    archive = CrowdingDistanceArchive(archiveCapacity, ContinuousSolution{Float64})
    add!(archive, solution)

    return contain(archive, solution) && capacity(archive) == archiveCapacity
end

function addASolutionToAnEmtpyCrowdingDistanceArchiveArchiveMakesItNonEmpty()
    solution = createContinuousSolution(3)

    archiveCapacity = 10
    archive = CrowdingDistanceArchive(archiveCapacity, ContinuousSolution{Float64})
    add!(archive, solution)

    return isEmpty(archive) == false && capacity(archive) == archiveCapacity
end

function addASolutionToAnEmtpyCrowdingDistanceArchiveMakesTheArchiveToContainIt()
    solution = createContinuousSolution(3)

    archiveCapacity = 10
    archive = CrowdingDistanceArchive(archiveCapacity, ContinuousSolution{Float64})
    add!(archive, solution)

    return isequal(solution, getSolutions(archive)[1]) && capacity(archive) == archiveCapacity
end


emptyCrowdingDistanceArchive = CrowdingDistanceArchive(10, ContinuousSolution{Float64})

@testset "Empty non-dominated archive tests" begin
    @test length(emptyCrowdingDistanceArchive) == 0
    @test isEmpty(emptyCrowdingDistanceArchive)
    @test !isFull(emptyCrowdingDistanceArchive)
    @test capacity(emptyCrowdingDistanceArchive) == 10

    @test addASolutionToAnEmtpyCrowdingDistanceArchiveMakesItsLengthToBeOne()
    @test addASolutionToAnEmtpyCrowdingDistanceArchiveEffectivelyAddTheSolution()
    @test addASolutionToAnEmtpyCrowdingDistanceArchiveArchiveMakesItNonEmpty()
    @test addASolutionToAnEmtpyCrowdingDistanceArchiveMakesTheArchiveToContainIt()
end

############################

function computingTheCrowdingDistanceOfAnArchiveWithASolutionMakesTheSolutionToHaveTheHighestDistanceValue()
    crowdingDistanceArchive = CrowdingDistanceArchive(10, ContinuousSolution{Float64})
    solution = createContinuousSolution(5)

    add!(crowdingDistanceArchive, solution)
    computeCrowdingDistanceEstimator!(crowdingDistanceArchive)
    return getCrowdingDistance(getSolutions(crowdingDistanceArchive)[1]) == maxCrowdingDistanceValue()
end

function computingTheCrowdingDistanceOfAnArchiveWithTwoSolutionsMakesThemToHaveTheHighestDistanceValue()
    crowdingDistanceArchive = CrowdingDistanceArchive(10, ContinuousSolution{Float64})
    solution1 = createContinuousSolution(5)
    solution2 = createContinuousSolution(5)

    add!(crowdingDistanceArchive, solution1)
    add!(crowdingDistanceArchive, solution2)
    computeCrowdingDistanceEstimator!(crowdingDistanceArchive)
    return getCrowdingDistance(getSolutions(crowdingDistanceArchive)[1]) == maxCrowdingDistanceValue()
    return getCrowdingDistance(getSolutions(crowdingDistanceArchive)[2]) == maxCrowdingDistanceValue()
end

function computingTheCrowdingDistanceOfAnArchiveWithTheeSolutionsAssignTheHighestDistanceValueToTheExtremeSolutions()
    crowdingDistanceArchive = CrowdingDistanceArchive(10, ContinuousSolution{Float64})
    solution1 = createContinuousSolution([2.0, 0.0, 0.0])
    solution2 = createContinuousSolution([1.0, 1.0, 1.0])
    solution3 = createContinuousSolution([0.0, 0.0, 2.0])

    add!(crowdingDistanceArchive, solution1)
    add!(crowdingDistanceArchive, solution2)
    add!(crowdingDistanceArchive, solution3)
    computeCrowdingDistanceEstimator!(crowdingDistanceArchive)
    return getCrowdingDistance(solution1) == maxCrowdingDistanceValue()
    return getCrowdingDistance(solution2) == maxCrowdingDistanceValue()
    return getCrowdingDistance(solution3) != maxCrowdingDistanceValue()
end

@testset "Tests for computing the crowding distance of the archive solutions" begin
    @test computingTheCrowdingDistanceOfAnArchiveWithASolutionMakesTheSolutionToHaveTheHighestDistanceValue()
    @test computingTheCrowdingDistanceOfAnArchiveWithTwoSolutionsMakesThemToHaveTheHighestDistanceValue()
    @test computingTheCrowdingDistanceOfAnArchiveWithTheeSolutionsAssignTheHighestDistanceValueToTheExtremeSolutions()
end

############################

function addASolutionToAFullArchiveRemovesASolution()
    archiveCapacity = 2
    crowdingDistanceArchive = CrowdingDistanceArchive(archiveCapacity, ContinuousSolution{Float64})
    solution1 = createContinuousSolution([2.0, 0.0, 0.0])
    solution2 = createContinuousSolution([1.0, 1.0, 1.0])
    solution3 = createContinuousSolution([0.0, 0.0, 2.0])

    add!(crowdingDistanceArchive, solution1)
    add!(crowdingDistanceArchive, solution2)
    add!(crowdingDistanceArchive, solution3)
    
    return length(crowdingDistanceArchive) == archiveCapacity
end

function addASolutionToAFullArchiveRemovesTheSolutionWithTheLowestCrowdingDistance()
    archiveCapacity = 2
    crowdingDistanceArchive = CrowdingDistanceArchive(archiveCapacity, ContinuousSolution{Float64})
    solution1 = createContinuousSolution([2.0, 0.0])
    solution2 = createContinuousSolution([1.0, 1.0])
    solution3 = createContinuousSolution([0.0, 2.0])

    add!(crowdingDistanceArchive, solution1)
    solution2IsAdded = add!(crowdingDistanceArchive, solution2)
    add!(crowdingDistanceArchive, solution3)
    
    return contain(crowdingDistanceArchive, solution2) == false
end

function addASolutionWithALowCrowdingDistanceToAFullArchiveRemovesThatSolution()
    archiveCapacity = 2
    crowdingDistanceArchive = CrowdingDistanceArchive(archiveCapacity, ContinuousSolution{Float64})
    solution1 = createContinuousSolution([2.0, 0.0])
    solution2 = createContinuousSolution([0.0, 2.0])
    solution3 = createContinuousSolution([1.0, 1.0])

    add!(crowdingDistanceArchive, solution1)
    add!(crowdingDistanceArchive, solution2)
    solution3IsAdded = add!(crowdingDistanceArchive, solution3)
    
    return !solution3IsAdded
end


@testset "Tests for adding solutions to a full crowding distance archive" begin
    @test addASolutionToAFullArchiveRemovesASolution()
    @test addASolutionToAFullArchiveRemovesTheSolutionWithTheLowestCrowdingDistance()
    @test addASolutionWithALowCrowdingDistanceToAFullArchiveRemovesThatSolution()
end