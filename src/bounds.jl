# Struct describing a pair of lower and upper bounds for a number value

struct Bounds{T <: Number}
    lowerBound::T
    upperBound::T

    Bounds{T}(lowerBound, upperBound) where {T} = lowerBound >= upperBound ? error("The lower bound ", lowerBound, " is higher than the upper bound ", upperBound) : new(lowerBound, upperBound)
end

function createBounds(lowerBounds::Vector{T}, upperBounds::Vector{T}) where {T <: Number}
    if length(lowerBounds) != length(upperBounds)
        error("The length of the lowerbound and upperbound arrays are different: ", length(lowerBounds), ", ", length(upperBounds))
    end

    return [Bounds{T}(lowerBounds[i], upperBounds[i]) for i = 1:length(lowerBounds) ]

end

function restrict(value::Number, bounds::Bounds)::Number
    result = value
    if (value < bounds.lowerBound)
        result = bounds.lowerBound 
    elseif (value > bounds.upperBound)
        result = bounds.upperBound
    end
    return result 
end

function restrict(values::Vector{T}, bounds::Array{Bounds{T}}) where {T <: Number}
    for i in 1:length(values)
        values[i] = restrict(values[i], bounds[i])
    end

    return values
end

function valueIsWithinBounds(value::Number, bounds::Bounds)::Bool
    return value >= bounds.lowerBound && value <= bounds.upperBound 
end
