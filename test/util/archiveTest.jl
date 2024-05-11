#########################################################################
# Test cases for non-dominated archive
#########################################################################

function addASolutionToAnEmtpyArchiveMakesItsLengthToBeOne()
  solution = createContinuousSolution(3)

  archive = NonDominatedArchive(ContinuousSolution{Float64})
  add!(archive, solution)

  return length(archive) == 1
end

function addASolutionToAnEmtpyArchiveEffectivelyAddTheSolution()
  solution = createContinuousSolution(3)

  archive = NonDominatedArchive(ContinuousSolution{Float64})
  add!(archive, solution)

  return contain(archive, solution) && getSolutions(archive)[1] == solution
end

function addASolutionToAnEmtpyArchiveMakesItNonEmpty()
  solution = createContinuousSolution(3)

  archive = NonDominatedArchive(ContinuousSolution{Float64})
  add!(archive, solution)

  return isEmpty(archive) == false
end


emptyArchive = NonDominatedArchive(ContinuousSolution{Float64})

@testset "Empty non-dominated archive tests" begin    
  @test length(emptyArchive) == 0
  @test isEmpty(emptyArchive)

  @test addASolutionToAnEmtpyArchiveMakesItsLengthToBeOne()
  @test addASolutionToAnEmtpyArchiveEffectivelyAddTheSolution()
  @test addASolutionToAnEmtpyArchiveMakesItNonEmpty()
end

#########################################################################

function addANonDominatedSolutionToAnArchiveWithASolutionReturnsTrue() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  nonDominatedSolution = createContinuousSolution(3)
  nonDominatedSolution.objectives = [1.0, 1.0, 4.0]

  archive = NonDominatedArchive([solution], compareForDominance)
  
  return add!(archive, nonDominatedSolution)
end

function addANonDominatedSolutionToAnArchiveWithASolutionContainsBothSolutions() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  nonDominatedSolution = createContinuousSolution(3)
  nonDominatedSolution.objectives = [1.0, 1.0, 4.0]

  archive = NonDominatedArchive([solution], compareForDominance)
  add!(archive, nonDominatedSolution)
  
  return contain(archive, solution) && contain(archive, nonDominatedSolution)
end


function addANonDominatedSolutionToAnArchiveWithASolutionIncreasesItsLengthByOne() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  nonDominatedSolution = createContinuousSolution(3)
  nonDominatedSolution.objectives = [1.0, 1.0, 4.0]

  archive = NonDominatedArchive([solution], compareForDominance)
  add!(archive, nonDominatedSolution)

  return length(archive) == 2
end

function addADominatedSolutionToAnArchiveWithASolutionReturnFalse() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatedSolution = createContinuousSolution(3)
  dominatedSolution.objectives = [2.0, 3.0, 4.0]

  archive = NonDominatedArchive([solution], compareForDominance)
  add!(archive, dominatedSolution)

  return !add!(archive, dominatedSolution)
end


function addADominatedSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatedSolution = createContinuousSolution(3)
  dominatedSolution.objectives = [2.0, 3.0, 4.0]

  archive = NonDominatedArchive([solution], compareForDominance)
  add!(archive, dominatedSolution)

  return length(archive) == 1
end


function addADominatingSolutionToAnArchiveWithASolutionReturnsTrue() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [0.0, 1.0, 2.0]

  archive = NonDominatedArchive([solution], compareForDominance)
  
  return add!(archive, dominatingSolution)
end

function addADominatingSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [0.0, 1.0, 2.0]

  archive = NonDominatedArchive([solution], compareForDominance)
  add!(archive, dominatingSolution)

  return length(archive) == 1
end

function addADominatingSolutionToAnArchiveWithASolutionRemovesTheExistingOneWhichIsReplacedByTheDominatingOne() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [0.0, 1.0, 2.0]

  archive = NonDominatedArchive([solution], compareForDominance)
  add!(archive, dominatingSolution)

  return contain(archive, dominatingSolution) && !contain(archive, solution)
end


archiveWithASolution = NonDominatedArchive(ContinuousSolution{Float64})
add!(archiveWithASolution, createContinuousSolution(3))
@testset "Archive with a solution tests" begin    
  @test length(archiveWithASolution) == 1
  @test !isEmpty(archiveWithASolution)

  @test addANonDominatedSolutionToAnArchiveWithASolutionReturnsTrue()
  @test addANonDominatedSolutionToAnArchiveWithASolutionIncreasesItsLengthByOne()
  @test addANonDominatedSolutionToAnArchiveWithASolutionContainsBothSolutions()

  @test addADominatedSolutionToAnArchiveWithASolutionReturnFalse()
  @test addADominatedSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength()
  
  @test addADominatingSolutionToAnArchiveWithASolutionReturnsTrue()
  @test addADominatingSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength()
  @test addADominatingSolutionToAnArchiveWithASolutionRemovesTheExistingOneWhichIsReplacedByTheDominatingOne()
