
#########################################################################
# Test cases for mutation operators
#########################################################################

function mutateABinarySolutionWithProbabilityZeroReturnASolutionWithTheSameVariables()
  solution = BinarySolution(initBitVector("1010"), [1.0, 2.0, 3.0], [-1], Dict())
  mutation = BitFlipMutation(0.0)
  newSolution = mutate(copySolution(solution), mutation)

  return isequal(solution, newSolution)
end

function mutateABinarySolutionWithProbabilityOneFlipsAllTheBits()
  solution = BinarySolution(initBitVector("10100"), [1.0, 2.0, 3.0], [-1], Dict())
  mutation = BitFlipMutation(1.0)
  newSolution = mutate(copySolution(solution), mutation)
  expectedSolution = BinarySolution(initBitVector("01011"), [1.0, 2.0, 3.0], [-1], Dict())

  return isequal(expectedSolution, newSolution)
end

@testset "BitFlip mutation tests" begin
  #@test BitFlipMutation(0.01).probability == 0.01
  @test mutateABinarySolutionWithProbabilityZeroReturnASolutionWithTheSameVariables()
  @test mutateABinarySolutionWithProbabilityOneFlipsAllTheBits()
end

"""
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
  @test mutationProbability(UniformMutation((probability=0.054, perturbation=0.5, bounds=[]))) == 0.054
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
  @test mutationProbability(PolynomialMutation((probability=0.054, distributionIndex=20.0, bounds=[]))) == 0.054
  @test getDistributionIndex(PolynomialMutation((probability=0.054, distributionIndex=10.0, bounds=[]))) == 10.0
  @test mutateAContinuousSolutionWithPolynomialMutationWithProbabilityZeroReturnASolutionWithTheSameVariables()
  @test mutateAContinuousSolutionWithPolynomialMutationWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolution()
end

"""