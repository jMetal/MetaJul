###########################################################
# Continuous solutions
###########################################################

mutable struct ContinuousSolution{T<:Number} <: Solution
    variables::Vector{T}
    objectives::Vector{Float64}
    constraints::Vector{Float64}
    attributes::Dict{String,Any}
    bounds::Vector{Bounds{T}}
end

function copySolution(solution::ContinuousSolution{T})::ContinuousSolution{T} where {T<:Number}
    return ContinuousSolution{T}(
        copy(solution.variables),
        copy(solution.objectives),
        copy(solution.constraints),
        Dict{String,Any}(),
        solution.bounds
    )
end

function Base.isequal(solution1::ContinuousSolution, solution2::ContinuousSolution)::Bool
    return Base.isequal(solution1.variables, solution2.variables)
end
