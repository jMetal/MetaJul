###########################################################
# Binary solutions
###########################################################

struct BitVector
    bits::Vector{Bool}
end

function Base.length(bitVector::BitVector)::Int
    return length(bitVector.bits)
end

function toString(bitVector::BitVector)::String
    string = ""
    for i in bitVector.bits
        if i
            string = string * '1'
        else
            string = string * '0'
        end
    end
    return string
end

function initBitVector(zeroAndOneString::String)::BitVector
    bits::Vector{Bool} = []
    for char in zeroAndOneString
        if char == '0'
            push!(bits, false)
        else
            push!(bits, true)
        end
    end

    return BitVector(bits)
end

function initBitVector(length::Integer)::BitVector
    bits::Vector{Bool} = []
    for i in range(1, length)
        if rand() < 0.5
            push!(bits, false)
        else
            push!(bits, true)
        end
    end

    return BitVector(bits)
end

function bitFlip(bitVector::BitVector, index::Int)::BitVector
    if bitVector.bits[index]
        bitVector.bits[index] = false
    else
        bitVector.bits[index] = true
    end
    return bitVector
end

mutable struct BinarySolution <: Solution
    variables::BitVector
    objectives::Array{Real}
    constraints::Array{Real}
    attributes::Dict
end

function copySolution(solution::BinarySolution)::BinarySolution
    return BinarySolution(
        deepcopy(solution.variables),
        copy(solution.objectives),
        copy(solution.constraints),
        Dict(),
    )
end

function Base.isequal(solution1::BinarySolution, solution2::BinarySolution)::Bool
    return solution1.variables.bits == solution2.variables.bits
end

function Base.length(solution::BinarySolution)::Int
    return length(solution.bits)
end

