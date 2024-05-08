
include("../src/utils.jl")

#########################################################################
# Test cases for normalize objectives
#########################################################################

function normalizeObjectivesOfASingleSolutionWorksProperly()
  solution = createContinuousSolution([1.0, 3.0, 6.0])
  normalizedSolution = normalizeObjectives([solution])[1]

  return [1.0, 1.0, 1.0] == normalizedSolution.objectives
end

function normalizeObjectivesOfTwoSolutionsWorksProperly()
  solution1 = createContinuousSolution([1.0, 3.0, 6.0])
  solution2 = createContinuousSolution([4.0, 1.0, 4.0])
  solutions = [solution1, solution2]
  normalizedSolutions = normalizeObjectives(solutions)

  return isapprox([0.2, 0.75, 0.6], normalizedSolutions[1].objectives; atol=eps(Float64)) && isapprox([0.8, 0.25, 0.4], normalizedSolutions[2].objectives; atol=eps(Float64))
end


function normalizeObjectivesOfThreeSolutionsWorksProperly()
  solution1 = createContinuousSolution([1.0, 3.0, 6.0])
  solution2 = createContinuousSolution([2.0, 2.0, 3.0])
  solution3 = createContinuousSolution([7.0, 5.0, 1.0])
  solutions = [solution1, solution2, solution3]
  normalizedSolutions = normalizeObjectives(solutions)

  return isapprox([0.1, 0.3, 0.6], normalizedSolutions[1].objectives; atol=eps(Float64)) && 
  return isapprox([0.2, 0.2, 0.3], normalizedSolutions[2].objectives; atol=eps(Float64)) &&
  isapprox([0.7, 0.5, 0.1], normalizedSolutions[3].objectives; atol=eps(Float64))

end

@testset "Normalize objectives tests" begin    
  @test normalizeObjectivesOfASingleSolutionWorksProperly()
  @test normalizeObjectivesOfTwoSolutionsWorksProperly()
  @test normalizeObjectivesOfThreeSolutionsWorksProperly()
end

#########################################################################
# Test cases for distance based subset selection
#########################################################################

function distanceBasedSubsetSelectionWithAListOfASolutionReturnsTheList()
  solution = createContinuousSolution([1.0, 3.0])
  solutions = [solution]

  numberOfSolutionsToSelect = 1

  foundSolutions = distanceBasedSubsetSelection(solutions, numberOfSolutionsToSelect)

  return solutions == foundSolutions
end

function distanceBasedSubsetSelectionOfMoreRequestedSolutionsThanThoseIncludedInTheListReturnsTheList()
  solutions = [createContinuousSolution([1.0, 3.0]), createContinuousSolution([3.0, 1.0]), createContinuousSolution([1.5, 1.5])]

  numberOfSolutionsToSelect = 5

  foundSolutions = distanceBasedSubsetSelection(solutions, numberOfSolutionsToSelect)

  return solutions == foundSolutions
end

function distanceBasedSubsetSelectionOfANumberOfRequestedSolutionsEqualsToTheListSizeReturnsTheList()
  solutions = [createContinuousSolution([1.0, 3.0]), createContinuousSolution([3.0, 1.0]), createContinuousSolution([1.5, 1.5])]

  numberOfSolutionsToSelect = length(solutions)

  foundSolutions = distanceBasedSubsetSelection(solutions, numberOfSolutionsToSelect)

  return solutions == foundSolutions
end

function distanceBasedSubsetSelectionOfTwoSolutionsFromAListOfThreeBiobjectiveSolutionsWorksProperly()
  solution1 = createContinuousSolution([1.0, 3.0])
  solution2 = createContinuousSolution([3.0, 1.0])
  solution3 = createContinuousSolution([1.5, 1.5])
  
  solutions = [solution1, solution2, solution3]

  numberOfSolutionsToSelect = 2

  foundSolutions = distanceBasedSubsetSelection(solutions, numberOfSolutionsToSelect)

  return length(foundSolutions) == 2 && solution1 in solutions && solution2 in solutions
end
  

