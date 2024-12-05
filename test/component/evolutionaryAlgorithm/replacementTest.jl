#######################################################
# Replacement unit tests
#######################################################

function muPlusLambdaReplacementIsCorrectlyInitialized()
    comparator = ElementAtComparator(1)
    replacement = MuPlusLambdaReplacement(comparator)

    return comparator == replacement.comparator
end

function muCommaLambdaReplacementIsCorrectlyInitialized()
    comparator = ElementAtComparator(1)
    replacement = MuCommaLambdaReplacement(comparator)

    return comparator == replacement.comparator
end

@testset "Replacement tests" begin
    @test muPlusLambdaReplacementIsCorrectlyInitialized()
    @test muCommaLambdaReplacementIsCorrectlyInitialized()
end

#######################################################
# Ranking and density estimator replacement unit tests
#######################################################

function rankingAndDensityEstimatorReplacementIsCorrectlyInitialized()
    ranking = DominanceRanking()
    densityEstimator = CrowdingDistanceDensityEstimator()
    replacement = RankingAndDensityEstimatorReplacement(ranking, densityEstimator)

    return ranking == replacement.ranking && densityEstimator == replacement.densityEstimator
end

"""
Case 1: o = offspring, x = population
3
2 o
1   x
0 1 2 3 
"""
function rankingAndDensityEstimatorReplacementWorksProperlyCase1()
    solution1 = createContinuousSolution([1.0, 2.0])
    solution2 = createContinuousSolution([2.0, 1.0])

    population = [solution1]
    offspringPopulation = [solution2]

    ranking = DominanceRanking()
    densityEstimator = CrowdingDistanceDensityEstimator()
    replacement = RankingAndDensityEstimatorReplacement(ranking, densityEstimator)

    resultPopulation = replace_(replacement, population, offspringPopulation)

    return length(resultPopulation) == 1 &&
           getRank(solution1) == 1 && getRank(solution2) == 1 && getCrowdingDistance(solution1) == typemax(Float64) && getCrowdingDistance(solution2) == typemax(Float64)
end

"""
Case 2: x = offspring, o = population
3
2   x
1 o   
0 1 2 3 
"""
function rankingAndDensityEstimatorReplacementWorksProperlyCase2()
    solution1 = createContinuousSolution([1.0, 1.0])
    solution2 = createContinuousSolution([2.0, 2.0])

    population = [solution1]
    offspringPopulation = [solution2]

    ranking = DominanceRanking()
    densityEstimator = CrowdingDistanceDensityEstimator()
    replacement = RankingAndDensityEstimatorReplacement(ranking, densityEstimator)

    resultPopulation = replace_(replacement, population, offspringPopulation)

    return length(resultPopulation) == 1 && isequal(solution1, resultPopulation[1]) &&
           getRank(solution1) == 1 && getRank(solution2) == 2 && getCrowdingDistance(solution1) == typemax(Float64) && getCrowdingDistance(solution2) == typemax(Float64)
end


"""
Case 3: x = offspring, o = population
4 o
3  x
2     o
1         x
0 1 2 3 4 5
"""
function rankingAndDensityEstimatorReplacementWorksProperlyCase3()
    solution1 = createContinuousSolution([1.0, 4.0])
    solution2 = createContinuousSolution([1.5, 3.0])
    solution3 = createContinuousSolution([3.0, 2.0])
    solution4 = createContinuousSolution([5.0, 1.0])

    population = [solution1, solution3]
    offspringPopulation = [solution2, solution4]

    ranking = DominanceRanking()
    densityEstimator = CrowdingDistanceDensityEstimator()
    replacement = RankingAndDensityEstimatorReplacement(ranking, densityEstimator)

    resultPopulation = replace_(replacement, population, offspringPopulation)

    return length(resultPopulation) == 2 &&
           getRank(solution1) == 1 &&
           getRank(solution2) == 1 &&
           getRank(solution3) == 1 &&
           getRank(solution4) == 1 &&
           solution1 in resultPopulation &&
           solution4 in resultPopulation &&
           getCrowdingDistance(solution1) == typemax(Float64) &&
           getCrowdingDistance(solution2) != typemax(Float64) &&
           getCrowdingDistance(solution3) != typemax(Float64) &&
           getCrowdingDistance(solution4) == typemax(Float64)
end

