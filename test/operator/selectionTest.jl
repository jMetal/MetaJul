
#########################################################################
# Test cases for mutation operators
#########################################################################

function selectionOperatorIsCorrectlyInitializedWithDefaultValues()
  op = NaryRandomSelectionOperator()
  return op.numberOfSolutionsToBeReturned == 1
end

function selectionOperatorIsCorrectlyInitialized()
  op = NaryRandomSelectionOperator(3)
  return op.numberOfSolutionsToBeReturned == 3
end

function selectingFewerElementsThanAvailableReturnsCorrectSize()
  x = [1, 2, 3, 4, 5]
  op = NaryRandomSelectionOperator(3)
  selected = select(x, op)
  return length(selected) == 3 && all(sel -> sel in x, selected)
end

function selectingAllElementsReturnsAllElements()
  x = [1, 2, 3, 4, 5]
  op = NaryRandomSelectionOperator(5)
  selected = select(x, op)
  return length(selected) == 5 && all(sel -> sel in x, selected)
end

function selectingZeroElementsReturnsEmptyList()
  x = [1, 2, 3, 4, 5]
  op = NaryRandomSelectionOperator(0)
  selected = select(x, op)
  return length(selected) == 0
end

function selectingMoreElementsThanAvailableThrowsAssertionError()
  x = [1, 2, 3]
  op = NaryRandomSelectionOperator(5)
  return select(x, op)
end

function selectingFromEmptyListWithZeroReturn()
  x = []
  op = NaryRandomSelectionOperator(0)
  selected = select(x, op)
  return isempty(selected)
end

# Test set block
@testset "Nary Random Selection Operator Tests" begin
  @test selectionOperatorIsCorrectlyInitializedWithDefaultValues()
  @test selectionOperatorIsCorrectlyInitialized()
  @test selectingFewerElementsThanAvailableReturnsCorrectSize()
  @test selectingAllElementsReturnsAllElements()
  @test selectingZeroElementsReturnsEmptyList()
  @test_throws "AssertionError" selectingMoreElementsThanAvailableThrowsAssertionError()
  @test selectingFromEmptyListWithZeroReturn()
end