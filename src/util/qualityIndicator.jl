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

# Examples
```julia
front = [1.0 2.0; 2.0 1.0]
reference_front = [0.5 1.5; 1.5 0.5]
ε = additive_epsilon(front, reference_front)
```

# Reference
E. Zitzler, L. Thiele, M. Laumanns, C.M. Fonseca, V.G. Da Fonseca (2003): 
Performance Assessment of Multiobjective Optimizers: An Analysis and Review. 
IEEE Transactions on Evolutionary Computation, 7(2), 117-132.
"""
function additive_epsilon(front::AbstractMatrix, reference_front::AbstractMatrix)
    if size(front, 2) != size(reference_front, 2)
        throw(AssertionError("Dimension mismatch"))
    end
    if size(front, 1) == 0 || size(reference_front, 1) == 0
        throw(BoundsError("Empty matrices not supported"))
    end
    maximum_epsilon = -Inf
    for reference_row in eachrow(reference_front)
        # For each reference point, find the minimum over the front of the maximum objective-wise difference
        minimum_epsilon = minimum(
            maximum(solution_row .- reference_row) for solution_row in eachrow(front)
        )
        maximum_epsilon = max(maximum_epsilon, minimum_epsilon)
    end
    return maximum_epsilon
end

"""
    AdditiveEpsilonIndicator <: QualityIndicator

A quality indicator that computes the additive epsilon metric between two Pareto fronts.
The additive epsilon indicator measures the minimum additive factor needed to weakly dominate 
a reference front with a solution front.

# Properties
- Returns "EP" as name
- Is a minimization indicator (lower values are better)
- Computes additive epsilon as defined by Zitzler et al. (2003)

# Usage
```julia
indicator = AdditiveEpsilonIndicator()
value = compute(indicator, solution_front, reference_front)
```
"""
struct AdditiveEpsilonIndicator <: QualityIndicator
end

# Properties
name(::AdditiveEpsilonIndicator) = "EP"
description(::AdditiveEpsilonIndicator) = "Additive epsilon quality indicator"
is_minimization(::AdditiveEpsilonIndicator) = true

"""
    compute(indicator::AdditiveEpsilonIndicator, front::AbstractMatrix, reference_front::AbstractMatrix) -> Float64

Computes the additive epsilon indicator value using the provided indicator configuration.

# Arguments
- `indicator`: The AdditiveEpsilonIndicator instance
- `front`: Solution front matrix (each row is a solution)
- `reference_front`: Reference front matrix (each row is a solution)

# Returns
- The additive epsilon indicator value
"""
function compute(::AdditiveEpsilonIndicator, front::AbstractMatrix, reference_front::AbstractMatrix)
    return additive_epsilon(front, reference_front)
end

"""
    euclidean_distance(vec1::AbstractVector, vec2::AbstractVector) -> Float64

Computes the Euclidean distance between two vectors.

# Arguments
- `vec1`: First vector
- `vec2`: Second vector (must have same length as vec1)

# Returns
- The Euclidean distance between the two vectors

# Examples
```julia
distance = euclidean_distance([1.0, 2.0], [3.0, 4.0])  # Returns √8 ≈ 2.828
```
"""
function euclidean_distance(vector1::AbstractVector, vector2::AbstractVector)
    @assert length(vector1) == length(vector2) "Vectors must have the same length"
    return norm(vector1 .- vector2)
end

"""
    distance_to_closest_vector(vector::AbstractVector, front::AbstractMatrix) -> Float64

Returns the minimum Euclidean distance from a given vector to any row in a front matrix.

# Arguments
- `vector`: The reference vector
- `front`: Matrix where each row represents a point in the front

# Returns
- The minimum Euclidean distance to the closest point in the front

# Examples
```julia
vector = [1.0, 1.0]
front = [0.0 0.0; 2.0 2.0; 1.5 1.5]
minimum_distance = distance_to_closest_vector(vector, front)
```
"""
function distance_to_closest_vector(vector::AbstractVector, front::AbstractMatrix)
    @assert size(front, 2) == length(vector) "Dimension mismatch"
    minimum_distance = Inf
    for front_row in eachrow(front)
        current_distance = euclidean_distance(vector, front_row)
        if current_distance < minimum_distance
            minimum_distance = current_distance
        end
    end
    return minimum_distance
end

"""
    inverted_generational_distance(front::AbstractMatrix, reference_front::AbstractMatrix; pow=2.0) -> Float64

Computes the Inverted Generational Distance (IGD) between a solution front and a reference front.
IGD measures the average distance from each point in the reference front to the closest point in the solution front.

# Arguments
- `front`: Solution front matrix (each row is a solution)
- `reference_front`: Reference front matrix (each row is a solution)
- `pow`: Power parameter for the Lp-norm (default: 2.0 for Euclidean distance)

# Returns
- The IGD indicator value

# Examples
```julia
front = [1.0 2.0; 2.0 1.0]
reference_front = [0.5 1.5; 1.5 0.5]
igd_value = inverted_generational_distance(front, reference_front)
```

# Reference
Van Veldhuizen, D.A., Lamont, G.B. (1998): Multiobjective Evolutionary Algorithm Research: 
A History and Analysis. Technical Report TR-98-03, Dept. Elec. Comput. Eng., 
Air Force Inst. Technol.
"""
function inverted_generational_distance(front::AbstractMatrix, reference_front::AbstractMatrix; pow=2.0)
    @assert size(front, 2) == size(reference_front, 2) "Fronts must have the same number of objectives"
    sum_of_distances = 0.0
    for reference_row in eachrow(reference_front)
        distance = distance_to_closest_vector(reference_row, front)
        sum_of_distances += distance^pow
    end
    mean_of_distances = sum_of_distances / size(reference_front, 1)
    return mean_of_distances^(1/pow)
end

"""
    InvertedGenerationalDistanceIndicator <: QualityIndicator

A quality indicator that computes the Inverted Generational Distance (IGD) between two Pareto fronts.
IGD measures how well a solution front covers a reference front by computing the average distance 
from reference points to their closest solution points.

# Fields
- `pow::Float64`: Power parameter for the Lp-norm (default: 2.0)

# Properties
- Returns "IGD" as name
- Is a minimization indicator (lower values are better)
- Uses configurable power parameter for distance calculation

# Usage
```julia
indicator = InvertedGenerationalDistanceIndicator()  # Uses pow=2.0
indicator_l1 = InvertedGenerationalDistanceIndicator(pow=1.0)  # Uses L1 norm
value = compute(indicator, solution_front, reference_front)
```
"""
struct InvertedGenerationalDistanceIndicator <: QualityIndicator
    pow::Float64
    InvertedGenerationalDistanceIndicator(; pow=2.0) = new(pow)
end

name(::InvertedGenerationalDistanceIndicator) = "IGD"
description(::InvertedGenerationalDistanceIndicator) = "Inverted generational distance quality indicator"
is_minimization(::InvertedGenerationalDistanceIndicator) = true

"""
    compute(indicator::InvertedGenerationalDistanceIndicator, front::AbstractMatrix, reference_front::AbstractMatrix) -> Float64

Computes the IGD indicator value using the provided indicator configuration.

# Arguments
- `indicator`: The InvertedGenerationalDistanceIndicator instance
- `front`: Solution front matrix (each row is a solution)
- `reference_front`: Reference front matrix (each row is a solution)

# Returns
- The IGD indicator value using the configured power parameter
"""
function compute(indicator::InvertedGenerationalDistanceIndicator, front::AbstractMatrix, reference_front::AbstractMatrix)
    return inverted_generational_distance(front, reference_front; pow=indicator.pow)
end