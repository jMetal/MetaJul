function randomSelectionWithReplacementIsCorrectlyInitialiazed()
    selection = RandomSelection(100, true)

    return selection.matingPoolSize == 100 && selection.withReplacement
end

function randomSelectionWithoutReplacementIsCorrectlyInitialiazed()
    selection = RandomSelection(100, false)

    return selection.matingPoolSize == 100 && !selection.withReplacement
end

function randomSelectionWithReplacementReturnsTheNumberOfRequestedElements()
    matingPoolSize = 2
    selection = RandomSelection(matingPoolSize, true)
    vector = [1, 2, 3, 4]

    selectedItems = select(selection, vector)

    return length(selectedItems) == matingPoolSize
end

function randomSelectionWithoutReplacementReturnsTheNumberOfRequestedElements()
    matingPoolSize = 4
    selection = RandomSelection(matingPoolSize, false)
    vector = [1, 2, 3, 4, 5, 7, 8]

    selectedItems = select(selection, vector)

    return length(selectedItems) == matingPoolSize
end

function randomSelectionWithoutReplacementDoesNotReturnRepeatedItems()
    matingPoolSize = 8
    selection = RandomSelection(matingPoolSize, false)
    vector = [1, 2, 3, 4, 5, 6, 7, 8]

    selectedItems = select(selection, vector)

    return vector == sort(selectedItems)
end

function randomSelectionWithReplacementReturnAListOfOneSolutionIfTheSolutionListSizeIsOne()
    solutions = [createContinuousSolution(3)]

    matingPoolSize = 5
    withReplacement = true
    selection = RandomSelection(matingPoolSize, withReplacement)

    return [solutions[1] for i in 1:5] == select(selection, solutions)
end

function randomSelectionWithReplacementReturnAListWithTheMatingPoolSize()
    solutionListSize = 10
    solutions = [createContinuousSolution(3) for _ in 1:solutionListSize]

    matingPoolSize = 5
    withReplacement = true
    selection = RandomSelection(matingPoolSize, withReplacement)

    selectedSolutions = select(selection, solutions)

    return length(selectedSolutions) == 5
end

function randomSelectionWithoutReplacementRaisesAnExceptionIfTheMatingPoolSizeIsHigherThanTheSolutionListSize()
    solutionListSize = 10
    solutions = [createContinuousSolution(3) for _ in 1:solutionListSize]

    matingPoolSize = 11
    withReplacement = false
    selection = RandomSelection(matingPoolSize, withReplacement)

    select(selection, solutions)
end

function randomSelectionWithoutReplacementReturnsAPermutation()
    solutionListSize = 10
    solutions = [createContinuousSolution(3) for _ in 1:solutionListSize]

    matingPoolSize = 10
    withReplacement = false
    selection = RandomSelection(matingPoolSize, withReplacement)
    selectedSolutions = select(selection, solutions)

    return all(i -> solutions[i] in selectedSolutions, [_ for _ in range(1, solutionListSize)])
end

@testset "Random selection tests" begin
    @test randomSelectionWithReplacementIsCorrectlyInitialiazed()
    @test randomSelectionWithoutReplacementIsCorrectlyInitialiazed()
    @test randomSelectionWithReplacementReturnsTheNumberOfRequestedElements()
    @test randomSelectionWithoutReplacementReturnsTheNumberOfRequestedElements()
    @test randomSelectionWithoutReplacementDoesNotReturnRepeatedItems()
    @test randomSelectionWithReplacementReturnAListOfOneSolutionIfTheSolutionListSizeIsOne()
    @test randomSelectionWithReplacementReturnAListWithTheMatingPoolSize()

    @test_throws "The mating pool size 11 is higher than the population size 10" randomSelectionWithoutReplacementRaisesAnExceptionIfTheMatingPoolSizeIsHigherThanTheSolutionListSize()
    @test randomSelectionWithoutReplacementReturnsAPermutation()
end

#######################################################
# Selection unit tests
#######################################################

function binaryTournamentSelectionIsCorrectlyInitialized()
    matingPoolSize = 100
    comparator = IthObjectiveComparator(1)

    selection = BinaryTournamentSelection(matingPoolSize, comparator)

    return 100 == selection.matingPoolSize && comparator == selection.comparator
end

