# Unit tests for default global test update

function constructorOfDefaultGlobalBestUpdateWorksProperly()
    swarmSize = 10
    swarm = [createContinuousSolution([1.0, 3.0]) for _ in 1:swarmSize]

    globalBest = CrowdingDistanceArchive(20, ContinuousSolution)
    globalBestUpdate = DefaultGlobalBestUpdate(swarm, globalBest) 

    return swarm == globalBestUpdate.swarm && globalBest == globalBestUpdate.globalBest
end

function defaultGlobalBestUpdateWorksProperlyWhenTheSwarmHasASolution()
    swarmSize = 1
    swarm = [createContinuousSolution([1.0, 3.0]) for _ in 1:swarmSize]

    globalBest = CrowdingDistanceArchive(20, ContinuousSolution)
    globalBestUpdate = DefaultGlobalBestUpdate(swarm, globalBest) 

    update(globalBestUpdate)

    return 1 == length(getSolutions(globalBest))
end

function defaultGlobalBestUpdateWorksProperlyWhenTheSwarmHasTwoNonDominatedSolutions()
    swarm = [createContinuousSolution([1.0, 3.0]), createContinuousSolution([3.0, 1.0])]

    globalBest = CrowdingDistanceArchive(20, ContinuousSolution)
    globalBestUpdate = DefaultGlobalBestUpdate(swarm, globalBest) 

    update(globalBestUpdate)

    return 2 == length(getSolutions(globalBest))
end

@testset "Global best update tests" begin    
    @test constructorOfDefaultGlobalBestUpdateWorksProperly()    
    @test defaultGlobalBestUpdateWorksProperlyWhenTheSwarmHasASolution()
    @test defaultGlobalBestUpdateWorksProperlyWhenTheSwarmHasTwoNonDominatedSolutions()
end