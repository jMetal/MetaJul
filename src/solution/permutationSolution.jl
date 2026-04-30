###########################################################
# Permutation solutions
###########################################################

mutable struct PermutationSolution <: Solution
    variables::Vector{Int64}
    objectives::Vector{Float64}
    constraints::Vector{Float64}
    attributes::Dict{String,Any}

    function PermutationSolution(length::Int)
        variables = shuffle(1:length)
        new(variables, Float64[], Float64[], Dict{String,Any}())
    end

    function PermutationSolution(variables, objectives, constraints, attributes)
        new(variables, objectives, constraints, attributes)
    end
end

function copySolution(solution::PermutationSolution)::PermutationSolution
    return PermutationSolution(
        copy(solution.variables),
        copy(solution.objectives),
        copy(solution.constraints),
        Dict{String,Any}()
    )
end

function Base.isequal(solution1::PermutationSolution, solution2::PermutationSolution)::Bool
    return Base.isequal(solution1.variables, solution2.variables)
end

function checkIfPermutationIsValid(permutation::Array{Int})::Bool
    sortedValues = sort(permutation)
    orderedVector = collect(1:length(permutation))

    return sortedValues == orderedVector
end