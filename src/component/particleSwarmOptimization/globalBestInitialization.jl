struct DefaultGlobalBestInitialization <: GlobalBestInitialization end

function initialize(globalBestInitialization::DefaultGlobalBestInitialization, swarm, globalBest::CrowdingDistanceArchive)
    @assert length(swarm) > 0

    for particle in swarm
        add!(globalBest, copySolution(particle))
    end

    compute!(globalBest.densityEstimator, swarm)

    return globalBest
end

