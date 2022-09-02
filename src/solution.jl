
include("bounds.jl")

abstract type Solution end

mutable struct ContinuousSolution{T <: Number} <: Solution 
    variables::Array{T}
    objectives::Array{Float64}
    attributes::Dict
    bounds::Array{Bounds{T}}
end
