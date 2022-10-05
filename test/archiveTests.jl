
include("../src/archive.jl")

# Utility function
function createContinuousSolution(numberOfObjectives::Int)::ContinuousSolution{Float64}
  objectives = [_ for _ in range(1, numberOfObjectives)]
  return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(1.0, 2.0)])
end

#########################################################################

function addASolutionToAnEmtpyArchiveMakesItsLengthToBeOne()
  solution = createContinuousSolution(3)

  archive = NonDominatedArchive{ContinuousSolution{Float64}}([])
  add!(archive, solution)

  return length(archive) == 1
end

function addASolutionToAnEmtpyArchiveEffectivelyAddTheSolution()
  solution = createContinuousSolution(3)

  emptyArchive = NonDominatedArchive{ContinuousSolution{Float64}}([])
  add!(emptyArchive, solution)

  return contain(emptyArchive, solution)
end

function addASolutionToAnEmtpyArchiveMakesItNonEmpty()
  solution = createContinuousSolution(3)

  archive = NonDominatedArchive{ContinuousSolution{Float64}}([])
  add!(archive, solution)

  return isEmpty(archive) == false
end

function addASolutionToAnEmtpyArchiveMakesTheArchiveToContainIt()
  solution = createContinuousSolution(3)

  archive = NonDominatedArchive{ContinuousSolution{Float64}}([])
  add!(archive, solution)

  return isequal(solution, archive.solutions[1])
end

emptyArchive = NonDominatedArchive([])

@testset "Empty non-dominated archive tests" begin    
  @test length(emptyArchive) == 0
  @test isEmpty(emptyArchive)

  @test addASolutionToAnEmtpyArchiveMakesItsLengthToBeOne()
  @test addASolutionToAnEmtpyArchiveEffectivelyAddTheSolution()
  @test addASolutionToAnEmtpyArchiveMakesItNonEmpty()
  @test addASolutionToAnEmtpyArchiveMakesTheArchiveToContainIt()
end

#########################################################################

function addANonDominatedSolutionToAnArchiveWithASolutionReturnsTrue() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  nonDominatedSolution = createContinuousSolution(3)
  nonDominatedSolution.objectives = [1.0, 1.0, 4.0]

  archive = NonDominatedArchive([solution])
  
  return add!(archive, nonDominatedSolution)
end

function addANonDominatedSolutionToAnArchiveWithASolutionContainsBothSolutions() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  nonDominatedSolution = createContinuousSolution(3)
  nonDominatedSolution.objectives = [1.0, 1.0, 4.0]

  archive = NonDominatedArchive([solution])
  add!(archive, nonDominatedSolution)
  
  return contain(archive, solution) && contain(archive, nonDominatedSolution)
end


function addANonDominatedSolutionToAnArchiveWithASolutionIncreasesItsLengthByOne() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  nonDominatedSolution = createContinuousSolution(3)
  nonDominatedSolution.objectives = [1.0, 1.0, 4.0]

  archive = NonDominatedArchive([solution])
  add!(archive, nonDominatedSolution)

  return length(archive) == 2
end

function addADominatedSolutionToAnArchiveWithASolutionReturnFalse() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatedSolution = createContinuousSolution(3)
  dominatedSolution.objectives = [2.0, 3.0, 4.0]

  archive = NonDominatedArchive([solution])
  add!(archive, dominatedSolution)

  return !add!(archive, dominatedSolution)
end


function addADominatedSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatedSolution = createContinuousSolution(3)
  dominatedSolution.objectives = [2.0, 3.0, 4.0]

  archive = NonDominatedArchive([solution])
  add!(archive, dominatedSolution)

  return length(archive) == 1
end


function addADominatingSolutionToAnArchiveWithASolutionReturnsTrue() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [0.0, 1.0, 2.0]

  archive = NonDominatedArchive([solution])
  
  return add!(archive, dominatingSolution)
end

function addADominatingSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [0.0, 1.0, 2.0]

  archive = NonDominatedArchive([solution])
  add!(archive, dominatingSolution)

  return length(archive) == 1
end

function addADominatingSolutionToAnArchiveWithASolutionRemovesTheExistingOneWhichIsReplacedByTheDominatingOne() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [0.0, 1.0, 2.0]

  archive = NonDominatedArchive([solution])
  add!(archive, dominatingSolution)

  return contain(archive, dominatingSolution) && !contain(archive, solution)
end


archiveWithASolution = NonDominatedArchive([createContinuousSolution(5)])
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

  archive = NonDominatedArchive([solution1, solution2])

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

  archive = NonDominatedArchive([solution1, solution2])

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

  archive = NonDominatedArchive([solution1, solution2])

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

  archive = NonDominatedArchive([solution1, solution2])

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