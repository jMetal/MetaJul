include("../src/solution.jl")
include("../src/densityEstimator.jl")
include("../src/ranking.jl")
include("../src/component.jl")

function compareTwoSolutionsWithDifferentRankingIgnoreTheCrowdingDistance()
    solution1 = createContinuousSolution(3)
    setRank(solution1, 2)
    setCrowdingDistance(solution1, 10.0)

    solution2 = createContinuousSolution(3)
    setRank(solution2, 3)
    setCrowdingDistance(solution2, 20.0)

    return compareRankingAndCrowdingDistance(solution1, solution2) == -1
end

function compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase1()
    solution1 = createContinuousSolution(3)
    setRank(solution1, 4)
    setCrowdingDistance(solution1, 10.0)

    solution2 = createContinuousSolution(3)
    setRank(solution2, 4)
    setCrowdingDistance(solution2, 20.0)

    return compareRankingAndCrowdingDistance(solution1, solution2) == 1
end

function compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase2()
    solution1 = createContinuousSolution(3)
    setRank(solution1, 4)
    setCrowdingDistance(solution1, 20.0)

    solution2 = createContinuousSolution(3)
    setRank(solution2, 4)
    setCrowdingDistance(solution2, 20.0)

    return compareRankingAndCrowdingDistance(solution1, solution2) == 0
end

function compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase3()
    solution1 = createContinuousSolution(3)
    setRank(solution1, 4)
    setCrowdingDistance(solution1, 20.0)

    solution2 = createContinuousSolution(3)
    setRank(solution2, 4)
    setCrowdingDistance(solution2, 10.0)

    return compareRankingAndCrowdingDistance(solution1, solution2) == -1
end

@testset "Comparing ranking and crowding distance tests" begin    
    @test compareTwoSolutionsWithDifferentRankingIgnoreTheCrowdingDistance()
    @test compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase1()
    @test compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase2()
    @test compareTwoSolutionsWithEqualRankingConsiderTheCrowdingDistanceCase3()
end

###############################



@testset "Ranking and crowdingDistance replacement tests" begin    

end