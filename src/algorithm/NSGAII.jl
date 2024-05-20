using Dates

mutable struct NSGAII <: Algorithm
  problem::Problem
  populationSize::Int
  numberOfEvaluations::Int

  foundSolutions::Vector

  termination::Termination
  mutation::MutationOperator
  crossover::CrossoverOperator

  solver::EvolutionaryAlgorithm

  dominanceComparator::Comparator

  function NSGAII() 
    algorithm = new()
    algorithm.solver = EvolutionaryAlgorithm()
    algorithm.solver.name = "NSGA-II"

    algorithm.dominanceComparator = DefaultDominanceComparator()
    return algorithm
  end
end

function nsgaII(nsgaII::NSGAII)
  solver = nsgaII.solver 
  problem = nsgaII.problem

  populationSize = nsgaII.populationSize
  offspringPopulationSize = nsgaII.populationSize

  solver.solutionsCreation = DefaultSolutionsCreation(problem, populationSize)

  solver.evaluation = SequentialEvaluation(problem)

  solver.termination = nsgaII.termination
  solver.variation = CrossoverAndMutationVariation(offspringPopulationSize, nsgaII.crossover, nsgaII.mutation)

  #solver.replacement = RankingAndDensityEstimatorReplacement(nsgaII.dominanceComparator)
  solver.replacement = RankingAndDensityEstimatorReplacement(DominanceRanking(nsgaII.dominanceComparator), CrowdingDistanceDensityEstimator())

  solver.selection = BinaryTournamentSelection(solver.variation.matingPoolSize, nsgaII.dominanceComparator)

  return evolutionaryAlgorithm(solver)
end

function optimize(algorithm::NSGAII)
  algorithm.foundSolutions = nsgaII(algorithm)
  
  return Nothing
end

function name(nsgaII::NSGAII)
  return name(nsgaII.solver)
end

function getObservable(nsgaII::NSGAII)
  return getObservable(nsgaII.solver)
end