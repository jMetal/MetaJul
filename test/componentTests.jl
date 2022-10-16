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

    resultPopulation = rankingAndDensityEstimatorReplacement(population, offspringPopulation, (comparator = compareRankingAndCrowdingDistance,))

    return length(resultPopulation) == 1 &&
    getRank(solution1) == 1 && getRank(solution2) == 1 && getCrowdingDistance(solution1) == typemax(Float64) && getCrowdingDistance(solution2) ==  typemax(Float64)
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

    resultPopulation = rankingAndDensityEstimatorReplacement(population, offspringPopulation, (comparator = compareRankingAndCrowdingDistance,))

    return length(resultPopulation) == 1 && isequal(solution1, resultPopulation[1]) &&
    getRank(solution1) == 1 && getRank(solution2) == 2 && getCrowdingDistance(solution1) == typemax(Float64) && getCrowdingDistance(solution2) ==  typemax(Float64)
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

    resultPopulation = rankingAndDensityEstimatorReplacement(population, offspringPopulation, (comparator = compareRankingAndCrowdingDistance,))

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
    getCrowdingDistance(solution4) ==  typemax(Float64)
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

    resultPopulation = rankingAndDensityEstimatorReplacement(population, offspringPopulation, (comparator = compareRankingAndCrowdingDistance,))

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
    getCrowdingDistance(solution4) ==  typemax(Float64)
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

    resultPopulation = rankingAndDensityEstimatorReplacement(population, offspringPopulation, (comparator = compareRankingAndCrowdingDistance,))

    return length(resultPopulation) == 2 &&
    getRank(solution1) == 1 && 
    getRank(solution2) == 1 && 
    getRank(solution3) == 2 && 
    getRank(solution4) == 2 && 
    solution1 in resultPopulation &&
    solution2 in resultPopulation  &&
    getCrowdingDistance(solution1) == typemax(Float64) && 
    getCrowdingDistance(solution2) == typemax(Float64) && 
    getCrowdingDistance(solution3) == typemax(Float64) && 
    getCrowdingDistance(solution4) ==  typemax(Float64)
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

    resultPopulation = rankingAndDensityEstimatorReplacement(population, offspringPopulation, (comparator = compareRankingAndCrowdingDistance,))

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
    getCrowdingDistance(solution6) ==  typemax(Float64)
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

    resultPopulation = rankingAndDensityEstimatorReplacement(population, offspringPopulation, (comparator = compareRankingAndCrowdingDistance,))

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
    getCrowdingDistance(solution6) ==  typemax(Float64)
end


@testset "Ranking and crowdingDistance replacement tests" begin    
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase1()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase2()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase3()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase4()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase5()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase6()
    @test rankingAndDensityEstimatorReplacementWorksProperlyCase7()
end