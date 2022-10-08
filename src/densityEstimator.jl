include("core.jl")
include("solution.jl")
include("archive.jl")

"""
struct CrowdingDistance
    attributedId::String
    compute::Function

    function CrowdingDistance()
        new("CROWDING_DISTANCE_ATTRIBUTE", computeCrowdingDistanceEstimator!)
    end
end


function getDensityEstimatorValue(crowdingDistance::CrowdingDistance, solution::Solution)
    return solution.attributes[crowdingDistance.attributedId]
end
"""
function getCrowdingDistance(solution::T) where {T <: Solution}
    return get(solution.attributes, "CROWDING_DISTANCE_ATTRIBUTE", 0)
end

function setCrowdingDistance(solution::T, crowdingDistance::Real) where {T <: Solution}
    return solution.attributes["CROWDING_DISTANCE_ATTRIBUTE"] = crowdingDistance
end

"""
function comparator(crowdingDistance::CrowdingDistance, solution1::Solution, solution2::Solution)::Int
    result = 0
    if solution1.attributes[crowdingDistance.attributedId] > solution2.attributes[crowdingDistance.attributedId] 
        result = -1
    elseif solution1.attributes[crowdingDistance.attributedId] < solution2.attributes[crowdingDistance.attributedId] 
        result = 1
    end

    return result
end
"""
function crowdingDistanceComparator(solution1::Solution, solution2::Solution)::Int
    result = 0
    if getCrowdingDistance(solution1) > getCrowdingDistance(solution2)
        result = -1
    elseif getCrowdingDistance(solution1) < getCrowdingDistance(solution2)
        result = 1
    end

    return result
end

"""
    computeCrowdingDistanceEstimator!(solutions::Vector{T}) where {T <: Solution}

Computes the crowding distance density estimator to the solutions of a list. It is assumed that the list only contains non-dominated solutions.
"""
function computeCrowdingDistanceEstimator!(solutions::Vector{T}) where {T <: Solution}
    @assert length(solutions) > 0 "The solution list is empty"
    if length(solutions) < 3
        for solution in solutions
            setCrowdingDistance(solution, typemax(Float64))
        end
    else
        numberOfObjectives = length(solutions[1].objectives)
        for solution in solutions
            setCrowdingDistance(solution, 0.0)
        end

        for i in range(1, numberOfObjectives)
            sort!(solutions, by = s -> s.objectives[i])

            minimumObjectiveValue = solutions[1].objectives[i]
            maximumObjectiveValue = solutions[numberOfObjectives].objectives[i]

            setCrowdingDistance(solution[1], typemax(Float64))
            setCrowdingDistance(solutions[length(solutions)], typemax(Float64))

            for j in range(2, length(solutions)-1)
                distance = solutions[j+1].objectives[i] - solutions[j-1].objectives[i]
                distance = distance / (maximumObjectiveValue - minimumObjectiveValue)
                distance = distance + getCrowdingDistance(solutions[j])
                setCrowdingDistance(solutions[j], distance)
            end     
        end
    end

    return Nothing
end