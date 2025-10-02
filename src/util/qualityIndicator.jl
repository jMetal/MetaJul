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
    sum_root = sum_of_distances^(1/pow)
    return sum_root / size(reference_front, 1)
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

"""
    dominance_distance(vector1::AbstractVector, vector2::AbstractVector) -> Float64

Computes the dominance distance between two vectors used in the IGD+ indicator.
The dominance distance is the Euclidean distance considering only the objectives 
where vector2 is worse than vector1 (i.e., max(vector2[i] - vector1[i], 0)).

# Arguments
- `vector1`: First vector (reference point)
- `vector2`: Second vector (solution point)

# Returns
- The dominance distance between the two vectors

# Examples
```julia
ref_point = [1.0, 2.0]
solution_point = [1.5, 1.8]
dist = dominance_distance(ref_point, solution_point)  # Only considers worse objectives
```

# Reference
Ishibuchi et al. (2015): "A Study on Performance Evaluation Ability of a Modified
Inverted Generational Distance Indicator", GECCO 2015
"""
function dominance_distance(vector1::AbstractVector, vector2::AbstractVector)
    @assert length(vector1) == length(vector2) "Vectors must have the same length"
    distance_squared = 0.0
    for i in 1:length(vector1)
        maximum_difference = max(vector2[i] - vector1[i], 0.0)
        distance_squared += maximum_difference^2
    end
    return sqrt(distance_squared)
end

"""
    distance_to_closest_vector_with_dominance_distance(vector::AbstractVector, front::AbstractMatrix) -> Float64

Returns the minimum dominance distance from a given vector to any row in a front matrix.
This function is used specifically for the IGD+ indicator.

# Arguments
- `vector`: The reference vector
- `front`: Matrix where each row represents a point in the front

# Returns
- The minimum dominance distance to the closest point in the front

# Examples
```julia
vector = [1.0, 1.0]
front = [0.5 0.5; 1.2 0.8; 0.9 1.1]
min_dist = distance_to_closest_vector_with_dominance_distance(vector, front)
```
"""
function distance_to_closest_vector_with_dominance_distance(vector::AbstractVector, front::AbstractMatrix)
    @assert size(front, 2) == length(vector) "Dimension mismatch"
    minimum_distance = Inf
    for front_row in eachrow(front)
        current_distance = dominance_distance(vector, front_row)
        if current_distance < minimum_distance
            minimum_distance = current_distance
        end
    end
    return minimum_distance
end

"""
    inverted_generational_distance_plus(front::AbstractMatrix, reference_front::AbstractMatrix) -> Float64

Computes the Inverted Generational Distance Plus (IGD+) between a solution front and a reference front.
IGD+ is an improved version of IGD that uses dominance-based distance calculation, making it more
robust when the reference front is not optimal.

# Arguments
- `front`: Solution front matrix (each row is a solution)
- `reference_front`: Reference front matrix (each row is a solution)

# Returns
- The IGD+ indicator value

# Examples
```julia
front = [1.0 2.0; 2.0 1.0]
reference_front = [0.5 1.5; 1.5 0.5]
igdplus_value = inverted_generational_distance_plus(front, reference_front)
```

# Reference
Ishibuchi et al. (2015): "A Study on Performance Evaluation Ability of a Modified
Inverted Generational Distance Indicator", GECCO 2015
"""
function inverted_generational_distance_plus(front::AbstractMatrix, reference_front::AbstractMatrix)
    @assert size(front, 2) == size(reference_front, 2) "Fronts must have the same number of objectives"
    sum_of_distances = 0.0
    for reference_row in eachrow(reference_front)
        distance = distance_to_closest_vector_with_dominance_distance(reference_row, front)
        sum_of_distances += distance
    end
    return sum_of_distances / size(reference_front, 1)
end

"""
    InvertedGenerationalDistancePlusIndicator <: QualityIndicator

A quality indicator that computes the Inverted Generational Distance Plus (IGD+) between two Pareto fronts.
IGD+ improves upon the standard IGD by using dominance-based distance calculation, making it more
suitable for cases where the reference front may not be optimal.

# Properties
- Returns "IGD+" as name
- Is a minimization indicator (lower values are better)
- Uses dominance distance instead of Euclidean distance

# Usage
```julia
indicator = InvertedGenerationalDistancePlusIndicator()
value = compute(indicator, solution_front, reference_front)
```

# Reference
Ishibuchi et al. (2015): "A Study on Performance Evaluation Ability of a Modified
Inverted Generational Distance Indicator", GECCO 2015
"""
struct InvertedGenerationalDistancePlusIndicator <: QualityIndicator
end

name(::InvertedGenerationalDistancePlusIndicator) = "IGD+"
description(::InvertedGenerationalDistancePlusIndicator) = "Inverted Generational Distance+"
is_minimization(::InvertedGenerationalDistancePlusIndicator) = true

