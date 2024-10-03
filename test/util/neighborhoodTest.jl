# Unit Tests for method minFastSort
@testset "minFastSort Tests" begin
    # Test 1
    x = [2.0, 1.0]
    idx = [1, 2]
    n = length(x)
    m = 2
    minFastSort(x, idx, n, m)
    @test x == [1.0, 2.0]
    @test idx == [2, 1]

    # Test 2
    x = [1.0, 2.0, 3.0]
    idx = [1, 2, 3]
    n = length(x)
    m = 3
    minFastSort(x, idx, n, m)
    @test x == [1.0, 2.0, 3.0]
    @test idx == [1, 2, 3]
end


weightVectorNeighborhood = WeightVectorNeighborhood{ContinuousSolution{Float64}}(100, 20)

function ()
    dimension = 4
    point = ArrayPoint(dimension)

    return values(point) == zeros(dimension)
end


@testset "WeightVectorNeighborhood initialization Tests" begin
    #@test constructorCreatesAnIdealPointWithAGivenDimension()

end
