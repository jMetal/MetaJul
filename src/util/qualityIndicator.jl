using LinearAlgebra

"""
    additive_epsilon(front::AbstractMatrix, reference_front::AbstractMatrix) -> Float64

Computes the additive epsilon indicator between two fronts, following the definition of Zitzler et al. (2003).
The returned value is the minimum value ε such that, for each point in the reference front, there exists a point in the solution front shifted by ε that weakly dominates the reference point (assuming minimization).

# Arguments
- `front`: Solution front matrix (each row is a solution).
- `reference_front`: Reference front matrix (each row is a solution).

# Returns
- The value of the additive epsilon indicator.

# Reference
E. Zitzler et al. (2003): Performance Assessment of Multiobjective Optimizers: An Analysis and Review.
"""
function additive_epsilon(front::AbstractMatrix, reference_front::AbstractMatrix)
    max_eps = -Inf
    for ref_row in eachrow(reference_front)
        # For each reference point, find the minimum over the front of the maximum objective-wise difference
        min_eps = minimum(
            maximum(sol_row .- ref_row) for sol_row in eachrow(front)
        )
        max_eps = max(max_eps, min_eps)
    end
    return max_eps
end

struct AdditiveEpsilonIndicator <: QualityIndicator
end

# Properties
name(::AdditiveEpsilonIndicator) = "EP"
description(::AdditiveEpsilonIndicator) = "Additive epsilon quality indicator"
is_minimization(::AdditiveEpsilonIndicator) = true

# Usage: indicator = AdditiveEpsilonIndicator()
#        value = compute(indicator, front, reference_front)
function compute(::AdditiveEpsilonIndicator, front::AbstractMatrix, reference_front::AbstractMatrix)
    # Your existing additive_epsilon implementation here
    # For example:
    return additive_epsilon(front, reference_front)
end

"""
    euclidean_distance(vec1::AbstractVector, vec2::AbstractVector) -> Float64

Computes the Euclidean distance between two vectors.
"""
function euclidean_distance(vec1::AbstractVector, vec2::AbstractVector)
    @assert length(vec1) == length(vec2) "Vectors must have the same length"
    return norm(vec1 .- vec2)
end

"""
    distance_to_closest_vector(vector::AbstractVector, front::AbstractMatrix) -> Float64

Returns the minimum Euclidean distance from `vector` to any row in `front`.
"""
function distance_to_closest_vector(vector::AbstractVector, front::AbstractMatrix)
    @assert size(front, 2) == length(vector) "Dimension mismatch"
    min_dist = Inf
    for row in eachrow(front)
        d = euclidean_distance(vector, row)
        if d < min_dist
            min_dist = d
        end
    end
    return min_dist
end

"""
    inverted_generational_distance(front::AbstractMatrix, reference_front::AbstractMatrix; pow=2.0) -> Float64

Computes the Inverted Generational Distance (IGD) between a solution front and a reference front.
"""
function inverted_generational_distance(front::AbstractMatrix, reference_front::AbstractMatrix; pow=2.0)
    @assert size(front, 2) == size(reference_front, 2) "Fronts must have the same number of objectives"
    sum_of_distances = 0.0
    for ref_row in eachrow(reference_front)
        distance = distance_to_closest_vector(ref_row, front)
        sum_of_distances += distance^pow
    end
    sum_of_distances = sum_of_distances^(1/pow)
    return sum_of_distances / size(reference_front, 1)
end

struct InvertedGenerationalDistanceIndicator <: QualityIndicator
    pow::Float64
    InvertedGenerationalDistanceIndicator(; pow=2.0) = new(pow)
end

name(::InvertedGenerationalDistanceIndicator) = "IGD"
description(::InvertedGenerationalDistanceIndicator) = "Inverted generational distance quality indicator"
is_minimization(::InvertedGenerationalDistanceIndicator) = true

function compute(indicator::InvertedGenerationalDistanceIndicator, front::AbstractMatrix, reference_front::AbstractMatrix)
    return inverted_generational_distance(front, reference_front; pow=indicator.pow)
end