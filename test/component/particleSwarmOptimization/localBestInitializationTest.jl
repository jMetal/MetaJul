# Unit tests for DefaultLocalBestInitialization

function constructorOfLocalBestInitializationWorksProperly()
    swarmSize = 2
    swarm = [createContinuousSolution([1.0, 3.0]) for _ in 1:swarmSize]

    localBestInitialization = DefaultLocalBestInitialization(swarm)

    return swarm == localBestInitialization.swarm
end


function initializeDefaultLocalBestWithASwarmWithASolutionWorksProperly()
    swarmSize = 1
    swarm = [createContinuousSolution([1.0, 3.0]) for _ in 1:swarmSize]

    localBestInitialization = DefaultLocalBestInitialization(swarm) 

    localBest = initialize(localBestInitialization)
    
    return 1 == length(localBest) && isequal(swarm[1], localBest[1]) 
end

function initializeDefaultLocalBestWithASwarmWithThreeSolutionsWorksProperly()
    swarm = [createContinuousSolution([1.0, 3.0]),  createContinuousSolution([2.0, 5.0]), createContinuousSolution([3.0, 1.0])]

    localBestInitialization = DefaultLocalBestInitialization(swarm) 

    localBest = initialize(localBestInitialization)
    
    return 3 == length(localBest) && isequal(swarm[1], localBest[1]) && isequal(swarm[2], localBest[2]) && isequal(swarm[3], localBest[3])
end


@testset "Default local best initialization tests" begin    
    @test constructorOfLocalBestInitializationWorksProperly()    
    @test initializeDefaultLocalBestWithASwarmWithASolutionWorksProperly()
    @test initializeDefaultLocalBestWithASwarmWithThreeSolutionsWorksProperly()
end