# Unit Tests for method minFastSort
@testset "minFastSort Tests" begin
    # Test 1
    x = [2.0, 1.0]
    idx = [1, 2]
    n = length(x)
    m = 2
    minFastSort!(x, idx, n, m)
    @test x == [1.0, 2.0]
    @test idx == [2, 1]

    # Test 2
    x = [1.0, 2.0, 3.0]
    idx = [1, 2, 3]
    n = length(x)
    m = 3
    minFastSort!(x, idx, n, m)
    @test x == [1.0, 2.0, 3.0]
    @test idx == [1, 2, 3]
end


numberOfWeightVectors = 100
neighborhoodSize = 20
weightVectorNeighborhood = WeightVectorNeighborhood(numberOfWeightVectors, neighborhoodSize)

@testset "WeightVectorNeighborhood initialization Tests" begin
    @test weightVectorNeighborhood.numberOfWeightVectors ==  numberOfWeightVectors
    @test weightVectorNeighborhood.neighborhoodSize == neighborhoodSize
    @test weightVectorNeighborhood.weightVectorSize == 2
    @test weightVectorNeighborhood.weightVector[1, 1] == 0.0
    @test weightVectorNeighborhood.weightVector[1, 2] == 1.0
    @test weightVectorNeighborhood.weightVector[2, 1] == 0.0101010101010101010101
    @test weightVectorNeighborhood.weightVector[2, 2] == 0.989898989898989898
    @test weightVectorNeighborhood.weightVector[100, 1] == 1.0
    @test weightVectorNeighborhood.weightVector[100, 2] == 0.0

    @test weightVectorNeighborhood.neighborhood[1,:] == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    @test weightVectorNeighborhood.neighborhood[70,:] == [70, 71, 69, 72, 68, 73, 67, 74, 66, 65, 75, 76, 64, 77, 63, 78, 62, 79, 61, 80]

    @test weightVectorNeighborhood.neighborType == false
end


function getNeighboursOfSolution1OfASolutionList()
    solutionList = [createContinuousSolution(2) for _ in 1:numberOfWeightVectors]

    neighbors = getNeighbors(weightVectorNeighborhood, solutionList, 1)
    
    return solutionList[1] == neighbors[1] && solutionList[20] == neighbors[20]
end

function getNeighboursOfSolution70OfASolutionList()
    solutionList = [createContinuousSolution(2) for _ in 1:numberOfWeightVectors]

    neighbors = getNeighbors(weightVectorNeighborhood, solutionList, 70)
    
    return solutionList[70] == neighbors[1] && solutionList[80] == neighbors[20]
end

@testset "Method getNeighbors() Tests" begin
    @test getNeighboursOfSolution1OfASolutionList() 
    @test getNeighboursOfSolution70OfASolutionList() 
end
