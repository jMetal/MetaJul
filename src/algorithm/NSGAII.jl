using Dates

mutable struct NSGAII <: Algorithm
  problem::Problem
  populationSize::Int

  termination::Termination
  mutation::MutationOperator
  crossover::CrossoverOperator

  solver::EvolutionaryAlgorithm

  dominanceComparator::Comparator

  function NSGAII(
    problem :: ContinuousProblem; 
    populationSize = 100, 
    termination = TerminationByEvaluations(25000), dominanceComparator = numberOfConstraints(problem) == 0 ? DefaultDominanceComparator() : ConstraintsAndDominanceComparator(),
    crossover = SBXCrossover(probability = 1.0, distributionIndex = 20.0, bounds = problem.bounds),
    mutation = PolynomialMutation(1.0/numberOfVariables(problem), 20.0, problem.bounds))
    algorithm = new()
    algorithm.solver = EvolutionaryAlgorithm()
    algorithm.solver.name = "NSGA-II"
    algorithm.problem = problem
    algorithm.populationSize = populationSize
    algorithm.dominanceComparator = dominanceComparator 
    algorithm.crossover = crossover
    algorithm.mutation = mutation
    algorithm.termination = termination

    return algorithm
  end

  function NSGAII(
    problem :: BinaryProblem; 
    populationSize = 100, 
    termination = TerminationByEvaluations(25000), dominanceComparator = numberOfConstraints(problem) == 0 ? DefaultDominanceComparator() : ConstraintsAndDominanceComparator(),
    crossover = SinglePointCrossover(probability = 1.0),
    mutation = BitFlipMutation(1.0/problem.numberOfBits))
    algorithm = new()
    algorithm.solver = EvolutionaryAlgorithm()
    algorithm.solver.name = "NSGA-II"
    algorithm.problem = problem
    algorithm.populationSize = populationSize
    algorithm.dominanceComparator = dominanceComparator 
    algorithm.crossover = crossover
    algorithm.mutation = mutation
    algorithm.termination = termination

    return algorithm
  end

end

function foundSolutions(nsgaII::NSGAII) 
  return nsgaII.solver.foundSolutions
end

function optimize!(nsgaII::NSGAII)
  solver = nsgaII.solver
  problem = nsgaII.problem

  populationSize = nsgaII.populationSize
  offspringPopulationSize = nsgaII.populationSize

  solver.solutionsCreation = DefaultSolutionsCreation(problem, populationSize)

  solver.evaluation = SequentialEvaluation(problem)

  solver.termination = nsgaII.termination
  solver.variation = CrossoverAndMutationVariation(offspringPopulationSize, nsgaII.crossover, nsgaII.mutation)

  solver.replacement = RankingAndDensityEstimatorReplacement(DominanceRanking(nsgaII.dominanceComparator), CrowdingDistanceDensityEstimator())

  solver.selection = BinaryTournamentSelection(solver.variation.matingPoolSize, nsgaII.dominanceComparator)

  return evolutionaryAlgorithm(solver)
end

function name(nsgaII::NSGAII)
  return name(nsgaII.solver)
end

function status(nsgaII::NSGAII)
  return status(nsgaII.solver)
end

function computingTime(nsgaII::NSGAII)
  return status(nsgaII)["COMPUTING_TIME"]
end

function observable(nsgaII::NSGAII)
  return observable(nsgaII.solver)
end
