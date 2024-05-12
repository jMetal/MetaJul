struct DefaultGlobalBestUpdate <: GlobalBestUpdate
    swarm::Vector{ContinuousSolution}
    globalBest::CrowdingDistanceArchive
end

function update(globalBestUpdate::DefaultGlobalBestUpdate)
    @assert length(globalBestUpdate.swarm) > 0

    for solution in globalBestUpdate.swarm
        add!(globalBestUpdate.globalBest, copySolution(solution))
    end

    return globalBestUpdate.globalBest
end
