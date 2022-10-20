include("core.jl")
include("solution.jl")
include("archive.jl")

function maxCrowdingDistanceValue()
    return typemax(Float64)
end

function getCrowdingDistance(solution::T) where {T<:Solution}
    return get(solution.attributes, "CROWDING_DISTANCE_ATTRIBUTE", 0)
end

function setCrowdingDistance(solution::T, crowdingDistance::Real) where {T<:Solution}
    return solution.attributes["CROWDING_DISTANCE_ATTRIBUTE"] = crowdingDistance
end

function compareCrowdingDistance(solution1::Solution, solution2::Solution)::Int
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
function computeCrowdingDistanceEstimator!(solutions::Vector{T}) where {T<:Solution}
    @assert length(solutions) > 0 "The solution list is empty"
    if length(solutions) < 3
        for solution in solutions
            setCrowdingDistance(solution, maxCrowdingDistanceValue())
        end
    else
        numberOfObjectives = length(solutions[1].objectives)
        for solution in solutions
            setCrowdingDistance(solution, 0.0)
        end

        for i in range(1, numberOfObjectives)
            #sort!(solutions, by = s -> s.objectives[i])
            sort!(solutions, lt=(x, y) -> compareIthObjective(x, y, i) <= 0)

            minimumObjectiveValue = solutions[1].objectives[i]
            maximumObjectiveValue = solutions[numberOfObjectives].objectives[i]

            setCrowdingDistance(solutions[begin],maxCrowdingDistanceValue())
            setCrowdingDistance(solutions[end], maxCrowdingDistanceValue())

            for j in range(2, length(solutions) - 1)
                distance = solutions[j+1].objectives[i] - solutions[j-1].objectives[i]
                distance = distance / (maximumObjectiveValue - minimumObjectiveValue)
                distance = distance + getCrowdingDistance(solutions[j])
                setCrowdingDistance(solutions[j], distance)
            end
        end
    end

    return Nothing
end

struct CrowdingDistanceArchive{T<:Solution} <: Archive
    capacity::Int
    internalNonDominatedArchive::NonDominatedArchive{T}
end

function CrowdingDistanceArchive(capacity::Int, T::Type{<:Solution})
    return CrowdingDistanceArchive(capacity, NonDominatedArchive(T[]))
end

function Base.length(archive::CrowdingDistanceArchive)::Int
    return length(archive.internalNonDominatedArchive)
end

function isEmpty(archive::CrowdingDistanceArchive)::Bool
    return length(archive) == 0
end

function isFull(archive::CrowdingDistanceArchive)
    return length(archive.internalNonDominatedArchive) == archive.capacity
end

function capacity(archive::CrowdingDistanceArchive)::Int
    return archive.capacity
end

function contain(archive::CrowdingDistanceArchive{T}, solution::T)::Bool where {T<:Solution}
    return contain(archive.internalNonDominatedArchive, solution)
end

function getSolutions(archive::CrowdingDistanceArchive{T})::Vector{T} where {T<:Solution}
    return getSolutions(archive.internalNonDominatedArchive)
end


function computeCrowdingDistanceEstimator!(archive::CrowdingDistanceArchive{T}) where {T<:Solution}
    return computeCrowdingDistanceEstimator!(archive.internalNonDominatedArchive.solutions)
end

function add!(archive::CrowdingDistanceArchive{T}, solution::T)::Bool where {T<:Solution}
    solutionIsAdded = add!(archive.internalNonDominatedArchive, solution)

    if solutionIsAdded && isFull(archive)
        println("HERE")
        computeCrowdingDistanceEstimator!(archive.internalNonDominatedArchive.solutions)
        sort!(getSolutions(archive), lt=((x, y) -> compareCrowdingDistance(x, y) < 0))

        solutionToDelete = pop!(getSolutions(archive))
        if solutionToDelete == solution
            solutionIsAdded = false
        end
    end

    return solutionIsAdded
end

