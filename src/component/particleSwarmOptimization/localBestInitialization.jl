struct DefaultLocalBestInitialization <: LocalBestInitialization
    swarm::Vector{ContinuousSolution}
end

function initialize(localBestInitialization::DefaultLocalBestInitialization)
    @assert length(localBestInitialization.swarm) > 0

    localBest = [copySolution(solution) for solution in localBestInitialization.swarm]

    return localBest
end
