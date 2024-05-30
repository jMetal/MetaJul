function toString(ranking::DominanceRanking)
    result = string("Number of ranks: ", length(ranking.ranks), "\n")
    for rank in ranking.ranks
        result = string(result, length(rank), "\n")
        for solution in rank
            result = string(result, " - ", getRank(solution), " - ", solution.objectives, "\n")
        end
        result = string(result, "\n")
    end

    return result
end

function toString(ranking::DominanceRanking, densityEstimator::CrowdingDistanceDensityEstimator)
    result = string("Number of ranks: ", length(ranking.ranks), "\n")
    for rank in ranking.ranks
        result = string(result, length(rank), "\n")
        for solution in rank
            result = string(result, " - ", getRank(solution), " - ", solution.objectives)
            result = string(result, " . Crowding distance: ", getCrowdingDistance(solution), "\n")
        end
        result = string(result, "\n")
    end

    return result
end

function toString(solutions::Vector{S}, name, densityEstimator::CrowdingDistanceDensityEstimator) where {S <: Solution}
    result = string("- Solutions in ", name, " - \n")
    result = string(result, "Number of solutions:", length(solutions), "\n")
    for (i, solution) in enumerate(solutions)
        result = string(result, [_ for _ in solution.objectives], ". Crowding distance: ", getCrowdingDistance(solution), "\n")
    end   

    return result
end

function toString(solutions::Vector{S}, name) where {S <: Solution}
    result = string("- Solutions in ", name, " - \n")
    result = string(result, "Number of solutions:", length(solutions), "\n")
    for (i, solution) in enumerate(solutions)
        result = string(result, [_ for _ in solution.objectives], "\n")
    end   

    #result = replace(result, "[" => "{" )
    #result = replace(result, "]" => "}," )

    return result
end