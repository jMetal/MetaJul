include("../src/solution.jl")
include("../src/densityEstimator.jl")
include("../src/ranking.jl")
include("../src/continuousProblem.jl")
include("../src/component.jl")

###############################
# Selection unit tests
###############################

function randomSelectionWithReplacementReturnAListOfOnesIfTheSolutionListSizeIsOne()
    solutions = [createContinuousSolution(3)]

    selectionParameters = (matingPoolSize = 5, withReplacement=true)
    return [solutions[1] for i in 1:5] == randomMatingPoolSelection(solutions, selectionParameters)
end

function randomSelectionWithReplacementReturnAListWithTheMatingPoolSize()
    solutionListSize = 10
    solutions = [createContinuousSolution(3) for _ in 1:solutionListSize]

    selectionParameters = (matingPoolSize=5, withReplacement=true)
    selectedSolutions = randomMatingPoolSelection(solutions, selectionParameters)
    
    return length(selectedSolutions) == 5
end

@testset "Random mating pool with replacement tests" begin  
    @test randomSelectionWithReplacementReturnAListOfOnesIfTheSolutionListSizeIsOne()
    @test randomSelectionWithReplacementReturnAListWithTheMatingPoolSize()
end  

function randomSelectionWithoutReplacementRaisesAnExceptionIfTheMatingPoolSizeIsHigherThanTheSolutionListSize()
    solutionListSize = 10
    matingPoolSize = 11
    solutions = [createContinuousSolution(3) for _ in 1:solutionListSize]

    selectionParameters = (matingPoolSize = matingPoolSize, withReplacement=false)
    randomMatingPoolSelection(solutions, selectionParameters)
end

# Case 1: population size = 10, matingPool = 10
function randomSelectionWithoutReplacementReturnsAPermutationCase1()
    solutionListSize = 10
    matingPoolSize = 10
    solutions = [createContinuousSolution(3) for _ in 1:solutionListSize]

    selectionParameters = (matingPoolSize = matingPoolSize, withReplacement=false)
    selectedSolutions = randomMatingPoolSelection(solutions, selectionParameters)

    return  all(i -> solutions[i] in selectedSolutions, [_ for _ in range(1,solutionListSize)])
end

# Case 2: population size = 10, matingPool = 4

@testset "Random mating pool without replacement tests" begin  
    @test_throws "The mating pool size 11 is higher than the population size 10"  randomSelectionWithoutReplacementRaisesAnExceptionIfTheMatingPoolSizeIsHigherThanTheSolutionListSize()

    @test randomSelectionWithoutReplacementReturnsAPermutationCase1()
end  

####################################################
# Compare ranking and crowding distance unit tests
####################################################

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

#######################################################
# Ranking and density estimator replacement unit tests
#######################################################

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

    replacement = RankingAndDensityEstimatorReplacement((dominanceComparator = compareForDominance, ))
    resultPopulation = replacement.replace(population, offspringPopulation, replacement.parameters)
    
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

    replacement = RankingAndDensityEstimatorReplacement((dominanceComparator = compareForDominance, ))
    resultPopulation = replacement.replace(population, offspringPopulation, replacement.parameters)
 
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

    replacement = RankingAndDensityEstimatorReplacement((dominanceComparator = compareForDominance, ))
    resultPopulation = replacement.replace(population, offspringPopulation, replacement.parameters)
 
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

    replacement = RankingAndDensityEstimatorReplacement((dominanceComparator = compareForDominance, ))
    resultPopulation = replacement.replace(population, offspringPopulation, replacement.parameters)
 
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

    replacement = RankingAndDensityEstimatorReplacement((dominanceComparator = compareForDominance, ))
    resultPopulation = replacement.replace(population, offspringPopulation, replacement.parameters)
 
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

    replacement = RankingAndDensityEstimatorReplacement((dominanceComparator = compareForDominance, ))
    resultPopulation = replacement.replace(population, offspringPopulation, replacement.parameters)
 
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

    replacement = RankingAndDensityEstimatorReplacement((dominanceComparator = compareForDominance, ))
    resultPopulation = replacement.replace(population, offspringPopulation, replacement.parameters)
 
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

