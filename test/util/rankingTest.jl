# Unit tests for DominanceRanking

function createADominanceRankingWithADominanceComparatorWorksProperly()
    comparator = DefaultDominanceComparator()
    ranking = DominanceRanking(comparator)

    return comparator == ranking.dominanceComparator
end

function appendARankToAnEmtpyRankingLedToANumberOfRanksEqualToOne()
    solution1 = ContinuousSolution{Float64}([1.0, 2.0], [1.0, 2.0], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
    solution2 = ContinuousSolution{Float64}([1.0, 2.0], [2.0, 1.0], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
    solution3 = ContinuousSolution{Float64}([1.0, 2.0], [1.5, 1.5], [0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    nonDominatedSolutions = [solution1, solution2, solution3]

    ranking = DominanceRanking()

    appendRank!(ranking, nonDominatedSolutions)
    return numberOfRanks(ranking) == 1
end

@testset "Emtpy ranking tests" begin
    @test createADominanceRankingWithADominanceComparatorWorksProperly()
    @test length(DominanceRanking().ranks) == 0
    @test numberOfRanks(DominanceRanking()) == 0
    @test_throws "The subfront id 1 is not in the range 1:0" getSubFront(DominanceRanking(), 1)

    @test appendARankToAnEmtpyRankingLedToANumberOfRanksEqualToOne()
end

function computeRankingOfAnEmptySolutionListReturnAnEmptyRanking()
    solutions = Vector{ContinuousSolution{Float64}}(undef, 0)

    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return numberOfRanks(ranking) == 0
end

function computeRankingOfASolutionListWithASolutionReturnsARankingContainingThatSolution()
    solutions = [createContinuousSolution(3)]

    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return numberOfRanks(ranking) == 1 && isequal(solutions[1].objectives, ranking.ranks[1][1].objectives)
end

function computeRankingOfASolutionListWithTwoNonDominatedSolutionsReturnsASingleRank()
    solution1 = createContinuousSolution(3)
    solution1.objectives = [1.0, 2.0, 3.0]

    solution2 = createContinuousSolution(3)
    solution2.objectives = [1.0, 1.0, 4.0]

    solutions = [solution1, solution2]
    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return numberOfRanks(ranking) == 1
end

function computeRankingOfASolutionListWithTwoNonDominatedSolutionsReturnsASingleRankWithTheSolutions()
    solution1 = createContinuousSolution(3)
    solution1.objectives = [1.0, 2.0, 3.0]

    solution2 = createContinuousSolution(3)
    solution2.objectives = [1.0, 1.0, 4.0]

    solutions = [solution1, solution2]
    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return (getRank(solution1) == getRank(solution2) == 1) && (length(ranking.ranks[1]) == 2)
end

function computeRankingOfASolutionListWithTwoDominatedSolutionsReturnsTwoRankings()
    solution1 = createContinuousSolution(3)
    solution1.objectives = [1.0, 2.0, 3.0]

    solution2 = createContinuousSolution(3)
    solution2.objectives = [1.0, 1.0, 1.0]

    solutions = [solution1, solution2]

    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return (numberOfRanks(ranking) == 2) &&
           (length(ranking.ranks[1]) == 1) &&
           (length(ranking.ranks[2]) == 1) &&
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

    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return (numberOfRanks(ranking) == 3) &&
           (length(ranking.ranks[1]) == 1) &&
           (length(ranking.ranks[2]) == 1) &&
           (length(ranking.ranks[3]) == 1) &&
           (getRank(solution3) == 1) &&
           (getRank(solution2) == 2) &&
           (getRank(solution1) == 3)
end

"""
4 o
3  o
2     o
1         o
0 1 2 3 4 5
"""

function computeRankingOfASolutionListWithFourNonDominatedSolutionsReturnsOneRanking()
    solution1 = createContinuousSolution([1.0, 4.0])
    solution2 = createContinuousSolution([1.5, 3.0])
    solution3 = createContinuousSolution([3.0, 2.0])
    solution4 = createContinuousSolution([5.0, 1.0])

    solutions = [solution1, solution2, solution3, solution4]

    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return (numberOfRanks(ranking) == 1) &&
           (length(ranking.ranks[1]) == 4) &&
           (getRank(solution4) == 1) &&
           (getRank(solution3) == 1) &&
           (getRank(solution2) == 1) &&
           (getRank(solution1) == 1)
end

function computeRankingOfASolutionListWithTwoNonDominatedFrontsReturnsTwoRankings()
    solution1Front1 = createContinuousSolution([1.0, 2.0])
    solution2Front1 = createContinuousSolution([2.0, 1.0])
    solution1Front2 = createContinuousSolution([3.0, 4.0])
    solution2Front2 = createContinuousSolution([4.0, 3.0])
    solution3Front2 = createContinuousSolution([3.5, 3.5])

    solutions = [solution1Front1, solution3Front2, solution1Front2, solution2Front2, solution2Front1]

    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return (numberOfRanks(ranking) == 2) &&
           (length(ranking.ranks[1]) == 2) &&
           (length(ranking.ranks[2]) == 3) &&
           (getRank(solution1Front1) == 1) &&
           (getRank(solution2Front2) == 2)
end

"""
Case 7: o = offspring, x = population
6 o
5    o
4    x
3         x
2         o
1           x    
0 1 2 3 4 5 6
"""
function computeRankingOfASolutionListWithWeakDominatedSolutionsWorkProperly()
    solution1 = createContinuousSolution([1.0, 6.0])
    solution2 = createContinuousSolution([2.5, 5.0])
    solution3 = createContinuousSolution([2.5, 4.0])
    solution4 = createContinuousSolution([5.0, 3.0])
    solution5 = createContinuousSolution([5.0, 2.0])
    solution6 = createContinuousSolution([6.0, 1.0])

    solutions = [solution1, solution2, solution3, solution4, solution5, solution6]

    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return (numberOfRanks(ranking) == 2) &&
           (length(ranking.ranks[1]) == 4) &&
           (length(ranking.ranks[2]) == 2) &&
           (getRank(solution1) == 1) &&
           (getRank(solution6) == 1)
end

function computeRankingMustWorkProperlyWithTheExampleOfTheMNDSPaper()
    # https://doi.org/10.1109/TCYB.2020.2968301

    objectiveValues = [
        [34.0, 30.0, 41.0],
        [33.0, 34.0, 30.0],
        [32.0, 32.0, 31.0],
        [31.0, 34.0, 34.0],
        [34.0, 30.0, 40.0],
        [36.0, 33.0, 32.0],
        [35.0, 31.0, 43.0],
        [37.0, 36.0, 39.0],
        [35.0, 34.0, 38.0],
        [38.0, 38.0, 37.0],
        [39.0, 37.0, 31.0]
    ]

    solutions = [createContinuousSolution(objectives) for objectives in objectiveValues]

    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return numberOfRanks(ranking) == 3 &&
           length(ranking.ranks[1]) == 4 &&
           length(ranking.ranks[2]) == 4 &&
           length(ranking.ranks[3]) == 3
end

function computeRankingMustWorkProperlyWithAnExampleOfNineSolutions()
    objectiveValues = [
        [1.4648056109874181, 8.970087855444899E-34, 5.301705982489511E-43],
        [1.5908547487753466, 4.21325648871815E-91, 5.492563533270124E-38],
        [1.460628598699147, 7.251230487490275E-13, 6.836254915688127E-21],
        [1.53752105026832, 1.30774962272882E-89, 1.964911546564003E-276],
        [1.7827030380249338, 4.7213519324741183E-91, 1.093734894701149E-8],
        [1.5077459267903963, 3.717675758529715E-9, 7.056780562019277E-21],
        [1.7182703887918194, 4.567060424443055E-69, 6.126880230825156E-225],
        [1.551119525194089, 3.0514004681678587E-46, 1.927008515185969E-40],
        [1.572731735111519, 1.337698324772074E-89, 4.4182881457366E-206]
    ]

    solutions = [createContinuousSolution(objectives) for objectives in objectiveValues]

    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return numberOfRanks(ranking) == 2 &&
           length(ranking.ranks[1]) == 4 &&
           length(ranking.ranks[2]) == 5
end

function computeRankingMustWorkProperlyWithAnExampleOf20Solutions()
    objectiveValues = [
        [0.07336635446929285, 5.603220188306353],
        [0.43014627330305144, 5.708218645222796],
        [0.7798429543256261, 5.484124010814388],
        [0.49045165212590114, 5.784519349470215],
        [0.843511347097429, 5.435997012510192],
        [0.9279447115273152, 5.285778278767635],
        [0.5932205233840192, 6.887287053050965],
        [0.9455066295318578, 5.655731733404245],
        [0.9228750336383887, 4.8155865600591605],
        [0.022333588871048637, 5.357300649511081],
        [0.07336635446929285, 4.955242979343399],
        [0.9228750336383887, 4.368497851779355],
        [0.8409372615592949, 4.7393211155296315],
        [0.8452552028963248, 5.729254698390962],
        [0.4814413714745963, 4.814059473570379],
        [0.48149159013716136, 5.214371319566827],
        [0.9455066295318578, 5.024547164793679],
        [0.843511347097429, 4.823648491299312],
        [0.06050659328388003, 4.97308823770029],
        [0.07336635446929285, 5.603220188306353]
    ]

    solutions = [createContinuousSolution(objectives) for objectives in objectiveValues]

    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return numberOfRanks(ranking) == 5 &&
           length(ranking.ranks[1]) == 6 &&
           length(ranking.ranks[2]) == 5 &&
           length(ranking.ranks[3]) == 5
end

"""
5 1
4   2
3     3 (twice)
2
1         4
0 1 2 3 4 5
"""
function computeRankingWithTwoEqualSolutionsWorksProperly()
    solution1 = createContinuousSolution([1.0, 5.0])
    solution2 = createContinuousSolution([2.0, 4.0])
    solution3 = createContinuousSolution([3.0, 3.0])
    solution4 = createContinuousSolution([5.0, 1.0])
    solution5 = createContinuousSolution([3.0, 3.0])

    solutions = [solution1, solution2, solution3, solution4, solution5]

    ranking = DominanceRanking()
    compute!(ranking, solutions)

    return (numberOfRanks(ranking) == 1) &&
           (length(ranking.ranks[1]) == 5) &&
           (getRank(solution4) == 1) &&
           (getRank(solution3) == 1) &&
           (getRank(solution2) == 1) &&
           (getRank(solution1) == 1) &&
           (getRank(solution5) == 1)
end

@testset "Compute ranking tests" begin
    @test computeRankingOfAnEmptySolutionListReturnAnEmptyRanking()

    @test computeRankingOfASolutionListWithASolutionReturnsARankingContainingThatSolution()
    @test computeRankingOfASolutionListWithTwoNonDominatedSolutionsReturnsASingleRank()
    @test computeRankingOfASolutionListWithTwoNonDominatedSolutionsReturnsASingleRankWithTheSolutions()
    @test computeRankingOfASolutionListWithFourNonDominatedSolutionsReturnsOneRanking()

    @test computeRankingOfASolutionListWithTwoDominatedSolutionsReturnsTwoRankings()
    @test computeRankingOfASolutionListWithThreeDominatedSolutionsReturnsThreeRankings()
    @test computeRankingOfASolutionListWithTwoNonDominatedFrontsReturnsTwoRankings()
    @test computeRankingOfASolutionListWithWeakDominatedSolutionsWorkProperly()

    @test computeRankingMustWorkProperlyWithTheExampleOfTheMNDSPaper()
    @test computeRankingMustWorkProperlyWithAnExampleOfNineSolutions()
    @test computeRankingMustWorkProperlyWithAnExampleOf20Solutions()

    @test computeRankingWithTwoEqualSolutionsWorksProperly()
end

function compareTwoSolutionsWithEqualRankReturnsZero()
    solution1 = createContinuousSolution(2)
    solution2 = createContinuousSolution(2)

    setRank(solution1, 1)
    setRank(solution2, 1)

    return compare(DominanceRankingComparator(), solution1, solution2) == 0
end

function compareTwoSolutionsReturnMinusOneIfTheFirstSolutionHasALowerRankValue()
    solution1 = createContinuousSolution(2)
    solution2 = createContinuousSolution(2)

    setRank(solution1, 1)
    setRank(solution2, 2)

    comparator = DominanceRankingComparator()
    return compare(comparator, solution1, solution2) == -1
end

function compareTwoSolutionsReturnOneIfTheFirstSolutionHasAHigherRankValue()
    solution1 = createContinuousSolution(2)
    solution2 = createContinuousSolution(2)

    setRank(solution1, 2)
    setRank(solution2, 1)

    comparator = DominanceRankingComparator()
    return compare(comparator, solution1, solution2) == 1
end

@testset "Ranking comparators tests" begin
    @test compareTwoSolutionsWithEqualRankReturnsZero()

    @test compareTwoSolutionsReturnMinusOneIfTheFirstSolutionHasALowerRankValue()
    @test compareTwoSolutionsReturnOneIfTheFirstSolutionHasAHigherRankValue()
end