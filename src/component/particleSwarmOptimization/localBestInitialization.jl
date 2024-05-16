struct DefaultLocalBestInitialization <: LocalBestInitialization end

function initialize(localBestInitialization::DefaultLocalBestInitialization, swarm)
    @assert length(swarm) > 0

    localBest = [copySolution(solution) for solution in swarm]

    return localBest
end