#######################################################
# Solutions creation unit tests
#######################################################

function defaultSolutionsCreationIsCorrectlyInitialized()
    problem = ContinuousProblem{Real}([],[],[],"")

    solutionsCreation = DefaultSolutionsCreation((problem = problem, numberOfSolutionsToCreate = 25))

    return solutionsCreation.parameters.problem == problem && solutionsCreation.parameters.numberOfSolutionsToCreate == 25 && solutionsCreation.create == defaultSolutionsCreation
end

function defaultSolutionsCreationCreatesTheNumberOfIndicatedSolutions()
    problem::ContinuousProblem = ContinuousProblem{Real}([],[],[],"")

    solutionsCreation = DefaultSolutionsCreation((problem = problem, numberOfSolutionsToCreate = 25))
    solutions = solutionsCreation.create(solutionsCreation.parameters)

    return length(solutions) == 25
end


@testset "Solutions creation tests" begin    
    @test defaultSolutionsCreationIsCorrectlyInitialized()
    @test defaultSolutionsCreationCreatesTheNumberOfIndicatedSolutions()
end

#######################################################
# Evaluation unit tests
#######################################################

function sequentialEvaluationIsCorrectlyInitialized()
    problem = ContinuousProblem{Real}([],[],[],"")

    evaluation = SequentialEvaluation((problem = problem,))

    return evaluation.evaluate == sequentialEvaluation && problem == problem
end

function sequentialEvaluationEvaluatesTheSolutions()
    problem = ContinuousProblem{Real}([],[],[],"")
    addObjective(problem, x -> 2)
    addVariable(problem, Bounds{Real}(1, 3))

    numberOfSolutions = 3
    solutions = [createSolution(problem)]
    push!(solutions, createSolution(problem))
    push!(solutions, createSolution(problem))

    evaluation = SequentialEvaluation((problem = problem,))
    evaluatedSolutions = evaluation.evaluate(solutions, evaluation.parameters)

    return length(evaluatedSolutions) == numberOfSolutions && 
    evaluatedSolutions[1].objectives[1] == 2 && 
    evaluatedSolutions[2].objectives[1] == 2
end

function sequentialEvaluationWithArchiveIsCorrectlyInitialized()
    problem = ContinuousProblem{Real}([],[],[],"")
    externalArchive = CrowdingDistanceArchive(10, ContinuousSolution{Float64})

    evaluation = SequentialEvaluationWithArchive((archive = externalArchive, problem = problem))

    return evaluation.evaluate == sequentialEvaluationWithArchive && evaluation.parameters.problem == problem 
end

function sequentialEvaluationWithArchiveEvaluatesTheSolutions()
    problem = ContinuousProblem{Float64}([],[],[],"")
    addObjective(problem, x -> 2)
    addVariable(problem, Bounds{Float64}(1, 3))

    numberOfSolutions = 3
    solutions = [createSolution(problem)]
    push!(solutions, createSolution(problem))
    push!(solutions, createSolution(problem))

    externalArchive = CrowdingDistanceArchive(10, ContinuousSolution{Float64})
    evaluation = SequentialEvaluationWithArchive((archive = externalArchive, problem = problem))
    evaluatedSolutions = evaluation.evaluate(solutions, evaluation.parameters)

    return length(evaluatedSolutions) == numberOfSolutions && 
    evaluatedSolutions[1].objectives[1] == 2 && 
    evaluatedSolutions[2].objectives[1] == 2
end

function sequentialEvaluationWithArchiveAddsTheSolutionsToTheArchiveEvaluatesTheSolutions()
    problem = ContinuousProblem{Float64}([],[],[],"")
    addObjective(problem, x -> x[1] * 0.5)
    addVariable(problem, Bounds{Float64}(1, 3))

    solutions = [createSolution(problem)]
    push!(solutions, createSolution(problem))
    push!(solutions, createSolution(problem))

    externalArchive = CrowdingDistanceArchive(10, ContinuousSolution{Float64})
    evaluation = SequentialEvaluationWithArchive((archive = externalArchive, problem = problem))
    evaluation.evaluate(solutions, evaluation.parameters)

    return length(externalArchive) >= 1
end

