using Dates

mutable struct ParticleSwarmOptimization <: Algorithm
  name::String

  foundSolutions::Vector

  solutionsCreation::SolutionsCreation
  evaluation::Evaluation
  termination::Termination
  velocityInitialization::VelocityInitialization 
  localBestInitialization::LocalBestInitialization 
  globalBestInitialization::GlobalBestInitialization
  velocityUpdate::VelocityUpdate
  positionUpdate::PositionUpdate 
  perturbation::Perturbation
  globalBestUpdate::GlobalBestUpdate
  localBestUpdate::LocalBestUpdate 
  inertiaWeightComputingStrategy::InertiaWeightComputingStrategy
  globalBestSelection::GlobalBestSelection

  globalBest::CrowdingDistanceArchive

  observable::Observable

  status::Dict

  function ParticleSwarmOptimization() 
    x = new()
    x.name = "Particle swarm optimization algorithm"
    x.observable = Observable("PSO observable")
    return return x
  end
end

function getObservable(algorithm::ParticleSwarmOptimization)
  return algorithm.observable
end

function particleSwarmOptimization(pso::ParticleSwarmOptimization)
  startingTime = Dates.now()

  swarm = create(pso.solutionsCreation)
  swarm = evaluate(pso.evaluation, swarm)
  speed = initialize(pso.velocityInitialization, swarm)
  localBest = initialize(pso.localBestInitialization, swarm)
  globalBest = initialize(pso.globalBestInitialization, swarm, pso.globalBest)

  evaluations = length(swarm)

  pso.status = Dict("EVALUATIONS" => evaluations, "POPULATION" => getSolutions(globalBest), "COMPUTING_TIME" => (Dates.now() - startingTime))

  notify(pso.observable, pso.status)

  while !isMet(pso.termination, pso.status)
    speed = update(pso.velocityUpdate, swarm, speed, localBest, globalBest, pso.globalBestSelection, pso.inertiaWeightComputingStrategy)

    swarm = update(pso.positionUpdate, swarm, speed)
    swarm = perturbate!(pso.perturbation, swarm)
    swarm = evaluate(pso.evaluation, swarm)
  
    globalBest = update(pso.globalBestUpdate, swarm, globalBest)
    localBest = update(pso.localBestUpdate, swarm, localBest)
    
    evaluations += length(swarm)
    pso.status["EVALUATIONS"] = evaluations
    pso.status["POPULATION"] = getSolutions(globalBest)
    pso.status["COMPUTING_TIME"] = Dates.now() - startingTime

    notify(pso.observable, pso.status)
  end

  pso.foundSolutions = getSolutions(globalBest)
  return pso.foundSolutions
end

function optimize(algorithm::ParticleSwarmOptimization)
  particleSwarmOptimization(algorithm)
  
  return Nothing
end

function name(algorithm::ParticleSwarmOptimization)
  return algorithm.name
end

function status(pso::ParticleSwarmOptimization)
  return pso.status
end

function computingTime(pso::ParticleSwarmOptimization)
  return pso.status["COMPUTING_TIME"]
end
