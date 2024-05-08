using Dates

mutable struct EvolutionaryAlgorithm <: Algorithm
  name::String
  problem::Problem
  populationSize::Int
  offspringPopulationSize::Int

  foundSolutions::Vector

  solutionsCreation::SolutionsCreation
  evaluation::Evaluation
  termination::Termination
  selection::Selection
  variation::Variation
  replacement::Replacement

  observable::Observable

  status::Dict

  function EvolutionaryAlgorithm() 
    x = new()
    x.name = "EA"
    x.observable = Observable("EA observable")
    return return x
  end
end

function getObservable(algorithm::EvolutionaryAlgorithm)
  return algorithm.observable
end

function evolutionaryAlgorithm(ea::EvolutionaryAlgorithm)
  startingTime = Dates.now()

  population = ea.solutionsCreation.create(ea.solutionsCreation.parameters)
  population = ea.evaluation.evaluate(population, ea.evaluation.parameters)

  evaluations = length(population)
  ea.status = Dict("EVALUATIONS" => evaluations, "POPULATION" => population, "COMPUTING_TIME" => (Dates.now() - startingTime))

  notify(ea.observable, ea.status)

  while !ea.termination.isMet(ea.status, ea.termination.parameters)
    matingPool = ea.selection.select(population, ea.selection.parameters)
    
    offspringPopulation = ea.variation.variate(population, matingPool, ea.variation.parameters)
    offspringPopulation = ea.evaluation.evaluate(offspringPopulation, ea.evaluation.parameters)

    population = ea.replacement.replace(population, offspringPopulation, ea.replacement.parameters)

    evaluations += length(offspringPopulation)
    ea.status["EVALUATIONS"] = evaluations
    ea.status["POPULATION"] = population
    ea.status["COMPUTING_TIME"] = Dates.now() - startingTime

    notify(ea.observable, ea.status)
  end

  foundSolutions = population
  return foundSolutions
end

function optimize(algorithm::EvolutionaryAlgorithm)
  algorithm.foundSolutions = evolutionaryAlgorithm(algorithm)
  
  return Nothing
end

function name(algorithm::EvolutionaryAlgorithm)
  return algorithm.name
end


#################################

mutable struct NSGAII <: Algorithm
  problem::Problem
  populationSize::Int
  numberOfEvaluations::Int

  foundSolutions::Vector

  termination::Termination
  mutation::MutationOperator
  crossover::CrossoverOperator

  solver::EvolutionaryAlgorithm

  dominanceComparator::Function

  function NSGAII() 
    algorithm = new()
    algorithm.solver = EvolutionaryAlgorithm()
    algorithm.solver.name = "NSGA-II"

    algorithm.dominanceComparator = compareForDominance
    return algorithm
  end
end

function nsgaII(nsgaII::NSGAII) 
  solver = nsgaII.solver 
  
  solver.problem = nsgaII.problem
  solver.populationSize = nsgaII.populationSize
  solver.offspringPopulationSize = nsgaII.populationSize

  solver.solutionsCreation = DefaultSolutionsCreation((problem = solver.problem, numberOfSolutionsToCreate = solver.populationSize))

  solver.evaluation = SequentialEvaluation((problem = solver.problem, ))

  solver.termination = nsgaII.termination
  solver.variation = CrossoverAndMutationVariation((offspringPopulationSize = solver.offspringPopulationSize, crossover = nsgaII.crossover, mutation = nsgaII.mutation))

  solver.replacement = RankingAndDensityEstimatorReplacement((dominanceComparator = nsgaII.dominanceComparator, ))

  solver.selection = BinaryTournamentSelection((matingPoolSize = solver.variation.matingPoolSize, comparator = compareRankingAndCrowdingDistance))

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