struct DefaultVelocityInitialization <: VelocityInitialization end

function initialize(velocityInitialization::DefaultVelocityInitialization, swarm)
    numberOfVariables = length(swarm[1].variables)

    return zeros(Float64, length(swarm), numberOfVariables)
end
