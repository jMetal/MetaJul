# Unit tests for DefaultGlobalBestInitialization

function inializeDefaultGlobalBestWithASolutionInitializationReturnTheRightResult()
    swarmSize = 1
    swarm = [createContinuousSolution([1.0, 3.0]) for _ in 1:swarmSize]

    globalBest = CrowdingDistanceArchive(20, ContinuousSolution)
    globalBestInitialization = DefaultGlobalBestInitialization() 

    initialize(globalBestInitialization, swarm, globalBest)
    
    return 1 == length(globalBest) 
end


@testset "Default global best initialization tests" begin    
    @test inializeDefaultGlobalBestWithASolutionInitializationReturnTheRightResult()
end