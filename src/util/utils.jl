using LinearAlgebra
using CSV

function readFrontFromCSVFile(fileName::String) :: Matrix
    return CSV.read(fileName, CSV.Tables.matrix; header=false)
end

function printObjectivesToCSVFile(fileName::String, solutions::Vector{T}) where {T<:Solution}
    open(fileName, "w") do outputFile
        for solution in solutions
            line = join(solution.objectives, ",")
            println(outputFile, line)
        end
    end
end

function printVariablesToCSVFile(fileName::String, solutions::Vector{T}) where {T<:Solution}
    open(fileName, "w") do outputFile
        for solution in solutions
            line = join(solution.variables, ",")
            println(outputFile, line)
        end
    end
end

function printVariablesToCSVFile(fileName::String, solutions::Vector{BinarySolution})
    open(fileName, "w") do outputFile
        for solution in solutions
            line = toString(solution.variables)
            println(outputFile, line)
        end
    end
end


"""
    normalizeObjectives(solutions::Vector{T})::Vector{T} where {T <: Solution}

Return a list of solutions with objectives normalized to [0, 1] using min-max
normalization per objective. When all solutions share the same value for an
objective (range = 0), that objective is set to 0.0.
"""
function normalizeObjectives(solutions::Vector{T})::Vector{T} where {T<:Solution}
    normalizedSolutions = deepcopy(solutions)
    numberOfObjectives = length(solutions[1].objectives)

    for i in 1:numberOfObjectives
        minVal = minimum(s.objectives[i] for s in normalizedSolutions)
        maxVal = maximum(s.objectives[i] for s in normalizedSolutions)
        range  = maxVal - minVal

        for s in normalizedSolutions
            s.objectives[i] = range > 0.0 ? (s.objectives[i] - minVal) / range : 0.0
        end
    end

    return normalizedSolutions
end

@inline function euclidean_distance(a::Vector{Float64}, b::Vector{Float64})::Float64
    d = 0.0
    @inbounds for i in eachindex(a)
        Δ = a[i] - b[i]
        d += Δ * Δ
    end
    return sqrt(d)
end

function distanceBasedSubsetSelection(solutions::Vector{T}, numberOfSolutionsToSelect::Int)::Vector{T} where {T<:Solution}
    if length(solutions) <= numberOfSolutionsToSelect
        return solutions
    end

    numberOfObjectives = length(solutions[1].objectives)
    if numberOfObjectives == 2
        archiveCapacity = numberOfSolutionsToSelect
        crowdingDistanceArchive = CrowdingDistanceArchive(archiveCapacity, T)

        for solution in solutions
            add!(crowdingDistanceArchive, solution)
        end

        return getSolutions(crowdingDistanceArchive)
    else
        # Step 1: normalize objectives to [0, 1] per objective (min-max)
        normalizedSolutions = normalizeObjectives(solutions)

        for i in eachindex(normalizedSolutions)
            normalizedSolutions[i].attributes["INDEX"] = i
        end

        # Step 2: seed with the solution having the lowest value on a random objective
        randomObjective = rand(1:numberOfObjectives)
        solutionIndex = argmin(i -> normalizedSolutions[i].objectives[randomObjective], eachindex(normalizedSolutions))

        # Step 3: move seed to the selected list
        selectedSolutions = [normalizedSolutions[solutionIndex]]
        deleteat!(normalizedSolutions, solutionIndex)

        # Step 4: greedily add the solution maximising min-distance to the selected set
        while length(selectedSolutions) < numberOfSolutionsToSelect
            for solution in normalizedSolutions
                solution.attributes["SUBSET_SELECTION_DISTANCE"] =
                    minimum(euclidean_distance(solution.objectives, sel.objectives) for sel in selectedSolutions)
            end

            idx = argmax(i -> normalizedSolutions[i].attributes["SUBSET_SELECTION_DISTANCE"]::Float64, eachindex(normalizedSolutions))
            push!(selectedSolutions, normalizedSolutions[idx])
            deleteat!(normalizedSolutions, idx)
        end

        # Step 5: return the original (non-normalised) solutions
        return [solutions[s.attributes["INDEX"]] for s in selectedSolutions]
    end
end
