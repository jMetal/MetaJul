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
    vector = [1,2,3,4]

    selectedItems = select(vector, selection)

    return length(selectedItems) == matingPoolSize
end

function randomSelectionWithoutReplacementReturnsTheNumberOfRequestedElements() 
    matingPoolSize = 4
    selection = RandomSelection(matingPoolSize, false)
    vector = [1,2,3,4,5,7,8]

    selectedItems = select(vector, selection)

    return length(selectedItems) == matingPoolSize
end

function randomSelectionWithoutReplacementDoesNotReturnRepeatedItems() 
    matingPoolSize = 8
    selection = RandomSelection(matingPoolSize, false)
    vector = [1,2,3,4,5,6,7,8]

    selectedItems = select(vector, selection)

    return vector == sort(selectedItems)
end

@testset "Random selection tests" begin    
    @test randomSelectionWithReplacementIsCorrectlyInitialiazed()
    @test randomSelectionWithoutReplacementIsCorrectlyInitialiazed()
    @test randomSelectionWithReplacementReturnsTheNumberOfRequestedElements()
    @test randomSelectionWithoutReplacementReturnsTheNumberOfRequestedElements()
    @test randomSelectionWithoutReplacementDoesNotReturnRepeatedItems()
end

# TODO
@testset "Binary tournament selection tests" begin    

end