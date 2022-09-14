
include("bounds.jl")

abstract type Solution end

mutable struct ContinuousSolution{T <: Number} <: Solution 
    variables::Array{T}
    objectives::Array{Float64}
    constraints::Array{Float64}
    attributes::Dict
    bounds::Array{Bounds{T}}
end

function copySolution(solution::ContinuousSolution{})::ContinuousSolution{}
    return ContinuousSolution{}(
        deepcopy(solution.variables),
        copy(solution.objectives),
        copy(solution.constraints),
        deepcopy(solution.attributes),
        solution.bounds
    )
end

