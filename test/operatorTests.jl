
include("../src/operator.jl")

#########################################################################
# Test cases for mutation operators
#########################################################################

function mutateABinarySolutionWithProbabilityZeroReturnASolutionWithTheSameVariables()
  solution = BinarySolution(initBitVector("1010"), [1.0, 2.0, 3.0], [-1], Dict())
  mutation = BitFlipMutation((probability=0.0,))
  newSolution = mutation.execute(copySolution(solution), mutation.parameters)

  return isequal(solution, newSolution)
end

function mutateABinarySolutionWithProbabilityOneFlipsAllTheBits()
  solution = BinarySolution(initBitVector("10100"), [1.0, 2.0, 3.0], [-1], Dict())
  mutation = BitFlipMutation((probability=1.0,))
  newSolution = mutation.execute(copySolution(solution), mutation.parameters)
  expectedSolution = BinarySolution(initBitVector("01011"), [1.0, 2.0, 3.0], [-1], Dict())

  return isequal(expectedSolution, newSolution)
end

@testset "BitFlip mutation tests" begin
  @test getMutationProbability(BitFlipMutation((probability=0.01,))) == 0.01
  @test mutateABinarySolutionWithProbabilityZeroReturnASolutionWithTheSameVariables()
  @test mutateABinarySolutionWithProbabilityOneFlipsAllTheBits()
end

function mutateAContinuousSolutionWithUniformMutationWithProbabilityZeroReturnASolutionWithTheSameVariables()
  solution = createContinuousSolution(3)
  solution.variables = [1.2, 5.2]

  mutation = UniformMutation((probability=0.0, perturbation=0.5, bounds=solution.bounds))
  newSolution = mutation.execute(copySolution(solution), mutation.parameters)

  return isequal(solution, newSolution)
end

function mutateAContinuousSolutionWithUniformMutationWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolution()
  solution = createContinuousSolution(3)
  solution.variables = [1.2, 5.2]

  mutation = UniformMutation((probability=1.0, perturbation=0.5, bounds=solution.bounds))
  newSolution = mutation.execute(copySolution(solution), mutation.parameters)

  return !isequal(solution.variables[1], newSolution.variables[1]) && !isequal(solution.variables[2], newSolution.variables[2])
end


@testset "Uniform mutation tests" begin
  @test getMutationProbability(UniformMutation((probability=0.054, perturbation=0.5, bounds=[]))) == 0.054
  @test getPerturbation(UniformMutation((probability=0.054, perturbation=0.5, bounds=[]))) == 0.5
  @test mutateAContinuousSolutionWithUniformMutationWithProbabilityZeroReturnASolutionWithTheSameVariables()
  @test mutateAContinuousSolutionWithUniformMutationWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolution()
end


function mutateAContinuousSolutionWithPolynomialMutationWithProbabilityZeroReturnASolutionWithTheSameVariables()
  solution = createContinuousSolution(3)
  solution.variables = [1.2, 5.2]

  mutation = PolynomialMutation((probability=0.0, distributionIndex=0.5, bounds=solution.bounds))
  newSolution = mutation.execute(copySolution(solution), mutation.parameters)

  return isequal(solution, newSolution)
end

function mutateAContinuousSolutionWithPolynomialMutationWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolution()
  solution = createContinuousSolution(3)
  solution.variables = [1.2, 5.2]

  mutation = PolynomialMutation((probability=1.0, distributionIndex=0.5, bounds=solution.bounds))
  newSolution = mutation.execute(copySolution(solution), mutation.parameters)

  return !isequal(solution.variables[1], newSolution.variables[1]) && !isequal(solution.variables[2], newSolution.variables[2])
end

@testset "Polynomial mutation tests" begin
  @test getMutationProbability(PolynomialMutation((probability=0.054, distributionIndex=20.0, bounds=[]))) == 0.054
  @test getDistributionIndex(PolynomialMutation((probability=0.054, distributionIndex=10.0, bounds=[]))) == 10.0
  @test mutateAContinuousSolutionWithPolynomialMutationWithProbabilityZeroReturnASolutionWithTheSameVariables()
  @test mutateAContinuousSolutionWithPolynomialMutationWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolution()
