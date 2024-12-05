abstract type AggregationFunction end

"""
    struct WeightedSum <: AggregationFunction

Represents the weighted sum aggregation function for multi-objective optimization.

# Fields
- `normalizeObjectives::Bool`: Whether to normalize the objectives.
- `epsilon::Float64`: A small constant to avoid division by zero in normalization.

# Constructors
- `WeightedSum()`: Creates a `WeightedSum` object with default settings (no normalization and epsilon of 0).
- `WeightedSum(normalizeObjectives::Bool, epsilon::Float64)`: Creates a `WeightedSum` object with the specified normalization setting and epsilon value.
"""
struct WeightedSum <: AggregationFunction
    normalizeObjectives::Bool
    epsilon::Float64

    WeightedSum() = new(false, 0.0)
    WeightedSum(normalizeObjectives::Bool, epsilon::Float64) = new(normalizeObjectives, epsilon)
end

"""
    compute(aggFunction::WeightedSum, vector::Vector{Float64}, weightVector::Vector{Float64}, 
            idealPoint::IdealPoint, nadirPoint::NadirPoint) -> Float64

Computes the weighted sum aggregation function using the formula:
`sum(weightVector[n] * value)`, where `value` is optionally normalized.

# Arguments
- `aggFunction::WeightedSum`: The weighted sum aggregation function object.
- `vector::Vector{Float64}`: The input vector to be aggregated.
- `weightVector::Vector{Float64}`: The weight vector to be used in the aggregation.
- `idealPoint::IdealPoint`: The ideal point for normalization.
- `nadirPoint::NadirPoint`: The nadir point for normalization.

# Returns
- `Float64`: The result of the weighted sum aggregation function.
"""
function compute(
    aggFunction::WeightedSum, vector::Vector{Float64}, weightVector::Vector{Float64}, idealPoint::IdealPoint, nadirPoint::NadirPoint) :: Float64
    sum = 0.0
    for n in 1:length(vector)
        tmpValue = if aggFunction.normalizeObjectives
            (vector[n] - value(idealPoint, n)) / (value(nadirPoint, n) - value(idealPoint, n) + aggFunction.epsilon)
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


"""
    struct Tschebyscheff <: AggregationFunction

Represents the Tschebyscheff aggregation function for multi-objective optimization.

# Fields
- `normalizeObjectives::Bool`: Whether to normalize the objectives.
- `epsilon::Float64`: A small constant to avoid division by zero in normalization.

# Constructors
- `Tschebyscheff(normalizeObjectives::Bool)`: Creates a `Tschebyscheff` object with the specified normalization setting and a default `epsilon` of 1e-6.
"""
struct Tschebyscheff <: AggregationFunction
    normalizeObjectives::Bool
    epsilon::Float64

    Tschebyscheff() = new(false, 0.0)
    Tschebyscheff(normalizeObjectives::Bool, epsilon::Float64) = new(normalizeObjectives, epsilon)

end

"""
    compute(aggFunction::Tschebyscheff, vector::Vector{Float64}, weightVector::Vector{Float64}, 
            idealPoint::IdealPoint, nadirPoint::NadirPoint) -> Float64

Computes the Tschebyscheff aggregation function using the formula:
`max(|vector[n] - idealPoint.value(n)| * weightVector[n])`.
If `weightVector[n]` is equal to 0, `feval` is set to `0.0001 * diff`.

# Arguments
- `aggFunction::Tschebyscheff`: The Tschebyscheff aggregation function object.
- `vector::Vector{Float64}`: The input vector to be aggregated.
- `weightVector::Vector{Float64}`: The weight vector to be used in the aggregation.
- `idealPoint::IdealPoint`: The ideal point for normalization.
- `nadirPoint::NadirPoint`: The nadir point for normalization.

# Returns
- `Float64`: The result of the Tschebyscheff aggregation function.
"""
function compute(
    aggFunction::Tschebyscheff, vector::Vector{Float64}, weightVector::Vector{Float64}, idealPoint::IdealPoint, nadirPoint::NadirPoint) :: Float64
    maxFun = -1.0e30
    for n in 1:length(vector)
        diff = if aggFunction.normalizeObjectives
            abs((vector[n] - value(idealPoint, n)) / (value(nadirPoint, n) - value(idealPoint, n) + aggFunction.epsilon))
        else
            abs(vector[n] - value(idealPoint, n))
        end

        feval = if weightVector[n] == 0
            0.0001 * diff
        else
            diff * weightVector[n]
        end

        if feval > maxFun
            maxFun = feval
        end
    end
    return maxFun
end