"""
Case 4: x = offspring, o = population
4 
3   x
2     o
1 o     x
0 1 2 3 4 5
"""
function rankingAndDensityEstimatorReplacementWorksProperlyCase4()
    solution1 = createContinuousSolution([1.0, 1.0])
    solution2 = createContinuousSolution([2.0, 3.0])
    solution3 = createContinuousSolution([3.0, 2.0])
    solution4 = createContinuousSolution([4.0, 1.0])

    population = [solution1, solution3]
    offspringPopulation = [solution2, solution4]

    ranking = DominanceRanking()
    densityEstimator = CrowdingDistanceDensityEstimator()
    replacement = RankingAndDensityEstimatorReplacement(ranking, densityEstimator)

    resultPopulation = replace_(replacement, population, offspringPopulation)

    return length(resultPopulation) == 2 &&
           getRank(solution1) == 1 &&
           getRank(solution2) == 2 &&
           getRank(solution3) == 2 &&
           getRank(solution4) == 2 &&
           solution1 in resultPopulation &&
           (solution2 in resultPopulation || solution4 in resultPopulation) &&
           getCrowdingDistance(solution1) == typemax(Float64) &&
           getCrowdingDistance(solution2) == typemax(Float64) &&
           getCrowdingDistance(solution3) != typemax(Float64) &&
           getCrowdingDistance(solution4) == typemax(Float64)
end

"""
Case 5: x = offspring, o = population
4 
3   x
2 o   o
1   x    
0 1 2 3 4 
"""
function rankingAndDensityEstimatorReplacementWorksProperlyCase5()
    solution1 = createContinuousSolution([1.0, 2.0])
    solution2 = createContinuousSolution([2.0, 1.0])
    solution3 = createContinuousSolution([2.0, 3.0])
    solution4 = createContinuousSolution([3.0, 2.0])

    population = [solution1, solution4]
    offspringPopulation = [solution2, solution3]

    ranking = DominanceRanking()
    densityEstimator = CrowdingDistanceDensityEstimator()
    replacement = RankingAndDensityEstimatorReplacement(ranking, densityEstimator)

    resultPopulation = replace_(replacement, population, offspringPopulation)

    return length(resultPopulation) == 2 &&
           getRank(solution1) == 1 &&
           getRank(solution2) == 1 &&
           getRank(solution3) == 2 &&
           getRank(solution4) == 2 &&
           solution1 in resultPopulation &&
           solution2 in resultPopulation &&
           getCrowdingDistance(solution1) == typemax(Float64) &&
           getCrowdingDistance(solution2) == typemax(Float64) &&
           getCrowdingDistance(solution3) == typemax(Float64) &&
           getCrowdingDistance(solution4) == typemax(Float64)
end

"""
Case 6: x = offspring, o = population
6 o
5  o
4   x
3      x
2          o
1           x    
0 1 2 3 4 5 6
"""
function rankingAndDensityEstimatorReplacementWorksProperlyCase6()
    solution1 = createContinuousSolution([1.0, 6.0])
    solution2 = createContinuousSolution([1.5, 5.0])
    solution3 = createContinuousSolution([2.0, 4.0])
    solution4 = createContinuousSolution([3.5, 3.0])
    solution5 = createContinuousSolution([5.5, 2.0])
    solution6 = createContinuousSolution([6.0, 1.0])

    population = [solution1, solution2, solution5]
    offspringPopulation = [solution3, solution4, solution6]

    ranking = DominanceRanking()
    densityEstimator = CrowdingDistanceDensityEstimator()
    replacement = RankingAndDensityEstimatorReplacement(ranking, densityEstimator)

    resultPopulation = replace_(replacement, population, offspringPopulation)

    return length(resultPopulation) == 3 &&
           getRank(solution1) == 1 &&
           getRank(solution2) == 1 &&
           getRank(solution3) == 1 &&
           getRank(solution4) == 1 &&
           getRank(solution5) == 1 &&
           getRank(solution6) == 1 &&
           solution1 in resultPopulation &&
           solution4 in resultPopulation &&
           solution6 in resultPopulation &&
           getCrowdingDistance(solution1) == typemax(Float64) &&
           getCrowdingDistance(solution2) != typemax(Float64) &&
           getCrowdingDistance(solution3) != typemax(Float64) &&
           getCrowdingDistance(solution6) == typemax(Float64)
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
function rankingAndDensityEstimatorReplacementWorksProperlyCase7()
    solution1 = createContinuousSolution([1.0, 6.0])
    solution2 = createContinuousSolution([2.5, 5.0])
    solution3 = createContinuousSolution([2.5, 4.0])
    solution4 = createContinuousSolution([5.0, 3.0])
    solution5 = createContinuousSolution([5.0, 2.0])
    solution6 = createContinuousSolution([6.0, 1.0])

    offspringPopulation = [solution1, solution2, solution5]
    population = [solution3, solution4, solution6]

    ranking = DominanceRanking()
    densityEstimator = CrowdingDistanceDensityEstimator()
    replacement = RankingAndDensityEstimatorReplacement(ranking, densityEstimator)

    resultPopulation = replace_(replacement, population, offspringPopulation)

    return length(resultPopulation) == 3 &&
           getRank(solution1) == 1 &&
           getRank(solution2) == 2 &&
           getRank(solution3) == 1 &&
           getRank(solution4) == 2 &&
           getRank(solution5) == 1 &&
           getRank(solution6) == 1 &&
           solution1 in resultPopulation &&
           solution3 in resultPopulation &&
           solution6 in resultPopulation &&
           getCrowdingDistance(solution1) == typemax(Float64) &&
           getCrowdingDistance(solution2) == typemax(Float64) &&
           getCrowdingDistance(solution4) == typemax(Float64) &&
           getCrowdingDistance(solution6) == typemax(Float64)