end

#########################################################################
function addADominantSolutionInAnArchiveOfSizeTwoDiscardTheExistingOfSolutions()
  solution1 = createContinuousSolution(3)
  solution1.objectives = [1.0, 2.0, 3.0]
  solution2 = createContinuousSolution(3)
  solution2.objectives = [1.0, 1.0, 4.0]

  archive = NonDominatedArchive(ContinuousSolution{Float64})
  add!(archive, solution1)
  add!(archive, solution2)

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [1.0, 1.0, 1.0]

  add!(archive, dominatingSolution)

  return length(archive) == 1 && !contain(archive, solution1) && !contain(archive, solution2)
end

function addADominatedSolutionInAnArchiveOfSizeTwoReturnFalse()
  solution1 = createContinuousSolution(3)
  solution1.objectives = [1.0, 2.0, 3.0]
  solution2 = createContinuousSolution(3)
  solution2.objectives = [1.0, 1.0, 4.0]

  archive = NonDominatedArchive(ContinuousSolution{Float64})
  add!(archive, solution1)
  add!(archive, solution2)

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [2.0, 3.0, 5.0]

  solutionIsAdded = add!(archive, dominatingSolution)

  return length(archive) == 2 && !solutionIsAdded
end

function addASolutionInAnArchiveOfSizeTwoDominatingTheFirstOneDiscardThisOne()
  solution1 = createContinuousSolution(3)
  solution1.objectives = [1.0, 2.0, 3.0]
  solution2 = createContinuousSolution(3)
  solution2.objectives = [1.0, 1.0, 4.0]

  archive = NonDominatedArchive(ContinuousSolution{Float64})
  add!(archive, solution1)
  add!(archive, solution2)

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [1.0, 2.0, 2.0]

  solutionIsAdded = add!(archive, dominatingSolution)

  return length(archive) == 2 && solutionIsAdded && !contain(archive, solution1) && contain(archive, solution2)
end

function addADuplicatedSolutionsInAnArchiveOfSizeTwoReturnsFalse()
  solution1 = createContinuousSolution(3) 
  solution1.objectives = [1.0, 2.0, 3.0]
  solution2 = createContinuousSolution(3)
  solution2.objectives = [1.0, 1.0, 4.0]

  archive = NonDominatedArchive(ContinuousSolution{Float64})
  add!(archive, solution1)
  add!(archive, solution2)

  existingSolution1 = createContinuousSolution(3)
  existingSolution1.objectives = [1.0, 2.0, 3.0]

  existingSolution2 = createContinuousSolution(3)
  existingSolution2.objectives = [1.0, 1.0, 4.0]

  solution1IsAdded = add!(archive, existingSolution1)
  solution2IsAdded = add!(archive, existingSolution2)

  return length(archive) == 2 && !solution1IsAdded && !solution2IsAdded
end

@testset "Archive with two solution tests" begin    
  @test addADominantSolutionInAnArchiveOfSizeTwoDiscardTheExistingOfSolutions()
  @test addADominatedSolutionInAnArchiveOfSizeTwoReturnFalse()
  @test addASolutionInAnArchiveOfSizeTwoDominatingTheFirstOneDiscardThisOne()
  @test addADuplicatedSolutionsInAnArchiveOfSizeTwoReturnsFalse()
end

"""
6 o
5    o
4    x
3         x
2         o
1           x    
0 1 2 3 4 5 6
"""
function addWeakDominatedSolutionsInAnArchiveWorkProperly()
  solution1 = createContinuousSolution([1.0, 6.0])
  solution2 = createContinuousSolution([2.5, 5.0])
  solution3 = createContinuousSolution([2.5, 4.0])
  solution4 = createContinuousSolution([5.0, 3.0])
  solution5 = createContinuousSolution([5.0, 2.0])
  solution6 = createContinuousSolution([6.0, 1.0])

  archive = NonDominatedArchive(ContinuousSolution{Float64})
  add!(archive, solution1)
  add!(archive, solution2)
  add!(archive, solution3)
  add!(archive, solution4)
  add!(archive, solution5)
  add!(archive, solution6)

  return length(archive) == 4
end

@testset "Archive with six solution tests" begin    
  @test addWeakDominatedSolutionsInAnArchiveWorkProperly()
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