"""
    compute(indicator::InvertedGenerationalDistancePlusIndicator, front::AbstractMatrix, reference_front::AbstractMatrix) -> Float64

Computes the IGD+ indicator value using the provided indicator configuration.

# Arguments
- `indicator`: The InvertedGenerationalDistancePlusIndicator instance
- `front`: Solution front matrix (each row is a solution)
- `reference_front`: Reference front matrix (each row is a solution)

# Returns
- The IGD+ indicator value
"""
function compute(indicator::InvertedGenerationalDistancePlusIndicator, front::AbstractMatrix, reference_front::AbstractMatrix)
    return inverted_generational_distance_plus(front, reference_front)
end

"""
    hypervolume(front::AbstractMatrix, reference_point::AbstractVector) -> Float64

Computes the hypervolume (HV) indicator for a given front and reference point.
The hypervolume is the volume of the objective space dominated by the front and bounded
by the reference point. This implementation uses the WFG algorithm for efficient computation.

# Arguments
- `front`: Solution front matrix (each row is a solution)
- `reference_point`: Reference point that bounds the hypervolume calculation

# Returns
- The hypervolume indicator value

# Examples
```julia
front = [1.0 2.0; 2.0 1.0; 1.5 1.5]
reference_point = [3.0, 3.0]
hv_value = hypervolume(front, reference_point)
```
"""
function hypervolume(front::AbstractMatrix, reference_point::AbstractVector)
    @assert size(front, 2) == length(reference_point) "Dimension mismatch"
    @assert size(front, 1) > 0 "Front cannot be empty"
    # Check that all points dominate the reference point (are better)
    for row in eachrow(front)
        if any(row .>= reference_point)
            throw(ArgumentError("All front points must dominate the reference point (be strictly better)"))
        end
    end
    # Convert to maximization problem by negating objectives
    negated_front = -front
    negated_reference = -reference_point
    return wfg_hypervolume(negated_front, negated_reference)
end

