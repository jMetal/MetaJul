#########################################################################
# Test cases for TSP utilities 
#########################################################################

function readFourCitiesTSPWorksProperly()
  distanceMatrix = readTSPLibFile("resources/tspDataFiles/fourCitiesTSP.tsp")
  numberOfRows = size(distanceMatrix, 1)

  return 4 == numberOfRows
end

function theDistanceForAnOrderedPermutationIsFour()
  distanceMatrix = readTSPLibFile("resources/tspDataFiles/fourCitiesTSP.tsp")

  permutation = [1,2,3,4]

  return 4 == computeTourDistance(distanceMatrix, permutation)
end

function readKroA100ProblemProperly()
  distanceMatrix = readTSPLibFile("resources/tspDataFiles/kroA100.tsp")
  numberOfRows = size(distanceMatrix, 1)

  return 100 == numberOfRows
end


@testset "Tests for tspUtils" begin    
  @test readFourCitiesTSPWorksProperly()
  @test theDistanceForAnOrderedPermutationIsFour()
  @test readKroA100ProblemProperly()
end