end

function rankingAndDensityEstimatorReplacementWorksProperlyCase8()
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
    densityEstimator = CrowdingDistanceDensityEstimator()
    replacement = RankingAndDensityEstimatorReplacement(ranking, densityEstimator)

    population = solutions[1:10]
    offspringPopulation = solutions[11:20]
    resultPopulation = replace_(replacement, population, offspringPopulation)

    return length(resultPopulation) == 10
end

function rankingAndDensityEstimatorReplacementWorksProperlyCase9()
    objectiveValues = [
        [0.5655121242688416, 122.05467685520247],
        [0.5655121250339731, 111.9985560901313],
        [0.43014627330305144, 120.42155746003654],
        [0.07336635446929285, 161.04962975606725],
        [0.43014627330305144, 160.40525052973234],
        [0.6762217810478277, 179.7511934374773],
        [0.43014627330305144, 151.06343252458754],
        [0.43014627330305144, 136.3722551798597],
        [0.7798429543256261, 88.00557995059926],
        [0.07336635446929285, 161.04962975606725],
        [0.43014627330305144, 120.42155746003654],
        [0.5655121250339731, 111.9985560901313],
        [0.5460487092960259, 116.39993882084455],
        [0.07336635446929285, 167.51690132793735],
        [0.5655121242688416, 122.05467685520247],
        [0.43014627330305144, 136.3722551798597]
    ]

    solutions = [createContinuousSolution(objectives) for objectives in objectiveValues]

    ranking = DominanceRanking()
    densityEstimator = CrowdingDistanceDensityEstimator()
    replacement = RankingAndDensityEstimatorReplacement(ranking, densityEstimator)

    population = solutions[1:8]
    offspringPopulation = solutions[9:16]

    #println(toString(population, "population"))
    #println(toString(offspringPopulation, "offspringPopulation"))
    resultPopulation = replace_(replacement, population, offspringPopulation)

    #println(toString(ranking))

    #println(toString(resultPopulation, "", densityEstimator))

    return length(resultPopulation) == 8
end


@testset "Ranking and crowdingDistance replacement tests" begin
    @test rankingAndDensityEstimatorReplacementIsCorrectlyInitialized()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase1()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase2()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase3()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase4()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase5()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase6()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase7()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase8()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase9()
end

#######################################################
# MOEAD Replacement unit tests
#######################################################

