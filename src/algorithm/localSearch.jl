mutable struct LocalSearch <: Algorithm
  startingSolution::Solution
  problem::Problem
  numberOfIterations::Int
  mutation::MutationOperator

  foundSolution::Solution

  LocalSearch() = new()
  
  function LocalSearch(
    startingSolution::BinarySolution, 
    problem::BinaryProblem; 
    numberOfIterations = 10000,
    mutation = BitFlipMutation(1.0 / problem.numberOfBits))
      new(startingSolution, problem, numberOfIterations, mutation) 
  end

  function LocalSearch(
      startingSolution::ContinuousSolution, 
      problem::ContinuousProblem; 
      numberOfIterations = 10000,
      mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds)) 
        new(startingSolution, problem, numberOfIterations, mutation) 
  end
end

function optimize(algorithm::LocalSearch)::Solution
  currentSolution = algorithm.startingSolution
  problem = algorithm.problem
  numberOfIterations = algorithm.numberOfIterations
  mutation = algorithm.mutation

  for _ in 1:numberOfIterations
    mutatedSolution = copySolution(currentSolution)
    mutatedSolution = mutate!(mutatedSolution, mutation)
    
    mutatedSolution = evaluate(mutatedSolution, problem)

    if (mutatedSolution.objectives[1] < currentSolution.objectives[1])
      currentSolution = mutatedSolution
    end
  end

  algorithm.foundSolution = currentSolution

  return currentSolution
end
