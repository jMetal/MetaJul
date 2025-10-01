using Statistics

"""
    normalize_fronts(front::AbstractMatrix, reference_front::AbstractMatrix; method=:reference_only) -> Tuple{Matrix{Float64}, Matrix{Float64}}

Normalizes both solution front and reference front to the same scale, typically [0,1] for each objective.
This ensures that quality indicators are not biased by objectives with different scales.

# Arguments
- `front`: Solution front matrix (each row is a solution)
- `reference_front`: Reference front matrix (each row is a solution)
- `method`: Normalization method (:minmax, :zscore, or :reference_only)

# Returns
- A tuple (normalized_front, normalized_reference_front) where both matrices are normalized

# Methods
- `:minmax`: Normalize to [0,1] using global min/max across both fronts
- `:zscore`: Standardize using global mean and standard deviation
- `:reference_only`: Normalize using only reference front bounds (recommended for quality indicators, default)

# Examples
```julia
front = [1.0 100.0; 2.0 200.0; 3.0 150.0]
reference_front = [0.5 80.0; 1.5 120.0; 2.5 180.0]
norm_front, norm_ref = normalize_fronts(front, reference_front)  # Uses :reference_only by default

# Using different methods
norm_front, norm_ref = normalize_fronts(front, reference_front; method=:minmax)
```

# Note
For quality indicators, `:reference_only` is typically recommended as it uses the reference front
to define the normalization bounds, which is more appropriate for performance assessment.
"""
function normalize_fronts(front::AbstractMatrix, reference_front::AbstractMatrix; method=:reference_only)
    @assert size(front, 2) == size(reference_front, 2) "Fronts must have the same number of objectives"
    
    number_of_objectives = size(front, 2)
    normalized_front = similar(front, Float64)
    normalized_reference_front = similar(reference_front, Float64)
    
    if method == :minmax
        # Use global min/max across both fronts
        combined_matrix = vcat(front, reference_front)
        
        for objective_index in 1:number_of_objectives
            objective_min = minimum(combined_matrix[:, objective_index])
            objective_max = maximum(combined_matrix[:, objective_index])
            objective_range = objective_max - objective_min
            
            if objective_range > 0
                # Normalize to [0,1]
                normalized_front[:, objective_index] = (front[:, objective_index] .- objective_min) ./ objective_range
                normalized_reference_front[:, objective_index] = (reference_front[:, objective_index] .- objective_min) ./ objective_range
            else
                # All values are the same
                normalized_front[:, objective_index] .= 0.0
                normalized_reference_front[:, objective_index] .= 0.0
            end
        end
        
    elseif method == :zscore
        # Standardize using global mean and standard deviation
        combined_matrix = vcat(front, reference_front)
        
        for objective_index in 1:number_of_objectives
            objective_mean = mean(combined_matrix[:, objective_index])
            objective_std = std(combined_matrix[:, objective_index])
            
            if objective_std > 0
                normalized_front[:, objective_index] = (front[:, objective_index] .- objective_mean) ./ objective_std
                normalized_reference_front[:, objective_index] = (reference_front[:, objective_index] .- objective_mean) ./ objective_std
            else
                # All values are the same
                normalized_front[:, objective_index] .= 0.0
                normalized_reference_front[:, objective_index] .= 0.0
            end
        end
        
    elseif method == :reference_only
        # Use only reference front to define normalization bounds (recommended for quality indicators)
        for objective_index in 1:number_of_objectives
            reference_min = minimum(reference_front[:, objective_index])
            reference_max = maximum(reference_front[:, objective_index])
            reference_range = reference_max - reference_min
            
            if reference_range > 0
                # Normalize using reference front bounds
                normalized_front[:, objective_index] = (front[:, objective_index] .- reference_min) ./ reference_range
                normalized_reference_front[:, objective_index] = (reference_front[:, objective_index] .- reference_min) ./ reference_range
            else
                # All reference values are the same
                normalized_front[:, objective_index] = front[:, objective_index] .- reference_min
                normalized_reference_front[:, objective_index] .= 0.0
            end
        end
        
    else
        throw(ArgumentError("Unknown normalization method: $method. Use :minmax, :zscore, or :reference_only"))
    end
    
    return normalized_front, normalized_reference_front
end

"""
    normalize_front(front::AbstractMatrix, bounds_min::Vector{Float64}, bounds_max::Vector{Float64}) -> Matrix{Float64}

Normalizes a front using predefined bounds for each objective.

# Arguments
- `front`: Front matrix to normalize (each row is a solution)
- `bounds_min`: Minimum values for each objective
- `bounds_max`: Maximum values for each objective

# Returns
- Normalized front matrix

# Examples
```julia
front = [1.0 100.0; 2.0 200.0]
min_bounds = [0.0, 50.0]
max_bounds = [5.0, 250.0]
normalized = normalize_front(front, min_bounds, max_bounds)
```
"""
function normalize_front(front::AbstractMatrix, bounds_min::Vector{Float64}, bounds_max::Vector{Float64})
    @assert size(front, 2) == length(bounds_min) == length(bounds_max) "Dimension mismatch"
    
    normalized_front = similar(front, Float64)
    number_of_objectives = size(front, 2)
    
    for objective_index in 1:number_of_objectives
        objective_range = bounds_max[objective_index] - bounds_min[objective_index]
        
        if objective_range > 0
            normalized_front[:, objective_index] = (front[:, objective_index] .- bounds_min[objective_index]) ./ objective_range
        else
            normalized_front[:, objective_index] = front[:, objective_index] .- bounds_min[objective_index]
        end
    end
    
    return normalized_front
end