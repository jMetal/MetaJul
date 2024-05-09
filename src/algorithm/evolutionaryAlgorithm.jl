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
    x.name = "Evolutionary algorithm"
    x.observable = Observable("EvolutionaryAlgorithm observable")
    return return x
  end
end

function getObservable(algorithm::EvolutionaryAlgorithm)
  return algorithm.observable
end

function evolutionaryAlgorithm(ea::EvolutionaryAlgorithm)
  startingTime = Dates.now()

  population = create(ea.solutionsCreation)
  population = evaluate(population, ea.evaluation)

  evaluations = length(population)
  ea.status = Dict("EVALUATIONS" => evaluations, "POPULATION" => population, "COMPUTING_TIME" => (Dates.now() - startingTime))

  notify(ea.observable, ea.status)

  while !isMet(ea.status, ea.termination)
    matingPool = select(population, ea.selection)
    
    offspringPopulation = variate(population, matingPool, ea.variation)
    offspringPopulation = evaluate(offspringPopulation, ea.evaluation)

    population = replace_(population, offspringPopulation, ea.replacement)

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

