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

