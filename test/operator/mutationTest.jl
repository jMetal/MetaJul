
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

function uniformMutationIsCorrectlyInitialiazed() 
  solution = createContinuousSolution(3)
  solution.variables = [1.2, 5.2]

  mutation = UniformMutation(0.01, 0.5, solution.bounds)

  return 0.01 == mutation.probability &&
  0.5 == mutation.perturbation &&
  solution.bounds == mutation.variableBounds
end

function mutateAContinuousSolutionWithUniformMutationWithProbabilityZeroReturnASolutionWithTheSameVariables()
  solution = createContinuousSolution(3)
  solution.variables = [1.2, 5.2]

  mutation = UniformMutation(0.0, 0.5, solution.bounds)
  newSolution = mutate(copySolution(solution), mutation)

  return isequal(solution, newSolution)
end

function mutateAContinuousSolutionWithUniformMutationWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolution()
  solution = createContinuousSolution(3)
  solution.variables = [1.2, 5.2]

  mutation = UniformMutation(1.0, 0.5, solution.bounds)
  newSolution = mutate(copySolution(solution), mutation)

  return !isequal(solution.variables[1], newSolution.variables[1]) && !isequal(solution.variables[2], newSolution.variables[2])
end

@testset "Uniform mutation tests" begin
  @test uniformMutationIsCorrectlyInitialiazed()
  @test mutateAContinuousSolutionWithUniformMutationWithProbabilityZeroReturnASolutionWithTheSameVariables()
  @test mutateAContinuousSolutionWithUniformMutationWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolution()
end


function polynomialMutationIsCorrectlyInitialiazed() 
  solution = createContinuousSolution(3)
  solution.variables = [1.2, 5.2]

  mutation = PolynomialMutation(0.01, 15, solution.bounds)

  return 0.01 == mutation.probability &&
  15 == mutation.distributionIndex &&
  solution.bounds == mutation.variableBounds
end

function mutateAContinuousSolutionWithPolynomialMutationWithProbabilityZeroReturnASolutionWithTheSameVariables()
  solution = createContinuousSolution(3)
  solution.variables = [1.2, 5.2]

  mutation = PolynomialMutation(0.0, 20.0, solution.bounds)
  newSolution = mutate(copySolution(solution), mutation)

  return isequal(solution, newSolution)
end

function mutateAContinuousSolutionWithPolynomialMutationWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolution()
  solution = createContinuousSolution(3)
  solution.variables = [1.2, 5.2]

  mutation = PolynomialMutation(1.0, 15, solution.bounds)
  newSolution = mutate(copySolution(solution), mutation)

  return !isequal(solution.variables[1], newSolution.variables[1]) && !isequal(solution.variables[2], newSolution.variables[2])
end

@testset "Polynomial mutation tests" begin
  @test polynomialMutationIsCorrectlyInitialiazed()
  @test mutateAContinuousSolutionWithPolynomialMutationWithProbabilityZeroReturnASolutionWithTheSameVariables()
  @test mutateAContinuousSolutionWithPolynomialMutationWithProbabilityOneChangesAllTheVariableValuesIntheReturnedSolution()
end
