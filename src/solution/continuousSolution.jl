###########################################################
# Continuous solutions
###########################################################

mutable struct ContinuousSolution{T<:Number} <: Solution
    variables::Array{T}
    objectives::Array{Real}
    constraints::Array{Real}
    attributes::Dict
    bounds::Array{Bounds{T}}
end

function copySolution(solution::ContinuousSolution{})::ContinuousSolution{}
    return ContinuousSolution{}(
        deepcopy(solution.variables),
        copy(solution.objectives),
        copy(solution.constraints),
        Dict(),
        solution.bounds
    )
end

function Base.isequal(solution1::ContinuousSolution, solution2::ContinuousSolution)::Bool
    return Base.isequal(solution1.variables, solution2.variables)
end
