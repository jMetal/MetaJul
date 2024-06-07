using Dates

mutable struct EvolutionaryAlgorithm <: Algorithm
  # Final fields
  name::String

  solutionsCreation::SolutionsCreation
  evaluation::Evaluation
  termination::Termination
  selection::Selection
  variation::Variation
  replacement::Replacement

  observable::Observable

  # Updatable fields
  foundSolutions::Vector
  population
  offspringPopulation
  startingTime

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
  population = evaluate(ea.evaluation, population)

  initStatus(ea, population, startingTime)

  while !isMet(ea.termination, ea.status)
    matingPool = select(ea.selection, population)
    
    offspringPopulation = variate(ea.variation, population, matingPool)
    offspringPopulation = evaluate(ea.evaluation, offspringPopulation)

    population = replace_(ea.replacement, population, offspringPopulation)

    updateStatus(ea, population, offspringPopulation, startingTime)
  end

  ea.foundSolutions = population
end

function optimize(algorithm::EvolutionaryAlgorithm)
  evolutionaryAlgorithm(algorithm)
end

function initStatus(ea::EvolutionaryAlgorithm, population, startingTime)
  evaluations = length(population)
  ea.status = Dict("EVALUATIONS" => evaluations, "POPULATION" => population, "COMPUTING_TIME" => (Dates.now() - startingTime))

  notify(ea.observable, ea.status)
end

function updateStatus(ea::EvolutionaryAlgorithm, population, offspringPopulation, startingTime)    
  ea.status["EVALUATIONS"] += length(offspringPopulation)
  ea.status["POPULATION"] = population
  ea.status["COMPUTING_TIME"] = Dates.now() - startingTime

  notify(ea.observable, ea.status)
end


function name(algorithm::EvolutionaryAlgorithm)
  return algorithm.name
end

