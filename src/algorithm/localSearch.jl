mutable struct LocalSearch <: Algorithm
  startingSolution::Solution
  problem::Problem
  numberOfIterations::Int
  mutation::MutationOperator
  foundSolution::Solution

  LocalSearch() = new()
  LocalSearch(startingSolution, problem, numberOfIterations, mutation) = new(startingSolution, problem, numberOfIterations, mutation, copySolution(startingSolution)) 
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
