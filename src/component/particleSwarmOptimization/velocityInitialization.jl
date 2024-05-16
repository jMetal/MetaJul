struct DefaultVelocityInitialization <: VelocityInitialization end

function initialize(velocityInitialization::DefaultVelocityInitialization, swarm)
    numberOfVariables = length(swarm[1].variables)

    return zeros(length(swarm), numberOfVariables)
end
