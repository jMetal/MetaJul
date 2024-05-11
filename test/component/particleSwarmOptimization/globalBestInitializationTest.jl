# Unit tests for DefaultGlobalBestInitialization

function constructorOfDefaultGlobalBestInitializationWorksProperly()
    swarmSize = 10
    swarm = [createContinuousSolution([1.0, 3.0]) for _ in 1:swarmSize]

    globalBest = CrowdingDistanceArchive(20, ContinuousSolution)
    globalBestInitialization = DefaultGlobalBestInitialization(swarm, globalBest) 

    return swarm == globalBestInitialization.swarm && globalBest == globalBestInitialization.globalBest
end

function inializeDefaultGlobalBestWithASolutionInitializationReturnTheRightResult()
    swarmSize = 1
    swarm = [createContinuousSolution([1.0, 3.0]) for _ in 1:swarmSize]

    globalBest = CrowdingDistanceArchive(20, ContinuousSolution)
    globalBestInitialization = DefaultGlobalBestInitialization(swarm, globalBest) 

    initialize(globalBestInitialization)
    
    return 1 == length(globalBestInitialization.globalBest) 
end


@testset "Default velocity initialization tests" begin    
    @test constructorOfDefaultGlobalBestInitializationWorksProperly()    
    @test inializeDefaultGlobalBestWithASolutionInitializationReturnTheRightResult()
end