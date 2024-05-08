mutable struct LocalSearch <: Algorithm
  startingSolution::Solution
  problem::Problem
  numberOfIterations::Int
  mutation::MutationOperator
  foundSolution::Solution
end

function optimize(algorithm::LocalSearch)::Solution
  currentSolution = algorithm.startingSolution
  problem = algorithm.problem
  numberOfIterations = algorithm.numberOfIterations
  mutation = algorithm.mutation

  for _ in 1:numberOfIterations
    mutatedSolution = copySolution(algorithm.startingSolution)
    mutatedSolution.variables = mutate(mutatedSolution.variables, mutation)
    
    mutatedSolution = evaluate(mutatedSolution, problem)

    if (mutatedSolution.objectives[1] < currentSolution.objectives[1])
      currentSolution = mutatedSolution
    end
  end

  algorithm.foundSolution = foundSolution

  return currentSolution
end
