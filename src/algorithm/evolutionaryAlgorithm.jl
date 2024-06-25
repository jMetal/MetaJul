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

  foundSolutions::Vector
  population::Vector
  offspringPopulation::Vector
  startingTime

  status::Dict

  function EvolutionaryAlgorithm() 
    x = new()
    x.name = "Evolutionary algorithm"
    x.observable = Observable("EvolutionaryAlgorithm observable")
    return return x
  end
end

function observable(algorithm::EvolutionaryAlgorithm)
  return algorithm.observable
end

function evolutionaryAlgorithm(ea::EvolutionaryAlgorithm)
  ea.startingTime = Dates.now()

  ea.population = create(ea.solutionsCreation)
  ea.population = evaluate(ea.evaluation, ea.population)

  initStatus(ea)

  while !isMet(ea.termination, ea.status)
    matingPool = select(ea.selection, ea.population)
    
    ea.offspringPopulation = variate(ea.variation, ea.population, matingPool)
    ea.offspringPopulation = evaluate(ea.evaluation, ea.offspringPopulation)

    ea.population = replace_(ea.replacement, ea.population, ea.offspringPopulation)

    updateStatus(ea)
  end

  ea.foundSolutions = ea.population
end

function optimize!(algorithm::EvolutionaryAlgorithm)
  evolutionaryAlgorithm(algorithm)
end

function initStatus(ea::EvolutionaryAlgorithm)
  evaluations = length(ea.population)
  ea.status = Dict("EVALUATIONS" => evaluations, "POPULATION" => ea.population, "COMPUTING_TIME" => (Dates.now() - ea.startingTime))

  notify(ea.observable, ea.status)
end

function updateStatus(ea::EvolutionaryAlgorithm)    
  ea.status["EVALUATIONS"] += length(ea.offspringPopulation)
  ea.status["POPULATION"] = ea.population
  ea.status["COMPUTING_TIME"] = Dates.now() - ea.startingTime

  notify(ea.observable, ea.status)
end

function status(ea::EvolutionaryAlgorithm)
  return ea.status
end

function name(ea::EvolutionaryAlgorithm)
  return ea.name
end

function foundSolutions(ea::EvolutionaryAlgorithm) 
  return ea.foundSolutions
end


function computingTime(ea::EvolutionaryAlgorithm)
  return ea.status["COMPUTING_TIME"]
end