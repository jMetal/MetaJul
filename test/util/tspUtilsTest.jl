#########################################################################
# Test cases for TSP utilities 
#########################################################################

function readFourCitiesTSPWorksProperly()
  distanceMatrix = readTSPLibFile(joinpath(tsp_data_dir, "fourCitiesTSP.tsp"))
  numberOfRows = size(distanceMatrix, 1)

  return 4 == numberOfRows
end

function theDistanceForAnOrderedPermutationIsFour()
  distanceMatrix = readTSPLibFile(joinpath(tsp_data_dir, "fourCitiesTSP.tsp"))

  permutation = [1,2,3,4]

  return 4 == computeTourDistance(distanceMatrix, permutation)
end

function readKroA100ProblemProperly()
  distanceMatrix = readTSPLibFile(joinpath(tsp_data_dir, "kroA100.tsp"))
  numberOfRows = size(distanceMatrix, 1)

  return 100 == numberOfRows
end


@testset "Tests for tspUtils" begin    
  @test readFourCitiesTSPWorksProperly()
  @test theDistanceForAnOrderedPermutationIsFour()
  @test readKroA100ProblemProperly()
end