"""
6 o
5    
4     x
3        x
2         o
1           x    
0 1 2 3 4 5 6
"""
function distanceBasedSubsetSelectionOfThreeSolutionsFromAListOfFiveBiobjectiveSolutionsWorksProperly()
  solution1 = createContinuousSolution([1.0, 6.0])
  solution2 = createContinuousSolution([3.0, 4.0])
  solution3 = createContinuousSolution([4.5, 3.0])
  solution4 = createContinuousSolution([5.0, 2.0])
  solution5 = createContinuousSolution([6.0, 1.0])
  
  solutions = [solution1, solution2, solution3, solution4, solution5]

  numberOfSolutionsToSelect = 3

  foundSolutions = distanceBasedSubsetSelection(solutions, numberOfSolutionsToSelect)

  return length(foundSolutions) == 3 && solution1 in solutions && solution5 in solutions && solution2 in solutions
end
  
function distanceBasedSubsetSelectionOfThreeSolutionsFromAListOfThreeThreeobjectiveSolutionsWorksProperly()
  solution1 = createContinuousSolution([1.0, 0.0, 0.0])
  solution2 = createContinuousSolution([0.0, 1.0, 0.0])
  solution3 = createContinuousSolution([0.0, 0.0, 1.0])

  solutions = [solution1, solution2, solution3]

  numberOfSolutionsToSelect = 3

  foundSolutions = distanceBasedSubsetSelection(solutions, numberOfSolutionsToSelect)

  return length(foundSolutions) == 3 
end

function distanceBasedSubsetSelectionOfThreeSolutionsFromAListOfFourThreeobjectiveSolutionsWorksProperly()
  solution1 = createContinuousSolution([1.0, 0.0, 0.0])
  solution2 = createContinuousSolution([0.0, 1.0, 0.0])
  solution3 = createContinuousSolution([0.0, 0.0, 1.0])
  solution4 = createContinuousSolution([0.5, 0.5, 0.5])

  solutions = [solution1, solution2, solution3, solution4]

  numberOfSolutionsToSelect = 3

  foundSolutions = distanceBasedSubsetSelection(solutions, numberOfSolutionsToSelect)

  return length(foundSolutions) == 3 && solution1 in solutions && solution2 in solutions && solution3 in solutions
end

function distanceBasedSubsetSelectionOfFourSolutionsFromAListOfSixThreeobjectiveSolutionsWorksProperly()
  solution1 = createContinuousSolution([1.0, 0.0, 0.0])
  solution2 = createContinuousSolution([0.0, 1.0, 0.0])
  solution3 = createContinuousSolution([0.0, 0.0, 1.0])
  solution4 = createContinuousSolution([0.0, 0.1, 0.0])
  solution5 = createContinuousSolution([0.4, 0.6, 0.4])
  solution6 = createContinuousSolution([0.9, 0.9, 0.1])

  solutions = [solution1, solution2, solution3, solution4, solution5, solution6]

  numberOfSolutionsToSelect = 3

  foundSolutions = distanceBasedSubsetSelection(solutions, numberOfSolutionsToSelect)

  return length(foundSolutions) == 3 && solution5 in solutions && solution1 in solutions && solution2 in solutions && solution3 in solutions
end

@testset "Distance based subset selection tests" begin    
  @test distanceBasedSubsetSelectionWithAListOfASolutionReturnsTheList()
  @test distanceBasedSubsetSelectionOfMoreRequestedSolutionsThanThoseIncludedInTheListReturnsTheList()
  @test distanceBasedSubsetSelectionOfANumberOfRequestedSolutionsEqualsToTheListSizeReturnsTheList()

  @test distanceBasedSubsetSelectionOfTwoSolutionsFromAListOfThreeBiobjectiveSolutionsWorksProperly()
  @test distanceBasedSubsetSelectionOfThreeSolutionsFromAListOfFiveBiobjectiveSolutionsWorksProperly()

  @test distanceBasedSubsetSelectionOfThreeSolutionsFromAListOfThreeThreeobjectiveSolutionsWorksProperly()
  @test distanceBasedSubsetSelectionOfThreeSolutionsFromAListOfFourThreeobjectiveSolutionsWorksProperly()
  @test distanceBasedSubsetSelectionOfFourSolutionsFromAListOfSixThreeobjectiveSolutionsWorksProperly()
end
