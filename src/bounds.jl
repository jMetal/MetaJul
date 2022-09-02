# Struct describing a pair of lower and upper bounds for a number value

struct Bounds{T <: Number}
    lowerBound::T
    upperBound::T

    Bounds{T}(lowerBound, upperBound) where {T} = lowerBound >= upperBound ? error("The lower bound ", lowerBound, " is higher than the upper bound ", upperBound) : new(lowerBound, upperBound)
end


function restrict(value::Number, bounds::Bounds)::Number
    if (value < bounds.lowerBound)
        return bounds.lowerBound 
    end
    if (value > bounds.upperBound)
        return bounds.upperBound
    end
end

function valueIsWithinBounds(value::Number, bounds::Bounds)::Bool
    return value >= bounds.lowerBound && value <= bounds.upperBound 
end
