using Test

include("../src/ranking.jl")
include("../src/solution.jl")

# Utility functions
function createContinuousSolution(numberOfObjectives::Int)::ContinuousSolution{Float64}
    objectives = [_ for _ in range(1, numberOfObjectives)]
    return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(1.0, 2.0)])
  end
  
function createContinuousSolution(objectives::Vector{Float64})::ContinuousSolution{Float64}
    return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(1.0, 2.0)])
end


function appendARankToAnEmtpyRankingLedToANumberOfRanksEqualToOne() 
    solution1 = ContinuousSolution{Float64}([1.0, 2.0], [1.0, 2.0], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
    solution2 = ContinuousSolution{Float64}([1.0, 2.0], [2.0, 1.0], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
    solution3 = ContinuousSolution{Float64}([1.0, 2.0], [1.5, 1.5], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    nonDominatedSolutions = [solution1, solution2, solution3]

    ranking = Ranking{ContinuousSolution{Float64}}()

    appendRank!(ranking, nonDominatedSolutions)
    return numberOfRanks(ranking) == 1
end

@testset "Emtpy ranking tests" begin    
    @test length(Ranking{ContinuousSolution{Float64}}().rank) == 0
    @test numberOfRanks(Ranking{ContinuousSolution{Float64}}()) == 0
    @test_throws "The subfront id 1 is not in the range 1:0" getSubFront(Ranking{ContinuousSolution{Float64}}(), 1)

    @test appendARankToAnEmtpyRankingLedToANumberOfRanksEqualToOne()
end

function computeRankingOfAnEmptySolutionListReturnAnEmptyRanking()
    solutions = Vector{ContinuousSolution{Float64}}(undef, 0)
    ranking = computeRanking(solutions)

    return numberOfRanks(ranking) == 0
end

function computeRankingOfASolutionListWithASolutionReturnsARankingContainingThatSolution()
    solutions = [createContinuousSolution(3)]
    ranking = computeRanking(solutions)

    return numberOfRanks(ranking) == 1 && isequal(solutions[1].objectives, ranking.rank[1][1].objectives)
end

function computeRankingOfASolutionListWithTwoNonDominatedSolutionsReturnsASingleRank()
    solution1 = createContinuousSolution(3)
    solution1.objectives = [1.0, 2.0, 3.0]

    solution2 = createContinuousSolution(3)
    solution2.objectives = [1.0, 1.0, 4.0]

    solutions = [solution1, solution2]
    ranking = computeRanking(solutions)

    return numberOfRanks(ranking) == 1 
end

function computeRankingOfASolutionListWithTwoNonDominatedSolutionsReturnsASingleRankWithTheSolutions()
    solution1 = createContinuousSolution(3)
    solution1.objectives = [1.0, 2.0, 3.0]

    solution2 = createContinuousSolution(3)
    solution2.objectives = [1.0, 1.0, 4.0]

    solutions = [solution1, solution2]
    ranking = computeRanking(solutions)

    return (getRank(solution1) == getRank(solution2) == 1) && (length(ranking.rank[1]) == 2)
end

function computeRankingOfASolutionListWithTwoDominatedSolutionsReturnsTwoRankings()
    solution1 = createContinuousSolution(3)
    solution1.objectives = [1.0, 2.0, 3.0]

    solution2 = createContinuousSolution(3)
    solution2.objectives = [1.0, 1.0, 1.0]

    solutions = [solution1, solution2]
    ranking = computeRanking(solutions)

    return (numberOfRanks(ranking) == 2) && 
    (length(ranking.rank[1]) == 1) && 
    (length(ranking.rank[2]) == 1) && 
    (getRank(solution2) == 1) && 
    (getRank(solution1) == 2)
end

function computeRankingOfASolutionListWithThreeDominatedSolutionsReturnsThreeRankings()
    solution1 = createContinuousSolution(3)
    solution1.objectives = [1.0, 2.0, 3.0]

    solution2 = createContinuousSolution(3)
    solution2.objectives = [1.0, 1.0, 1.0]

    solution3 = createContinuousSolution(3)
    solution3.objectives = [0.0, 0.0, 0.0]

    solutions = [solution1, solution2, solution3]
    ranking = computeRanking(solutions)

    return (numberOfRanks(ranking) == 3) && 
    (length(ranking.rank[1]) == 1) && 
    (length(ranking.rank[2]) == 1) && 
    (length(ranking.rank[3]) == 1) && 
    (getRank(solution3) == 1) && 
    (getRank(solution2) == 2) &&
    (getRank(solution1) == 3)
end

function computeRankingOfASolutionListWithThreeDominatedSolutionsReturnsThreeRankings()
    solution1 = createContinuousSolution(3)
    solution1.objectives = [1.0, 2.0, 3.0]

    solution2 = createContinuousSolution(3)
    solution2.objectives = [1.0, 1.0, 1.0]

    solution3 = createContinuousSolution(3)
    solution3.objectives = [0.0, 0.0, 0.0]

    solutions = [solution1, solution2, solution3]
    ranking = computeRanking(solutions)

    return (numberOfRanks(ranking) == 3) && 
    (length(ranking.rank[1]) == 1) && 
    (length(ranking.rank[2]) == 1) && 
    (length(ranking.rank[3]) == 1) && 
    (getRank(solution3) == 1) && 
    (getRank(solution2) == 2) &&
    (getRank(solution1) == 3)
end

function computeRankingOfASolutionListWithTwoNonDominatedFrontsReturnsTwoRankings()
    solution1Front1 = createContinuousSolution([1.0, 2.0])
    solution2Front1 = createContinuousSolution([2.0, 1.0])
    solution1Front2 = createContinuousSolution([3.0, 4.0])
    solution2Front2 = createContinuousSolution([4.0, 3.0])
    solution3Front2 = createContinuousSolution([3.5, 3.5])

    solutions = [solution1Front1, solution3Front2, solution1Front2, solution2Front2, solution2Front1]
    ranking = computeRanking(solutions)

    return (numberOfRanks(ranking) == 2) && 
    (length(ranking.rank[1]) == 2) && 
    (length(ranking.rank[2]) == 3) && 
    (getRank(solution1Front1) == 1) && 
    (getRank(solution2Front2) == 2) 
end

@testset "Compute ranking tests" begin    
    @test computeRankingOfAnEmptySolutionListReturnAnEmptyRanking()

    @test computeRankingOfASolutionListWithASolutionReturnsARankingContainingThatSolution()
    @test computeRankingOfASolutionListWithTwoNonDominatedSolutionsReturnsASingleRank()
    @test computeRankingOfASolutionListWithTwoNonDominatedSolutionsReturnsASingleRankWithTheSolutions()
    @test computeRankingOfASolutionListWithTwoDominatedSolutionsReturnsTwoRankings()
    @test computeRankingOfASolutionListWithThreeDominatedSolutionsReturnsThreeRankings()
    @test computeRankingOfASolutionListWithTwoNonDominatedFrontsReturnsTwoRankings()
end