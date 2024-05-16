struct DefaultGlobalBestInitialization <: GlobalBestInitialization end

function initialize(globalBestInitialization::DefaultGlobalBestInitialization, swarm, globalBest)
    @assert length(swarm) > 0

    for particle in swarm
        add!(globalBest, copySolution(particle))
    end

    return globalBest
end

