# Unit tests for default global test update


function defaultGlobalBestUpdateWorksProperlyWhenTheSwarmHasASolution()
    swarmSize = 1
    swarm = [createContinuousSolution([1.0, 3.0]) for _ in 1:swarmSize]

    globalBest = CrowdingDistanceArchive(20, ContinuousSolution)
    globalBestUpdate = DefaultGlobalBestUpdate() 

    update(globalBestUpdate, swarm, globalBest)

    return 1 == length(getSolutions(globalBest))
end

function defaultGlobalBestUpdateWorksProperlyWhenTheSwarmHasTwoNonDominatedSolutions()
    swarm = [createContinuousSolution([1.0, 3.0]), createContinuousSolution([3.0, 1.0])]

    globalBest = CrowdingDistanceArchive(20, ContinuousSolution)
    globalBestUpdate = DefaultGlobalBestUpdate() 

    update(globalBestUpdate, swarm, globalBest)

    return 2 == length(getSolutions(globalBest))
end

@testset "Global best update tests" begin    
    @test defaultGlobalBestUpdateWorksProperlyWhenTheSwarmHasASolution()
    @test defaultGlobalBestUpdateWorksProperlyWhenTheSwarmHasTwoNonDominatedSolutions()
end