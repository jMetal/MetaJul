struct DefaultVelocityInitialization <: VelocityInitialization
    swarm::Vector{ContinuousSolution}
end

function initialize(velocityInitialization::DefaultVelocityInitialization)
    numberOfVariables = length(velocityInitialization.swarm[1].variables)

    return zeros(length(velocityInitialization.swarm), numberOfVariables)
end
