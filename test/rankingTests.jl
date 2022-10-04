using Test

include("../src/ranking.jl")
include("../src/solution.jl")

solution1 = ContinuousSolution{Float64}([1.0, 2.0], [1.0, 2.0], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
solution2 = ContinuousSolution{Float64}([1.0, 2.0], [2.0, 1.0], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
solution3 = ContinuousSolution{Float64}([1.0, 2.0], [1.5, 1.5], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

nonDominatedSolutions = [solution1, solution2, solution3]

function getEmtpyRanking()::Ranking{ContinuousSolution{Float64}}
  return Ranking{ContinuousSolution{Float64}}(Array{Array{Solution}}(undef, 0))
end

function appendARankToAnEmtpyRankingLedToANumberOfRanksEqualToOne() 
    ranking = getEmtpyRanking()
    appendRank!(nonDominatedSolutions, ranking)
    return numberOfRanks(ranking) == 1
end

@testset "Emtpy ranking tests" begin    
    @test length(getEmtpyRanking().rank) == 0
    @test numberOfRanks(getEmtpyRanking()) == 0
    @test_throws "The subfront id 1 is not in the range 1:0" getSubFront(getEmtpyRanking(), 1)

    @test appendARankToAnEmtpyRankingLedToANumberOfRanksEqualToOne()
end