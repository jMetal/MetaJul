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