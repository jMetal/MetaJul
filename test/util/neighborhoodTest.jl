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
end