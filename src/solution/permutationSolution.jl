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
end

function copySolution(solution::PermutationSolution)::PermutationSolution
    return PermutationSolution(
        deepcopy(solution.variables),
        copy(solution.objectives),
        copy(solution.constraints),
        Dict()
    )
end

function Base.isequal(solution1::ContinuousSolution, solution2::ContinuousSolution)::Bool
    return Base.isequal(solution1.variables, solution2.variables)
end