@testset "Sequential evaluation tests" begin    
    @test sequentialEvaluationIsCorrectlyInitialized()
    @test sequentialEvaluationEvaluatesTheSolutions()

    @test sequentialEvaluationWithArchiveIsCorrectlyInitialized() 
    @test sequentialEvaluationWithArchiveEvaluatesTheSolutions() 
    @test sequentialEvaluationWithArchiveAddsTheSolutionsToTheArchiveEvaluatesTheSolutions() 
end

#######################################################
# Selection unit tests
#######################################################

function binaryTournamentSelectionIsCorrectlyInitialized()
    selection = BinaryTournamentSelection((matingPoolSize = 100, comparator = compareIthObjective))

    return selection.parameters.matingPoolSize == 100 && selection.parameters.comparator == compareIthObjective && selection.select == binaryTournamentMatingPoolSelection
end

"""
Case A: population size = 2; mating poolSize = 1
"""
function binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseA()
    solution1 = createContinuousSolution([1.0])
    solution2 = createContinuousSolution([2.0])
    solutions = [solution1, solution2]
    selection = BinaryTournamentSelection((matingPoolSize = 1, comparator = compareIthObjective))

    matingPool = selection.select(solutions, selection.parameters)
    return (length(matingPool) == 1)
end

"""
Case B: population size = 2; mating poolSize = 2
"""
function binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseB()
    solution1 = createContinuousSolution([1.0])
    solution2 = createContinuousSolution([2.0])
    solutions = [solution1, solution2]
    selection = BinaryTournamentSelection((matingPoolSize = 2, comparator = compareIthObjective))

    matingPool = selection.select(solutions, selection.parameters)
    return (length(matingPool) == 2)
end

"""
Case C: population size = 2; mating poolSize = 4
"""
function binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseC()
    solution1 = createContinuousSolution([1.0])
    solution2 = createContinuousSolution([2.0])
    solutions = [solution1, solution2]
    selection = BinaryTournamentSelection((matingPoolSize = 4, comparator = compareIthObjective))

    matingPool = selection.select(solutions, selection.parameters)
    return (length(matingPool) == 4)
end

function randomSelectionIsCorrectlyInitialized()
    selection = RandomSelection((matingPoolSize = 100, withReplacement = true))

    return selection.parameters.matingPoolSize == 100 && selection.select == randomMatingPoolSelection
end

function randomSelectionReturnTheNumberOfRequiredSolutions()
    solution1 = createContinuousSolution([1.0])
    solution2 = createContinuousSolution([2.0])
    solutions = [solution1, solution2]

    selection = RandomSelection((matingPoolSize = 10, withReplacement = true))
    matingPool = selection.select(solutions, selection.parameters)

    return length(matingPool) == 10 
end

function randomSelectionAppliedToAListWithASolutionReturnsThatSolution()
    solutions = [createContinuousSolution([1.0])]

    selection = RandomSelection((matingPoolSize = 4, withReplacement = true))
    matingPool = selection.select(solutions, selection.parameters)

    return selection.parameters.matingPoolSize == 4 && matingPool[1].objectives[1] == 1.0 && matingPool[4].objectives[1] == 1.0
end

function randomSelectionWithoutReplacementReturnsTheListOfSolutionsIfItsSizeIsEqualToTheMatingPoolSize()
    solution1 = createContinuousSolution([1.0])
    solution2 = createContinuousSolution([2.0])
    solution3 = createContinuousSolution([5.0])
    solution4 = createContinuousSolution([3.0])
    solutions = [solution1, solution2, solution3, solution4]

    selection = RandomSelection((matingPoolSize = 4, withReplacement = false))
    matingPool = selection.select(solutions, selection.parameters)
    return length(matingPool) == 4 && all(solution -> solution in matingPool, solutions)
end

@testset "Selection tests" begin    
    @test binaryTournamentSelectionIsCorrectlyInitialized()
    @test binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseA()
    @test binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseB()
    @test binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseC()

    @test randomSelectionIsCorrectlyInitialized()
    @test randomSelectionReturnTheNumberOfRequiredSolutions()
    @test randomSelectionAppliedToAListWithASolutionReturnsThatSolution()
    @test randomSelectionWithoutReplacementReturnsTheListOfSolutionsIfItsSizeIsEqualToTheMatingPoolSize()
