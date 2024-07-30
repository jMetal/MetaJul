function maxCrowdingDistanceValue()
    return typemax(Float64)
end

@inline function getCrowdingDistance(solution::T) where {T<:Solution}
    return get(solution.attributes, "CROWDING_DISTANCE_ATTRIBUTE", 0.0)
end

@inline function setCrowdingDistance(solution::T, crowdingDistance::Float64) where {T<:Solution}
    solution.attributes["CROWDING_DISTANCE_ATTRIBUTE"] = crowdingDistance

    return Nothing
end

struct CrowdingDistanceComparator <: Comparator end

function compare(comparator::CrowdingDistanceComparator, solution1::Solution, solution2::Solution)::Int
    distance1 = getCrowdingDistance(solution1)
    distance2 = getCrowdingDistance(solution2)
    
    if distance1 > distance2
        return -1
    elseif distance1 < distance2
        return 1
    else
        return 0
    end
end

"""
    computeCrowdingDistanceEstimator!(solutions::Vector{T}) where {T <: Solution}

Computes the crowding distance density estimator to the solutions of a list. It is assumed that the list only contains non-dominated solutions.
"""

struct CrowdingDistanceDensityEstimator <: DensityEstimator end

function compute!(densityEstimator::CrowdingDistanceDensityEstimator, solutions::Vector{T}) where {T<:Solution}
    num_solutions = length(solutions)

    front = copy(solutions)
    @assert length(solutions) > 0 "The solution list is empty"
    if num_solutions < 3
        for solution in front
            setCrowdingDistance(solution, maxCrowdingDistanceValue())
        end
    else
        numberOfObjectives = length(front[1].objectives)
        for solution in front
            setCrowdingDistance(solution, 0.0)
        end

        for i in 1:numberOfObjectives
            sort!(front, by=solution -> solution.objectives[i])

            minimumObjectiveValue = front[1].objectives[i]
            maximumObjectiveValue = front[length(front)].objectives[i]

            setCrowdingDistance(front[begin], maxCrowdingDistanceValue())
            setCrowdingDistance(front[end], maxCrowdingDistanceValue())

            for j in 2:(num_solutions-1)
                distance = (front[j+1].objectives[i] - front[j-1].objectives[i]) 

                if (maximumObjectiveValue - minimumObjectiveValue) > 0
                    distance = distance / (maximumObjectiveValue - minimumObjectiveValue)
                end

                distance += getCrowdingDistance(front[j])
                setCrowdingDistance(front[j], distance)
            end
        end
    end

    return Nothing
end