"""
    wfg_hypervolume(front::AbstractMatrix, reference_point::AbstractVector) -> Float64

Implements the WFG (While, Fieldsend, Garside) algorithm for hypervolume calculation.
This is an efficient algorithm for computing hypervolume, especially for higher dimensions.

# Arguments
- `front`: Front matrix where each row is a point (assuming maximization)
- `reference_point`: Reference point for hypervolume calculation

# Returns
- The hypervolume value
"""
function wfg_hypervolume(front::AbstractMatrix, reference_point::AbstractVector)
    n_points, n_objectives = size(front)
    if n_objectives == 1
        sorted_points = sort(front[:, 1], rev=true)
        volume = 0.0
        prev_point = reference_point[1]
        for point in sorted_points
            if point > prev_point
                volume += point - prev_point
                prev_point = point
            end
        end
        return volume
    end
    if n_points == 0
        return 0.0
    end
    if n_points == 1
        return prod(reference_point .- front[1, :])
    end
    # Remove dominated points to improve efficiency
    non_dominated_indices = Int[]
    for i in 1:n_points
        is_dominated = false
        for j in 1:n_points
            if i != j && all(front[j, :] .>= front[i, :]) && any(front[j, :] .> front[i, :])
                is_dominated = true
                break
            end
        end
        if !is_dominated
            push!(non_dominated_indices, i)
        end
    end
    if length(non_dominated_indices) == 0
        return 0.0
    end
    non_dominated_front = front[non_dominated_indices, :]
    n_points = size(non_dominated_front, 1)
    sorted_indices = sortperm(non_dominated_front[:, end], rev=true)
    sorted_front = non_dominated_front[sorted_indices, :]
    volume = 0.0
    prev_point_last_obj = reference_point[end]
    for i in 1:n_points
        current_point = sorted_front[i, :]
        current_last_obj = current_point[end]
        if current_last_obj <= prev_point_last_obj
            continue
        end
        contribution_height = current_last_obj - prev_point_last_obj
        reduced_front = Matrix{Float64}(undef, 0, n_objectives - 1)
        for j in (i+1):n_points
            candidate = sorted_front[j, :]
            reduced_point = min.(candidate[1:end-1], current_point[1:end-1])
            reduced_front = vcat(reduced_front, reduced_point')
        end
        reduced_reference = reference_point[1:end-1]
        if size(reduced_front, 1) > 0
            reduced_volume = wfg_hypervolume(reduced_front, reduced_reference)
        else
            reduced_volume = prod(reduced_reference .- current_point[1:end-1])
        end
        volume += contribution_height * reduced_volume
        prev_point_last_obj = current_last_obj
    end
    return volume
end

"""
    HypervolumeIndicator <: QualityIndicator

A quality indicator that computes the hypervolume (HV) between a Pareto front and a reference point.
The hypervolume measures the volume of the objective space that is dominated by the front and
bounded by the reference point. Higher values indicate better performance.

# Fields
- `reference_point::Vector{Float64}`: The reference point for hypervolume calculation

# Properties
- Returns "HV" as name
- Is a maximization indicator (higher values are better)
- Requires a reference point that is dominated by all solutions

# Usage
```julia
reference_point = [10.0, 10.0]  # Should be worse than all solutions
indicator = HypervolumeIndicator(reference_point)
value = compute(indicator, solution_front)
```
"""
struct HypervolumeIndicator <: QualityIndicator
    reference_point::Vector{Float64}
    function HypervolumeIndicator(reference_point::AbstractVector)
        new(collect(Float64, reference_point))
    end
end

name(::HypervolumeIndicator) = "HV"
description(::HypervolumeIndicator) = "Hypervolume quality indicator"
is_minimization(::HypervolumeIndicator) = false  # Higher values are better

"""
    compute(indicator::HypervolumeIndicator, front::AbstractMatrix) -> Float64

Computes the hypervolume indicator value for a single front using the configured reference point.

# Arguments
- `indicator`: The HypervolumeIndicator instance with reference point
- `front`: Solution front matrix (each row is a solution)

# Returns
- The hypervolume indicator value
"""
function compute(indicator::HypervolumeIndicator, front::AbstractMatrix)
    return hypervolume(front, indicator.reference_point)
end

"""
    compute(indicator::HypervolumeIndicator, front::AbstractMatrix, reference_front::AbstractMatrix) -> Float64

Computes the hypervolume indicator value for a solution front. The reference front is ignored
since hypervolume only requires a reference point, not a reference front.

# Arguments
- `indicator`: The HypervolumeIndicator instance with reference point
- `front`: Solution front matrix (each row is a solution)
- `reference_front`: Ignored (hypervolume doesn't use reference fronts)

# Returns
- The hypervolume indicator value

# Note
This method ignores the reference_front parameter since hypervolume calculation
only requires a reference point, which is stored in the indicator itself.
"""
function compute(indicator::HypervolumeIndicator, front::AbstractMatrix, reference_front::AbstractMatrix)
    @warn "Hypervolume indicator ignores the reference front. Using stored reference point instead."
    return compute(indicator, front)
end

"""
    hypervolume_contribution(point::AbstractVector, front::AbstractMatrix, reference_point::AbstractVector) -> Float64

Computes the hypervolume contribution of a specific point to a front.
This is the additional hypervolume that would be gained by adding this point to the front.

# Arguments
- `point`: The point whose contribution is to be calculated
- `front`: The existing front matrix (each row is a solution)
- `reference_point`: Reference point for hypervolume calculation

# Returns
- The hypervolume contribution of the point

# Examples
```julia
point = [1.2, 1.8]
front = [1.0 2.0; 2.0 1.0]
reference_point = [3.0, 3.0]
contribution = hypervolume_contribution(point, front, reference_point)
```
"""
function hypervolume_contribution(point::AbstractVector, front::AbstractMatrix, reference_point::AbstractVector)
    extended_front = vcat(front, point')
    hv_with_point = hypervolume(extended_front, reference_point)
    hv_without_point = size(front, 1) > 0 ? hypervolume(front, reference_point) : 0.0
    return hv_with_point - hv_without_point
end

"""
    NormalizedHypervolumeIndicator <: QualityIndicator

A quality indicator that computes the normalized hypervolume between a Pareto front and a reference front.
It returns 1 - HV(front)/HV(referenceFront), so lower values are better and 0 means the front matches the reference front.

# Fields
- `reference_point::Vector{Float64}`: The reference point for hypervolume calculation

# Properties
- Returns "NormHV" as name
- Is a minimization indicator (lower values are better)
- Requires a reference point that is dominated by all solutions

# Usage
```julia
reference_point = [1.1, 1.1]  # Should be worse than all solutions
indicator = NormalizedHypervolumeIndicator(reference_point)
value = compute(indicator, solution_front, reference_front)
```
"""
struct NormalizedHypervolumeIndicator <: QualityIndicator
    reference_point::Vector{Float64}
    function NormalizedHypervolumeIndicator(reference_point::AbstractVector)
        new(collect(Float64, reference_point))
    end
end

name(::NormalizedHypervolumeIndicator) = "NormHV"
description(::NormalizedHypervolumeIndicator) = "Normalized hypervolume quality indicator (1 - HV(front)/HV(referenceFront))"
is_minimization(::NormalizedHypervolumeIndicator) = true

"""
    compute(indicator::NormalizedHypervolumeIndicator, front::AbstractMatrix, reference_front::AbstractMatrix) -> Float64

Computes the normalized hypervolume indicator value for a solution front and a reference front.

# Arguments
- `indicator`: The NormalizedHypervolumeIndicator instance with reference point
- `front`: Solution front matrix (each row is a solution)
- `reference_front`: Reference front matrix (each row is a solution)

# Returns
- The normalized hypervolume indicator value
"""
function compute(indicator::NormalizedHypervolumeIndicator, front::AbstractMatrix, reference_front::AbstractMatrix)
    hv_front = hypervolume(front, indicator.reference_point)
    hv_reference = hypervolume(reference_front, indicator.reference_point)
    if hv_reference == 0.0
        @warn "Reference front hypervolume is zero. Returning 1.0."
        return 1.0
    end
    return 1.0 - hv_front / hv_reference
end