# Test that MOEADReplacement is correctly initialized with all expected fields
function moeadReplacementIsCorrectlyInitialized()
    numberOfWeightVectors = 100
    neighborhoodSize = 20
    neighborhood = WeightVectorNeighborhood(numberOfWeightVectors, neighborhoodSize)
    matingPoolSelection = PopulationAndNeighborhoodSelection(3, IntegerBoundedSequenceGenerator(1), neighborhood, 0.5, true)
    weightVectorNeighborhood = WeightVectorNeighborhood(numberOfWeightVectors, neighborhoodSize)
    aggregationFunction = PenaltyBoundaryIntersection()
    sequenceGenerator = IntegerPermutationGenerator(1)
    maxReplaced = 5
    normalize = true

    replacement = MOEADReplacement(
        matingPoolSelection,
        weightVectorNeighborhood,
        aggregationFunction,
        sequenceGenerator,
        maxReplaced,
        normalize
    )

    return replacement.matingPoolSelection == matingPoolSelection &&
           replacement.weightVectorNeighborhood == weightVectorNeighborhood &&
           replacement.aggregationFunction == aggregationFunction &&
           replacement.sequenceGenerator == sequenceGenerator &&
           replacement.maximumNumberOfReplacedSolutions == maxReplaced &&
           replacement.normalize == normalize &&
           replacement.firstReplacement == true
end

# Test updating of ideal and nadir points on replacement
function moeadReplacementUpdatesIdealAndNadirPoints()
    numberOfWeightVectors = 100
    neighborhoodSize = 20
    neighborhood = WeightVectorNeighborhood(numberOfWeightVectors, neighborhoodSize)
    matingPoolSelection = PopulationAndNeighborhoodSelection(3, IntegerBoundedSequenceGenerator(1), neighborhood, 0.5, true)
    weightVectorNeighborhood = WeightVectorNeighborhood(numberOfWeightVectors, neighborhoodSize)
    aggregationFunction = PenaltyBoundaryIntersection()
    sequenceGenerator = IntegerPermutationGenerator(1)
    maxReplaced = 5
    normalize = false

    replacement = MOEADReplacement(
        matingPoolSelection,
        weightVectorNeighborhood,
        aggregationFunction,
        sequenceGenerator,
        maxReplaced,
        normalize
    )

    # Create sample solutions
    solution1 = createContinuousSolution([1.0, 1.0])
    solution2 = createContinuousSolution([0.5, 0.5])

    population = [solution1]
    offspring = [solution2]

    # Perform replacement
    replace_(replacement, population, offspring)

    # Validate ideal point update
    updatedIdeal = replacement.idealPoint.point
    return updatedIdeal[1] == min(solution1.objectives[1], solution2.objectives[1]) &&
           updatedIdeal[2] == min(solution1.objectives[2], solution2.objectives[2])
end

# Test replacement behavior for a population with one solution and one offspring
function moeadReplacementWorksProperlySingleSolution()
    numberOfWeightVectors = 100
    neighborhoodSize = 20
    neighborhood = WeightVectorNeighborhood(numberOfWeightVectors, neighborhoodSize)
    matingPoolSelection = PopulationAndNeighborhoodSelection(3, IntegerBoundedSequenceGenerator(1), neighborhood, 0.5, true)
    weightVectorNeighborhood = WeightVectorNeighborhood(numberOfWeightVectors, neighborhoodSize)
    aggregationFunction = PenaltyBoundaryIntersection()
    sequenceGenerator = IntegerPermutationGenerator(1)
    maxReplaced = 1
    normalize = true

    replacement = MOEADReplacement(
        matingPoolSelection,
        weightVectorNeighborhood,
        aggregationFunction,
        sequenceGenerator,
        maxReplaced,
        normalize
    )

    solution1 = createContinuousSolution([1.0, 2.0])
    solution2 = createContinuousSolution([0.5, 1.5])

    population = [solution1]
    offspring = [solution2]

    resultPopulation = replace_(replacement, population, offspring)

    # Expecting population to contain offspring if it has a better aggregation score
    f1 = compute(aggregationFunction, solution1.objectives, weightVectorNeighborhood.weightVector[1, :], replacement.idealPoint, replacement.nadirPoint)
    f2 = compute(aggregationFunction, solution2.objectives, weightVectorNeighborhood.weightVector[1, :], replacement.idealPoint, replacement.nadirPoint)

    return length(resultPopulation) == 1 && (f2 < f1 ? isequal(resultPopulation[1], solution2) : isequal(resultPopulation[1], solution1))
end

@testset "MOEAD Replacement tests" begin
    @test moeadReplacementIsCorrectlyInitialized()
    @test moeadReplacementUpdatesIdealAndNadirPoints()
    @test moeadReplacementWorksProperlySingleSolution()
end
