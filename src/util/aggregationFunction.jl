abstract type AggregationFunction end

# Define the WeightedSum struct
struct WeightedSum <: AggregationFunction
    normalizeObjectives::Bool
    epsilon::Float64

    WeightedSum() = new(true,  1e-15)
    WeightedSum(normalize, epsilonValue) = new(normalize, epsilonValue)
end

# Compute function
function compute(
    aggFunction::WeightedSum, vector::Vector{Float64}, weightVector::Vector{Float64}, idealPoint::IdealPoint, nadirPoint::NadirPoint)
    sum = 0.0
    for n in 1:length(vector)
        tmpValue = if aggFunction.normalizeObjectives
            (vector[n] - value(idealPoint, n)) /
            (value(nadirPoint, n) - value(idealPoint, n) + aggFunction.epsilon)
        else
            vector[n]
        end
        sum += weightVector[n] * tmpValue
    end
    return sum
end

# Define the PenaltyBoundaryIntersection struct
struct PenaltyBoundaryIntersection <: AggregationFunction
    normalizeObjectives::Bool
    epsilon::Float64
    theta::Float64

    PenaltyBoundaryIntersection() = new(false, 1e-6, 5.0)
    PenaltyBoundaryIntersection(theta::Float64, normalizeObjectives::Bool) = new(normalizeObjectives, 1e-6, theta)
end

# Compute function
function compute(
    aggFunction::PenaltyBoundaryIntersection, vector::Vector{Float64}, weightVector::Vector{Float64},
    idealPoint::IdealPoint, nadirPoint::NadirPoint
)
    d1 = 0.0
    d2 = 0.0
    nl = 0.0

    # Calculate d1 and nl
    for i in 1:length(vector)
        tmpValue = if aggFunction.normalizeObjectives
            (vector[i] - value(idealPoint, i)) / 
            (value(nadirPoint, i) - value(idealPoint, i) + aggFunction.epsilon)
        else
            vector[i] - value(idealPoint, i)
        end
        d1 += tmpValue * weightVector[i]
        nl += weightVector[i]^2
    end

    nl = sqrt(nl)
    d1 = abs(d1) / nl

    # Calculate d2
    for i in 1:length(vector)
        tmpValue = if aggFunction.normalizeObjectives
            (vector[i] - value(idealPoint, i)) / 
            (value(nadirPoint, i) - value(idealPoint, i))
        else
            vector[i] - value(idealPoint, i)
        end
        d2 += (tmpValue - d1 * (weightVector[i] / nl))^2
    end
    d2 = sqrt(d2)

    return d1 + aggFunction.theta * d2
end
