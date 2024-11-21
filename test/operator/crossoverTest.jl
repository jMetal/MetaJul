#########################################################################
# Test cases for crossover operators
#########################################################################

function singlePointCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  parent1 = BinarySolution(initBitVector("101000"), [], [], Dict())
  parent2 = BinarySolution(initBitVector("010011"), [], [], Dict())

  crossover = SinglePointCrossover(probability = 0.0)
  children = recombine(parent1, parent2, crossover)

  return isequal(parent1, children[1]) && isequal(parent2, children[2])
end

function singlePointCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  parent1 = BinarySolution(initBitVector("101000"), [], [], Dict())
  parent2 = BinarySolution(initBitVector("010011"), [], [], Dict())

  crossover = SinglePointCrossover(probability = 1.0)
  children = recombine(parent1, parent2, crossover)

  return !isequal(parent1, children[1]) && !isequal(parent2, children[2])
end

@testset "Single point crossover tests" begin
  @test SinglePointCrossover(probability = 0.1).probability == 0.1
  @test numberOfRequiredParents(SinglePointCrossover(probability = 0.1)) == 2
  @test numberOfDescendants(SinglePointCrossover(probability = 0.1)) == 2
   
  @test singlePointCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  @test singlePointCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
end

function sbxCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = SBXCrossover(probability = 0.0, distributionIndex = 20.0, bounds = parent1.bounds)
  children = recombine(parent1, parent2, crossover)

  return isequal(parent1, children[1]) && isequal(parent2, children[2])
end

function sbxCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = SBXCrossover(probability = 1.0, distributionIndex = 20.0, bounds = parent1.bounds)
  children = recombine(parent1, parent2, crossover)

  return !isequal(parent1, children[1]) && !isequal(parent2, children[2])
end

function SBXCrossoverWithAEmptyListOfBoundsRaiseAnException() 
  return SBXCrossover(probability = 1.0, distributionIndex = 20.0, bounds = [])
end

sbxCrossover = SBXCrossover(probability = 0.054, distributionIndex = 20.0, bounds = [Bounds{Float64}(3.0, 5.0)])
@testset "SBX crossover tests" begin
  @test sbxCrossover.probability == 0.054
  @test sbxCrossover.distributionIndex == 20.0
  @test numberOfDescendants(sbxCrossover) == 2
  @test numberOfRequiredParents(sbxCrossover) == 2

  @test sbxCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  @test sbxCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  @test_throws "The bounds list is empty" SBXCrossoverWithAEmptyListOfBoundsRaiseAnException()
end


function blxAlphaCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = BLXAlphaCrossover(probability = 0.0, alpha = 0.5, bounds = parent1.bounds)
  children = recombine(parent1, parent2, crossover)

  return isequal(parent1, children[1]) && isequal(parent2, children[2])
end

function blxAlphaCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = BLXAlphaCrossover(probability = 1.0, alpha= 0.5, bounds = parent1.bounds)
  children = recombine(parent1, parent2, crossover)

  return !isequal(parent1, children[1]) && !isequal(parent2, children[2])
end

function blxAlphaCrossoverWithAEmptyListOfBoundsRaiseAnException() 
  BLXAlphaCrossover(probability = 1.0, alpha= 0.5, bounds = [])
end

blxAlphaCrossover = BLXAlphaCrossover(probability = 0.12, alpha = 0.5, bounds = [Bounds{Float64}(1.0, 10.0)])
@testset "BLX-alpha crossover tests" begin
  @test blxAlphaCrossover.probability == 0.12
  @test blxAlphaCrossover.alpha == 0.5
  @test numberOfDescendants(blxAlphaCrossover) == 2
  @test numberOfRequiredParents(blxAlphaCrossover) == 2
  @test_throws "The bounds list is empty" blxAlphaCrossoverWithAEmptyListOfBoundsRaiseAnException()

  @test blxAlphaCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  @test blxAlphaCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
end


function pmxCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  parent1 = PermutationSolution(5)
  parent1.variables = [1, 5, 2, 3, 4]

  parent2 = PermutationSolution(5)
  parent2.variables = [5, 4, 3, 2, 1]

  crossover = PMXCrossover(probability = 0.0)
  children = recombine(parent1, parent2, crossover)

  return isequal(parent1, children[1]) && isequal(parent2, children[2])
end

function pmxCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  parent1 = PermutationSolution(10)
  parent2 = PermutationSolution(10)

  crossover = PMXCrossover(probability = 1.0)
  children = recombine(parent1, parent2, crossover)

  return !isequal(parent1, children[1]) && !isequal(parent2, children[2])
end

function pmxCrossoverProduceCorrectPermutations()
  parent1 = PermutationSolution(20)
  parent2 = PermutationSolution(20)

  crossover = PMXCrossover(probability = 1.0)
  children = recombine(parent1, parent2, crossover)

  return checkIfPermutationIsValid(children[1].variables) && checkIfPermutationIsValid(children[2].variables)
end


pmxCrossover = PMXCrossover(probability = 0.9)
@testset "PMX crossover tests" begin
  @test pmxCrossover.probability == 0.9
  @test numberOfDescendants(pmxCrossover) == 2
  @test numberOfRequiredParents(pmxCrossover) == 2

  @test pmxCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  @test pmxCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  @test pmxCrossoverProduceCorrectPermutations()
end
