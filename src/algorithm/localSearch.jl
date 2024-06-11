mutable struct LocalSearch <: Algorithm
  startingSolution::Solution
  problem::Problem
  termination::Termination
  mutation::MutationOperator

  currentSolution::Solution
  startingTime

  status::Dict

  observable::Observable

  function LocalSearch() 
    ls = new()
    ls.observable = Observable("Local search observable")

    return ls
  end

  function LocalSearch(
    startingSolution::BinarySolution,
    problem::BinaryProblem;
    termination = TerminationByIterations(10000),
    mutation=BitFlipMutation(1.0 / problem.numberOfBits))
    ls = new(startingSolution, problem, termination, mutation)
    ls.observable = Observable("Local search observable")

    return ls
  end

  function LocalSearch(
    startingSolution::ContinuousSolution,
    problem::ContinuousProblem;
    termination = TerminationByIterations(10000),
    mutation = PolynomialMutation(1.0 / numberOfVariables(problem), 20.0, problem.bounds))
    ls = new(startingSolution, problem, termination, mutation)
    ls.observable = Observable("Local search observable")

    return ls
  end
end

function optimize(ls::LocalSearch)::Solution
  ls.startingTime = Dates.now()

  ls.currentSolution = ls.startingSolution
  problem = ls.problem
  mutation = ls.mutation

  initStatus(ls)

  while !isMet(ls.termination, ls.status)
    mutatedSolution = copySolution(ls.currentSolution)
    mutatedSolution = mutate!(mutatedSolution, mutation)

    mutatedSolution = evaluate(mutatedSolution, problem)

    if (mutatedSolution.objectives[1] < ls.currentSolution.objectives[1])
      ls.currentSolution = mutatedSolution
    end

    updateStatus(ls)
  end

  return ls.currentSolution
end

function observable(algorithm::LocalSearch)
  return algorithm.observable
end

function initStatus(ls::LocalSearch)
    ls.status = Dict(
      "ITERATIONS" => 1, 
      "CURRENT_SOLUTION" => ls.currentSolution, 
      "COMPUTING_TIME" => (Dates.now() - ls.startingTime))

  notify(ls.observable, ls.status)
end

function updateStatus(ls::LocalSearch)    
  ls.status["ITERATIONS"] += 1
  ls.status["CURRENT_SOLUTION"] = ls.currentSolution
  ls.status["COMPUTING_TIME"] = Dates.now() - ls.startingTime

  notify(ls.observable, ls.status)
end

