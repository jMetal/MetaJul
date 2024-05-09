#######################################################
# Replacement unit tests
#######################################################

function muPlusLambdaReplacementIsCorrectlyInitialized()
    replacement = MuPlusLambdaReplacement(compareElementAt)

    return compareElementAt == replacement.comparator
end

function RankingAndDensityEstimatorReplacementIsCorrectlyInitialized()
    replacement = RankingAndDensityEstimatorReplacement(compareForDominance)

    return compareForDominance == replacement.dominanceComparator
end

@testset "Replacement tests" begin    
    @test muPlusLambdaReplacementIsCorrectlyInitialized()
    @test RankingAndDensityEstimatorReplacementIsCorrectlyInitialized()
end