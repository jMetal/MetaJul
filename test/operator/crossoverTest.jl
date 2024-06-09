#########################################################################
# Test cases for crossover operators
#########################################################################

function singlePointCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  parent1 = BinarySolution(initBitVector("101000"), [], [], Dict())
  parent2 = BinarySolution(initBitVector("010011"), [], [], Dict())

  crossover = SinglePointCrossover(0.0)
  children = recombine(parent1, parent2, crossover)

  return isequal(parent1, children[1]) && isequal(parent2, children[2])
end

function singlePointCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  parent1 = BinarySolution(initBitVector("101000"), [], [], Dict())
  parent2 = BinarySolution(initBitVector("010011"), [], [], Dict())

  crossover = SinglePointCrossover(1.0)
  children = recombine(parent1, parent2, crossover)

  return !isequal(parent1, children[1]) && !isequal(parent2, children[2])
end

@testset "Single point crossover tests" begin
  @test SinglePointCrossover(0.1).probability == 0.1
  @test numberOfRequiredParents(SinglePointCrossover(0.1)) == 2
  @test numberOfDescendants(SinglePointCrossover(0.1)) == 2
   
  @test singlePointCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  @test singlePointCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
end

function sbxCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = SBXCrossover(0.0, 20.0, parent1.bounds)
  children = recombine(parent1, parent2, crossover)

  return isequal(parent1, children[1]) && isequal(parent2, children[2])
end

function sbxCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = SBXCrossover(1.0, 20.0, parent1.bounds)
  children = recombine(parent1, parent2, crossover)

  return !isequal(parent1, children[1]) && !isequal(parent2, children[2])
end

sbxCrossover = SBXCrossover(0.054, 20.0, [Bounds{Float64}(3.0, 5.0)])
@testset "SBX crossover tests" begin
  @test sbxCrossover.probability == 0.054
  @test sbxCrossover.distributionIndex == 20.0
  @test numberOfDescendants(sbxCrossover) == 2
  @test numberOfRequiredParents(sbxCrossover) == 2

  @test sbxCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  @test sbxCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
end


function blxAlphaCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = BLXAlphaCrossover(0.0, 0.5, parent1.bounds)
  children = recombine(parent1, parent2, crossover)

  return isequal(parent1, children[1]) && isequal(parent2, children[2])
end

function blxAlphaCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = BLXAlphaCrossover(1.0, 0.5, parent1.bounds)
  children = recombine(parent1, parent2, crossover)

  return !isequal(parent1, children[1]) && !isequal(parent2, children[2])
end

blxAlphaCrossover = BLXAlphaCrossover(0.12, 0.5, [])
@testset "BLX-alpha crossover tests" begin
  @test blxAlphaCrossover.probability == 0.12
  @test blxAlphaCrossover.alpha == 0.5
  @test numberOfDescendants(blxAlphaCrossover) == 2
  @test numberOfRequiredParents(blxAlphaCrossover) == 2

  @test blxAlphaCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  @test blxAlphaCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
end
