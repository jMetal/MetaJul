
include("bounds.jl")

abstract type Solution end

mutable struct ContinuousSolution{T <: Number} <: Solution 
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
        deepcopy(solution.attributes),
        solution.bounds
    )
end

function Base.isequal(solution1::ContinuousSolution, solution2::ContinuousSolution)::Bool
    return Base.isequal(solution1.variables, solution2.variables)
end

###########################################################
struct BitVector 
    bits::Vector{Bool}
end

function initBitVector(zeroAndOneString::String) ::  BitVector
    bits::Vector{Bool}
    for char in zeroAndOneString
        if (char == '0')
            bits.add(False)
        else
            bits.add(True)
    end

    return BitVector(bits)
end

mutable struct BinarySolution <: Solution
    variables::BitVector
    objectives::Array{Real}
    constraints::Array{Real}
    attributes::Dict
end

function copySolution(solution::BinarySolution{})::BinarySolution{}
    return ContinuousSolution{}(
        deepcopy(solution.variables),
        copy(solution.objectives),
        copy(solution.constraints),
        deepcopy(solution.attributes),
    )
end

