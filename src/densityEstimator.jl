include("core.jl")
include("solution.jl")
include("archive.jl")

"""
    computeCrowdingDistanceEstimator!(solutions::Vector{T}) where {T <: Solution}

Computes the crowding distance density estimator to the solutions of a list. It is assumed that the list only contains non-dominated solutions.
"""
function computeCrowdingDistanceEstimator!(solutions::Vector{T}) where {T <: Solution}
    @assert length(solutions) > 0 "The solution list is empty"
    if length(solutions) < 3
        for solution in solutions
            solution.attributes["CROWDING_DISTANCE_ATTRIBUTE"] = typemax(Float64)
        end
    else
        println("NUMBER OF OBJECTIVES: ", length(solutions[1].objectives))
        numberOfObjectives = length(solutions[1].objectives)
        for solution in solutions
            solution.attributes["CROWDING_DISTANCE_ATTRIBUTE"] = 0.0
        end

        for i in range(1, numberOfObjectives)
            sort!(solutions, by = s -> s.objectives[i])

            minimumObjectiveValue = solutions[1].objectives[i]
            maximumObjectiveValue = solutions[numberOfObjectives].objectives[i]

            solutions[1].attributes["CROWDING_DISTANCE_ATTRIBUTE"] = typemax(Float64)
            solutions[length(solutions)].attributes["CROWDING_DISTANCE_ATTRIBUTE"] = typemax(Float64)

            for j in range(2, length(solutions)-1)
                distance = solutions[j+1].objectives[i] - solutions[j-1].objectives[i]
                distance = distance / (maximumObjectiveValue - minimumObjectiveValue)
                distance = distance + solutions[j].attributes["CROWDING_DISTANCE_ATTRIBUTE"]
                solutions[j].attributes["CROWDING_DISTANCE_ATTRIBUTE"] = distance
            end
            
        end
    end

    return Nothing
end