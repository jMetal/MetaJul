struct DefaultPositionUpdate <: PositionUpdate 
    velocityChangeWhenLowerLimitIsReached::Float64
    velocityChangeWhenUpperLimitIsReached::Float64
    positionBounds::Vector{Bounds{Float64}}      
end

function update(positionUpdate::DefaultPositionUpdate, swarm, speed)
    @assert length(swarm) > 0

    for i in 1:length(swarm)
        particle = swarm[i]
        for j in 1:length(particle.variables)
            particle.variables[j] = particle.variables[j] + speed[i, j]

            bounds = positionUpdate.positionBounds[j]
            lowerBound = bounds.lowerBound
            upperBound = bounds.upperBound
            if particle.variables[j] < lowerBound
                particle.variables[j] = lowerBound
                speed[i, j] = speed[i, j] * positionUpdate.velocityChangeWhenLowerLimitIsReached
            end
            if particle.variables[j] > upperBound
                particle.variables[j] = upperBound
                speed[i, j] = speed[i, j] * positionUpdate.velocityChangeWhenUpperLimitIsReached
            end
        end
    end
    
    return swarm
end
