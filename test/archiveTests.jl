using Test

include("../src/archive.jl")

# Utility function
function createContinuousSolution(numberOfObjectives::Int)::ContinuousSolution{Float64}
  objectives = [_ for _ in range(1, numberOfObjectives)]
  return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(1.0, 2.0)])
end

function addASolutionToAnEmtpyArchiveMakesItsLengthToBeOne()
  solution = createContinuousSolution(3)

  emptyArchive = NonDominatedArchive{ContinuousSolution{Float64}}([])
  add(emptyArchive, solution)

  return length(emptyArchive) == 1
end

function addASolutionToAnEmtpyArchiveMakesItNonEmpty()
  solution = createContinuousSolution(3)

  emptyArchive = NonDominatedArchive{ContinuousSolution{Float64}}([])
  add(emptyArchive, solution)

  return isEmpty(emptyArchive) == false
end

function addASolutionToAnEmtpyArchiveMakesTheArchiveToContainIt()
  solution = createContinuousSolution(3)

  emptyArchive = NonDominatedArchive{ContinuousSolution{Float64}}([])
  add(emptyArchive, solution)

  return isequal(solution, emptyArchive.solutions[1])
end

emptyArchive = NonDominatedArchive([])

@testset "Empty non-dominated archive tests" begin    
  @test length(emptyArchive) == 0
  @test isEmpty(emptyArchive)

  @test addASolutionToAnEmtpyArchiveMakesItsLengthToBeOne()
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
  
  return add(archive, nonDominatedSolution)
end


function addANonDominatedSolutionToAnArchiveWithASolutionIncreasesItsLengthByOne() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  nonDominatedSolution = createContinuousSolution(3)
  nonDominatedSolution.objectives = [1.0, 1.0, 4.0]

  archive = NonDominatedArchive([solution])
  add(archive, nonDominatedSolution)

  return length(archive) == 2
end

function addADominatedSolutionToAnArchiveWithASolutionReturnFalse() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatedSolution = createContinuousSolution(3)
  dominatedSolution.objectives = [2.0, 3.0, 4.0]

  archive = NonDominatedArchive([solution])
  add(archive, dominatedSolution)

  return !add(archive, dominatedSolution)
end


function addADominatedSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatedSolution = createContinuousSolution(3)
  dominatedSolution.objectives = [2.0, 3.0, 4.0]

  archive = NonDominatedArchive([solution])
  add(archive, dominatedSolution)

  return length(archive) == 1
end


function addADominatingSolutionToAnArchiveWithASolutionReturnsTrue() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [0.0, 1.0, 2.0]

  archive = NonDominatedArchive([solution])
  
  return add(archive, dominatingSolution)
end

function addADominatingSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [0.0, 1.0, 2.0]

  archive = NonDominatedArchive([solution])
  add(archive, dominatingSolution)

  return length(archive) == 1
end

function addADominatingSolutionToAnArchiveWithASolutionRemovesTheExistingOneWhichIsReplacedByTheDominatingOne() 
  solution = createContinuousSolution(3)
  solution.objectives = [1.0, 2.0, 3.0]

  dominatingSolution = createContinuousSolution(3)
  dominatingSolution.objectives = [0.0, 1.0, 2.0]

  archive = NonDominatedArchive([solution])
  add(archive, dominatingSolution)

  return isequal(dominatingSolution, archive.solutions[1])
end

archiveWithASolution = NonDominatedArchive([createContinuousSolution(5)])
@testset "Archive with a solution tests" begin    
  @test length(archiveWithASolution) == 1
  @test !isEmpty(archiveWithASolution)

  @test addANonDominatedSolutionToAnArchiveWithASolutionReturnsTrue()
  @test addANonDominatedSolutionToAnArchiveWithASolutionIncreasesItsLengthByOne()

  @test addADominatedSolutionToAnArchiveWithASolutionReturnFalse()
  @test addADominatedSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength()
  
  @test addADominatingSolutionToAnArchiveWithASolutionReturnsTrue()
  @test addADominatingSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength()
  @test addADominatingSolutionToAnArchiveWithASolutionRemovesTheExistingOneWhichIsReplacedByTheDominatingOne()
end

#########################################################################