end

#######################################################
# Crossover and mutation variation unit tests
#######################################################

function CrossoverAndMutationVariationIsCorrectlyInitializedWithOffspringPopulationSizeOf100()
    mutation = UniformMutation((probability=0.01, perturbation=0.5, bounds=[]))
    crossover = SBXCrossover((probability=1.0, distributionIndex=20.0, bounds=[]))
    variation = CrossoverAndMutationVariation((offspringPopulationSize = 100, crossover = crossover, mutation = mutation))

    expectedMatingPoolSize = 100

    return expectedMatingPoolSize == variation.matingPoolSize && mutation == variation.parameters.mutation && crossover == variation.parameters.crossover && variation.variate == crossoverAndMutationVariation
end

function CrossoverAndMutationVariationIsCorrectlyInitializedWithOffspringPopulationSizeOfOne()
    mutation = UniformMutation((probability=0.01, perturbation=0.5, bounds=[]))
    crossover = SBXCrossover((probability=1.0, distributionIndex=20.0, bounds=[]))
    variation = CrossoverAndMutationVariation((offspringPopulationSize = 1, crossover = crossover, mutation = mutation))

    expectedMatingPoolSize = 2

    return expectedMatingPoolSize == variation.matingPoolSize && mutation == variation.parameters.mutation && crossover == variation.parameters.crossover && variation.variate == crossoverAndMutationVariation
end

@testset "Crossover and mutation variation tests" begin    
    @test CrossoverAndMutationVariationIsCorrectlyInitializedWithOffspringPopulationSizeOf100()
    @test CrossoverAndMutationVariationIsCorrectlyInitializedWithOffspringPopulationSizeOfOne()
end

#######################################################
# Replacement unit tests
#######################################################

function muPlusLambdaReplacementIsCorrectlyInitialized()
    replacement = MuPlusLambdaReplacement((comparator = compareElementAt, ))

    return replacement.parameters.comparator == compareElementAt
end

function RankingAndDensityEstimatorReplacementIsCorrectlyInitialized()
    replacement = RankingAndDensityEstimatorReplacement((dominanceComparator = compareForDominance, ))

    return replacement.parameters.dominanceComparator == compareForDominance
end

@testset "Replacement tests" begin    
    @test muPlusLambdaReplacementIsCorrectlyInitialized()

    @test RankingAndDensityEstimatorReplacementIsCorrectlyInitialized()
end

#######################################################
# Termination unit tests
#######################################################

function terminationByEvaluationsIsCorrectlyInitialized()
    termination = TerminationByEvaluations((numberOfEvaluationsToStop = 5000, ))

    return 5000 == termination.parameters.numberOfEvaluationsToStop
end

function terminationByEvaluationsReturnsTrueIfTheStoppingConditionIsMet()
    termination = TerminationByEvaluations((numberOfEvaluationsToStop = 5000, ))

    algorithmAttributes = Dict()
    algorithmAttributes["EVALUATIONS"] = 5000 

    return termination.isMet(algorithmAttributes, termination.parameters)
end

function terminationByEvaluationsReturnsTrueIfTheStoppingConditionIsNotMet()
    termination = TerminationByEvaluations((numberOfEvaluationsToStop = 5001, ))

    algorithmAttributes = Dict()
    algorithmAttributes["EVALUATIONS"] = 5000 
    
    return !termination.isMet(algorithmAttributes, termination.parameters)
end

@testset "Termination tests" begin   
    @test terminationByEvaluationsIsCorrectlyInitialized() 
    @test terminationByEvaluationsReturnsTrueIfTheStoppingConditionIsMet() 
    @test terminationByEvaluationsReturnsTrueIfTheStoppingConditionIsNotMet() 
end

#######################################################
# Inertia weight computing strategy unit tests
#######################################################

function constantValueStrategyReturnTheValue()
    strategy = ConstantValueStrategy((inertiaWeight = 0.5,))
    return 0.5 == strategy.compute(strategy.parameters)
end

@testset "Constant value inertia weight computing strategy unit tests" begin  
    @test constantValueStrategyReturnTheValue()
end  
