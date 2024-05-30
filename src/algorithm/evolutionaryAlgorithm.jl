using Dates

mutable struct EvolutionaryAlgorithm <: Algorithm
  name::String

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
  population = evaluate(ea.evaluation, population)

  evaluations = length(population)
  ea.status = Dict("EVALUATIONS" => evaluations, "POPULATION" => population, "COMPUTING_TIME" => (Dates.now() - startingTime))

  notify(ea.observable, ea.status)

  while !isMet(ea.termination, ea.status)
    matingPool = select(ea.selection, population)
    
    offspringPopulation = variate(ea.variation, population, matingPool)
    offspringPopulation = evaluate(ea.evaluation, offspringPopulation)

    #println(toString(population, "Population N"))
    #println(toString(offspringPopulation, "Offspring population"))

    population = replace_(ea.replacement, population, offspringPopulation)

    #println(toString(population, "Population N + 1"))
    #println(toString(population, "P", CrowdingDistanceDensityEstimator()))

    evaluations += length(offspringPopulation)
    ea.status["EVALUATIONS"] = evaluations
    ea.status["POPULATION"] = population
    ea.status["COMPUTING_TIME"] = Dates.now() - startingTime

    notify(ea.observable, ea.status)
  end

  ea.foundSolutions = population
end

function optimize(algorithm::EvolutionaryAlgorithm)
  evolutionaryAlgorithm(algorithm)
end

function name(algorithm::EvolutionaryAlgorithm)
  return algorithm.name
end

