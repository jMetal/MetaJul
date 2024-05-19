struct DefaultGlobalBestUpdate <: GlobalBestUpdate end

function update(globalBestUpdate::DefaultGlobalBestUpdate, swarm, globalBest)
    @assert length(swarm) > 0

    for solution in swarm
        add!(globalBest, copySolution(solution))
    end

    compute!(globalBest.densityEstimator, swarm)

    return globalBest
end