end


#########################################################################
# Test cases for crossover operators
#########################################################################

function singlePointCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  parent1 = BinarySolution(initBitVector("101000"), [], [], Dict())
  parent2 = BinarySolution(initBitVector("010011"), [], [], Dict())

  crossover = SinglePointCrossover((probability=0.0,))
  children = crossover.execute(parent1, parent2, crossover.parameters)

  return isequal(parent1, children[1]) && isequal(parent2, children[2])
end

function singlePointCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  parent1 = BinarySolution(initBitVector("101000"), [], [], Dict())
  parent2 = BinarySolution(initBitVector("010011"), [], [], Dict())

  crossover = SinglePointCrossover((probability=1.0,))
  children = crossover.execute(parent1, parent2, crossover.parameters)

  return !isequal(parent1, children[1]) && !isequal(parent2, children[2])
end

@testset "Single point crossover tests" begin
  @test getCrossoverProbability(SinglePointCrossover((probability=0.1,))) == 0.1
  @test SinglePointCrossover((probability=0.1,)).numberOfRequiredParents == 2
  @test SinglePointCrossover((probability=0.1,)).numberOfDescendants == 2
   
  @test singlePointCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  @test singlePointCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
end

function sbxCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = SBXCrossover((probability=0.0, distributionIndex=20.0, bounds=parent1.bounds))
  children = crossover.execute(parent1, parent2, crossover.parameters)

  return isequal(parent1, children[1]) && isequal(parent2, children[2])
end

function sbxCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = SBXCrossover((probability=1.0, distributionIndex=20.0, bounds=parent1.bounds))
  children = crossover.execute(parent1, parent2, crossover.parameters)

  return !isequal(parent1, children[1]) && !isequal(parent2, children[2])
end

@testset "SBX crossover tests" begin
  @test getCrossoverProbability(SBXCrossover((probability=0.054, distributionIndex=20.0, bounds=[]))) == 0.054
  @test SBXCrossover((probability=0.054, distributionIndex=20.0, bounds=[])).parameters.distributionIndex == 20.0
  @test SBXCrossover((probability=0.054, distributionIndex=20.0, bounds=[])).numberOfDescendants == 2
  @test SBXCrossover((probability=0.054, distributionIndex=20.0, bounds=[])).numberOfRequiredParents == 2

  @test sbxCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  @test sbxCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
end

function  blxAlphaCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = BLXAlphaCrossover((probability=0.0, alpha=0.5, bounds=parent1.bounds))
  children = crossover.execute(parent1, parent2, crossover.parameters)

  return isequal(parent1, children[1]) && isequal(parent2, children[2])
end

function blxAlphaCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
  parent1 = createContinuousSolution(3)
  parent1.variables = [1.2, 5.2]

  parent2 = createContinuousSolution(3)
  parent2.variables = [3.5, 8.6]

  crossover = BLXAlphaCrossover((probability=1.0, alpha=0.5, bounds=parent1.bounds))
  children = crossover.execute(parent1, parent2, crossover.parameters)

  return !isequal(parent1, children[1]) && !isequal(parent2, children[2])
end

@testset "BLX-alpha crossover tests" begin
  @test getCrossoverProbability(BLXAlphaCrossover((probability=0.12, alpha=0.5, bounds=[]))) == 0.12
  @test BLXAlphaCrossover((probability=0.12, alpha=0.5, bounds=[])).numberOfDescendants == 2
  @test BLXAlphaCrossover((probability=0.12, alpha=0.5, bounds=[])).numberOfRequiredParents == 2

  @test blxAlphaCrossoverWithProbabilityZeroReturnTwoSolutionsEqualToTheParentSolutions()
  @test blxAlphaCrossoverWithWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolutions()
end

