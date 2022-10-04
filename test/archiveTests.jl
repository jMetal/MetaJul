using Test

include("../src/archive.jl")

function addASolutionToAnEmtpyArchiveMakesItsLengthToBeOne()
  solution = ContinuousSolution{Float64}([1.0, 2.0], [1.0, 2.0], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

  emptyArchive = NonDominatedArchive{ContinuousSolution{Float64}}([])
  add(emptyArchive, solution)

  return length(emptyArchive) == 1
end

function addASolutionToAnEmtpyArchiveMakesItNonEmpty()
  solution = ContinuousSolution{Float64}([1.0, 2.0], [1.0, 2.0], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

  emptyArchive = NonDominatedArchive{ContinuousSolution{Float64}}([])
  add(emptyArchive, solution)

  return isEmpty(emptyArchive) == false
end

function addASolutionToAnEmtpyArchiveMakesTheArchiveToContainIt()
  solution = ContinuousSolution{Float64}([1.0, 2.0], [1.0, 2.0], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

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

###########

solution = ContinuousSolution{Float64}([1.0, 2.0], [1.0, 2.0], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
nonDominatedSolution = ContinuousSolution{Float64}([1.0, 2.0], [2.0, 1.0], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
dominatedSolution = ContinuousSolution{Float64}([1.0, 2.0], [1.5, 2.5], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
dominatingSolution = ContinuousSolution{Float64}([1.0, 2.0], [0.5, 0.5], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

function addANonDominatedSolutionToAnArchiveWithASolutionReturnsTrue() 
  archive = NonDominatedArchive([solution])
  
  return add(archive, nonDominatedSolution)
end

function addANonDominatedSolutionToAnArchiveWithASolutionIncreasesItsLengthByOne() 
  archive = NonDominatedArchive([solution])
  add(archive, nonDominatedSolution)

  return length(archive) == 2
end

function addADominatedSolutionToAnArchiveWithASolutionReturnFalse() 
  archive = NonDominatedArchive([solution])
  add(archive, dominatedSolution)

  return !add(archive, dominatedSolution)
end


function addADominatedSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength() 
  archive = NonDominatedArchive([solution])
  add(archive, dominatedSolution)

  return length(archive) == 1
end

function addADominatingSolutionToAnArchiveWithASolutionReturnsTrue() 
  archive = NonDominatedArchive([solution])
  
  return add(archive, dominatingSolution)
end

function addADominatingSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength() 
  #function addADominatingSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLengthAndRemovesTheExistingSolution() 
  archive = NonDominatedArchive([solution])
  add(archive, dominatingSolution)

  return length(archive) == 1
end

function addADominatingSolutionToAnArchiveWithASolutionRemovesTheExistingOneWhichIsReplacedByTheDominatingOne() 
  archive = NonDominatedArchive([solution])
  add(archive, dominatingSolution)

  return isequal(dominatingSolution, archive.solutions[1])
end


archiveWithASolution = NonDominatedArchive([solution])
@testset "Archive with a solution tests" begin    
  @test length(archiveWithASolution) == 1
  @test !isEmpty(archiveWithASolution)

  @test addANonDominatedSolutionToAnArchiveWithASolutionReturnsTrue()
  @test addANonDominatedSolutionToAnArchiveWithASolutionIncreasesItsLengthByOne()

  @test addADominatedSolutionToAnArchiveWithASolutionReturnFalse()
  @test addADominatedSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength()
  
  @test addADominatingSolutionToAnArchiveWithASolutionDoesNotIncreasesItsLength()
  @test addADominatingSolutionToAnArchiveWithASolutionRemovesTheExistingOneWhichIsReplacedByTheDominatingOne()
  @test addADominatingSolutionToAnArchiveWithASolutionReturnsTrue()
end