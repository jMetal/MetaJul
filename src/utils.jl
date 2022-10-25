include("densityEstimator.jl")

using LinearAlgebra

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

Return a list of solutions having the objective values normalized
"""
function normalizeObjectives(solutions::Vector{T})::Vector{T} where {T<:Solution}
    normalizedSolutions = deepcopy(solutions)
    numberOfObjectives = length(solutions[1].objectives)

    for i in 1:numberOfObjectives
        ithObjectiveValues = [normalizedSolutions[j].objectives[i] for j in 1:length(normalizedSolutions)]
        normalizedObjectives = normalize(ithObjectiveValues, 1)

        for j in 1:length(normalizedSolutions)
            normalizedSolutions[j].objectives[i] = normalizedObjectives[j]
        end
    end

    return normalizedSolutions
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
        # Step 1: normalize objectives
        normalizedSolutions = normalizeObjectives(solutions)

        for i in eachindex(normalizedSolutions)
            normalizedSolutions[i].attributes["INDEX"] = i
        end

        # Step 2. Find the solution having the lowest objective value, being the objective selected randomly
        randomObjective = rand(1:numberOfObjectives)
        _, solutionIndex = findmin([normalizedSolutions[i].objectives[randomObjective] for i in 1:length(normalizedSolutions)])

        # Step 3. Add the solution to the current list of selected solutions and remove it from the original list
        selectedSolutions = [normalizedSolutions[solutionIndex]]
        deleteat!(normalizedSolutions, solutionIndex)

        # Step 4. Find the solution having the largest distance to the selected solutions
        while length(selectedSolutions) < numberOfSolutionsToSelect
            for solution in normalizedSolutions
                solution.attributes["SUBSET_SELECTION_DISTANCE"] = minimum(norm(solution.objectives - selectedSolutions[i].objectives) for i in 1:length(selectedSolutions))
            end

            _, indexOfTheSolutionHavingTheLargestDistance = findmax([solution.attributes["SUBSET_SELECTION_DISTANCE"] for solution in normalizedSolutions])
            push!(selectedSolutions, normalizedSolutions[indexOfTheSolutionHavingTheLargestDistance])
            deleteat!(normalizedSolutions, indexOfTheSolutionHavingTheLargestDistance)
        end

        # Step 5. Return the selected solutions
        return [solutions[solution.attributes["INDEX"]] for solution in selectedSolutions]
    end
end