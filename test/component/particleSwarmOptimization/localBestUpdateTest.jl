# Unit tests for DefaultLocalBestUpdate

function constructorWorksProperly()
    dominanceComparator = DefaultDominanceComparator()
    localBestUpdate = DefaultLocalBestUpdate(dominanceComparator)

    return dominanceComparator == localBestUpdate.dominanceComparator
end

"""
Case A: the swarm has a particle which is dominated by its local best, so the local best remains unchanged
"""
function udpateWorksProperlyCaseA()
    swarm = [createContinuousSolution([6.0, 7.0])]
    localBest = [createContinuousSolution([2.0, 5.0])]

    dominanceComparator = DefaultDominanceComparator()
    localBestUpdate = DefaultLocalBestUpdate(dominanceComparator)

    update(localBestUpdate, swarm, localBest)

    return [2.0, 5.0] == localBest[1].objectives
end

"""
Case B: the swarm has a particle which dominates its local best, so the local best is updated
"""
function udpateWorksProperlyCaseB()
    swarm = [createContinuousSolution([2.0, 3.0])]
    localBest = [createContinuousSolution([5.0, 6.0])]

    dominanceComparator = DefaultDominanceComparator()
    localBestUpdate = DefaultLocalBestUpdate(dominanceComparator)

    update(localBestUpdate, swarm, localBest)

    return [2.0, 3.0] == localBest[1].objectives
end

"""
Case C: the swarm has a particle which is non-dominated with its local best, so the local best is updated
"""
function udpateWorksProperlyCaseC()
    swarm = [createContinuousSolution([7.0, 3.0])]
    localBest = [createContinuousSolution([5.0, 6.0])]

    dominanceComparator = DefaultDominanceComparator()
    localBestUpdate = DefaultLocalBestUpdate(dominanceComparator)

    update(localBestUpdate, swarm, localBest)

    return [7.0, 3.0] == localBest[1].objectives
end

@testset "Default local best initialization tests" begin    
    @test constructorWorksProperly()
    @test udpateWorksProperlyCaseA()
    @test udpateWorksProperlyCaseC()
end