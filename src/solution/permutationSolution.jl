###########################################################
# Permutation solutions
###########################################################

mutable struct PermutationSolution <: Solution
    variables::Array{Int64}
    objectives::Array{Real}
    constraints::Array{Real}
    attributes::Dict

    function PermutationSolution(length::Int)
        variables = shuffle(1:length)
        new(variables, Real[], Real[], Dict{Any, Any}())
    end

    function PermutationSolution(variables, objectives, constraints, attributes) 
        new(variables, objectives, constraints, attributes)
    end
end

function copySolution(solution::PermutationSolution)::PermutationSolution
    return PermutationSolution(
        deepcopy(solution.variables),
        copy(solution.objectives),
        copy(solution.constraints),
        Dict()
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