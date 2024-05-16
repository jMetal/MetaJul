# Unit tests for BinaryTournamentGlobalBestSelection

function constructorOfBinaryTournamentGlobalBestSelectionWorksProperly()
    dominanceComparator = DefaultDominanceComparator()

    globalBestSelection = BinaryTournamentGlobalBestSelection(dominanceComparator)

    return dominanceComparator == globalBestSelection.dominanceComparator
end


function binaryTournamentGlobalBestSelectionWorksProperlyWhenTheSwarmHasASolution()
    swarmSize = 1
    swarm = [createContinuousSolution([1.0, 3.0]) for _ in 1:swarmSize]

    globalBestSelection = BinaryTournamentGlobalBestSelection(DefaultDominanceComparator())

    solution = select(globalBestSelection, swarm)

    return isequal(swarm[1], solution)
end

@testset "Binary tournament global best selection tests" begin    
    @test constructorOfBinaryTournamentGlobalBestSelectionWorksProperly()    
    @test binaryTournamentGlobalBestSelectionWorksProperlyWhenTheSwarmHasASolution()
end