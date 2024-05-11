struct DefaultGlobalBestInitialization <: GlobalBestInitialization
    swarm::Vector{ContinuousSolution}
    globalBest::CrowdingDistanceArchive
end

function initialize(globalBestInitialization::DefaultGlobalBestInitialization)
    @assert length(globalBestInitialization.swarm) > 0

    for particle in globalBestInitialization.swarm
        add!(globalBestInitialization.globalBest, deepcopy(particle))
    end

    return globalBestInitialization.globalBest
end