"""
Case A: population size = 2; mating poolSize = 1
"""
function binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseA()
    solution1 = createContinuousSolution([1.0])
    solution2 = createContinuousSolution([2.0])
    solutions = [solution1, solution2]

    matingPoolSize = 1
    comparator = IthObjectiveComparator(1)
    selection = BinaryTournamentSelection(matingPoolSize, comparator)

    matingPool = select(selection, solutions)
    return (length(matingPool) == 1)
end

"""
Case B: population size = 2; mating poolSize = 2
"""
function binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseB()
    solution1 = createContinuousSolution([1.0])
    solution2 = createContinuousSolution([2.0])
    solutions = [solution1, solution2]

    matingPoolSize = 2
    comparator = IthObjectiveComparator(1)
    selection = BinaryTournamentSelection(matingPoolSize, comparator)

    matingPool = select(selection, solutions)
    return (length(matingPool) == 2)
end

"""
Case C: population size = 2; mating poolSize = 4
"""
function binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseC()
    solution1 = createContinuousSolution([1.0])
    solution2 = createContinuousSolution([2.0])
    solutions = [solution1, solution2]

    matingPoolSize = 4
    comparator = IthObjectiveComparator(1)
    selection = BinaryTournamentSelection(matingPoolSize, comparator)

    matingPool = select(selection, solutions)
    return (length(matingPool) == 4)
end


@testset "Binary Tournament Selection tests" begin
    @test binaryTournamentSelectionIsCorrectlyInitialized()
    @test binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseA()
    @test binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseB()
    @test binaryTournamentSelectionReturnASolutionListWithTheCorrectMatingPoolSizeCaseC()
end

# Helper function to create a mock solution list
function createMockSolutionList(n::Int)
    return [createContinuousSolution(2) for i in 1:n]
end

# Unit tests

function populationAndNeighborhoodSelectionIsCorrectlyInitialized()
    numberOfWeightVectors = 100
    neighborhoodSize = 20
    neighborhood = WeightVectorNeighborhood(numberOfWeightVectors, neighborhoodSize)
    selection = PopulationAndNeighborhoodSelection(3, IntegerBoundedSequenceGenerator(1), neighborhood, 0.5, true)

    return selection.matingPoolSize == 3 &&
           selection.neighborhood === neighborhood &&
           selection.neighborhoodSelectionProbability == 0.5 &&
           selection.selectCurrentSolution == true
end

function whenNeighborhoodSelectionProbabilityIsOneSelectFromNeighborhood()
    numberOfWeightVectors = 100
    neighborhoodSize = 20
    neighborhood = WeightVectorNeighborhood(numberOfWeightVectors, neighborhoodSize)
    selection = PopulationAndNeighborhoodSelection(2, IntegerBoundedSequenceGenerator(1), neighborhood, 1.0, false)

    solutionList = createMockSolutionList(100)
    matingPool = select(selection, solutionList)

    neighborsList = getNeighbors(neighborhood, solutionList, 100)
    neighborsPool = select(neighborsList, selection.selectionOperator)

    return isequal(matingPool, neighborsPool)
end

function whenNeighborhoodSelectionProbabilityIsZeroSelectFromPopulation()
    numberOfWeightVectors = 100
    neighborhoodSize = 20
    neighborhood = WeightVectorNeighborhood(numberOfWeightVectors, neighborhoodSize)
    selection = PopulationAndNeighborhoodSelection(2, IntegerBoundedSequenceGenerator(1), neighborhood, 0.0, false)

    solutionList = createMockSolutionList(100)
    matingPool = select(selection, solutionList)

    neighborsPool = select(solutionList, selection.selectionOperator)

    return isequal(matingPool, neighborsPool)
end

function currentSolutionIsAddedToMatingPoolWhenFlagIsSet()
    numberOfWeightVectors = 100
    neighborhoodSize = 20
    neighborhood = WeightVectorNeighborhood(numberOfWeightVectors, neighborhoodSize)
    selection = PopulationAndNeighborhoodSelection(3, IntegerBoundedSequenceGenerator(1), neighborhood, 1.0, true)

    solutionList = createMockSolutionList(100)
    matingPool = select(selection, solutionList)

    currentSolution = solutionList[1]
    return currentSolution in matingPool
end

@testset "Population and Neighborhood Selection tests" begin
    @test populationAndNeighborhoodSelectionIsCorrectlyInitialized()
    @test whenNeighborhoodSelectionProbabilityIsOneSelectFromNeighborhood()
    @test whenNeighborhoodSelectionProbabilityIsZeroSelectFromPopulation()
    @test currentSolutionIsAddedToMatingPoolWhenFlagIsSet()
end