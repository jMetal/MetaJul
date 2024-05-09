# Unit tests for the CrossoverAndMutationVariation component

function crossoverAndMutationVariationIsCorrectlyInitialized()
    offspringPopulationSize = 100
    solutionBounds = [Bounds{Float64}(1.0, 10.0), Bounds{Float64}(1.0, 10.0)]

    mutation = PolynomialMutation(0.01, 20.0, solutionBounds)
    crossover = SBXCrossover(0.9, 30.0, solutionBounds)

    variation = CrossoverAndMutationVariation(offspringPopulationSize, crossover, mutation)

    matingPoolSize = 100

    return offspringPopulationSize == variation.offspringPopulationSize &&
    mutation == variation.mutation &&
    crossover == variation.crossover &&
    matingPoolSize == variation.matingPoolSize
end

function theMatingPoolSizeWhenTheOffspringPopulationSizeIsOneMustBeTwo()
    offspringPopulationSize = 1
    solutionBounds = [Bounds{Float64}(1.0, 10.0), Bounds{Float64}(1.0, 10.0)]

    mutation = PolynomialMutation(0.01, 20.0, solutionBounds)
    crossover = SBXCrossover(0.9, 30.0, solutionBounds)

    variation = CrossoverAndMutationVariation(offspringPopulationSize, crossover, mutation)

    matingPoolSize = 2

    return matingPoolSize == variation.matingPoolSize
end

# Case A: the offspringPopulation size is 100
function crossoverAndMutationVariationReturnTheCorrectNumberOfSolutionsCaseA()
    offspringPopulationSize = 100

    matingPool = [createContinuousSolution(2) for _ in 1:100]
    solutionBounds = matingPool[1].bounds

    mutation = PolynomialMutation(0.01, 20.0, solutionBounds)
    crossover = SBXCrossover(0.9, 30.0, solutionBounds)

    variation = CrossoverAndMutationVariation(offspringPopulationSize, crossover, mutation)

    offspringPopulation = variate(matingPool, matingPool, variation)

    return length(offspringPopulation) == 100
end

# Case A: the offspringPopulation size is 1 
function crossoverAndMutationVariationReturnTheCorrectNumberOfSolutionsCaseB()
    offspringPopulationSize = 1

    matingPool = [createContinuousSolution(2) for _ in 1:100]
    solutionBounds = matingPool[1].bounds

    mutation = PolynomialMutation(0.01, 20.0, solutionBounds)
    crossover = SBXCrossover(0.9, 30.0, solutionBounds)

    variation = CrossoverAndMutationVariation(offspringPopulationSize, crossover, mutation)

    offspringPopulation = variate(matingPool, matingPool, variation)

    return length(offspringPopulation) == 1
end


@testset "Crossover and mutation variation tests" begin    
    @test crossoverAndMutationVariationIsCorrectlyInitialized()
    @test theMatingPoolSizeWhenTheOffspringPopulationSizeIsOneMustBeTwo()
    @test crossoverAndMutationVariationReturnTheCorrectNumberOfSolutionsCaseA()
    @test crossoverAndMutationVariationReturnTheCorrectNumberOfSolutionsCaseB()
end

