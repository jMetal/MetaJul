struct DefaultLocalBestUpdate <: LocalBestUpdate 
    dominanceComparator::Comparator
end

function update(localBestUpdate::DefaultLocalBestUpdate, swarm, localBest)
    @assert length(swarm) > 0

    for i in 1:length(swarm)
      result = compare(localBestUpdate.dominanceComparator, swarm[i], localBest[i])
      if result != 1
        localBest[i] = copySolution(swarm[i])
      end
    end
    
    return localBest
end
