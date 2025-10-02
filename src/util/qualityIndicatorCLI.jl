using MetaJul
using DelimitedFiles

# ---- Utility parsing helpers ----
function _parse_bool_flag!(args::Vector{String}, flag::String)
    idx = findfirst(==(flag), args)
    if idx !== nothing
        deleteat!(args, idx)
        return true
    end
    return false
end

function _extract_option!(args::Vector{String}, name::String)
    pat = name * "="
    for (i,a) in enumerate(args)
        if startswith(a, pat)
            val = last(split(a, "=", limit=2))
            deleteat!(args, i)
            return val
        end
    end
    idx = findfirst(==(name), args)
    if idx !== nothing && idx < length(args)
        val = args[idx+1]
        deleteat!(args, idx:idx+1)
        return val
    end
    return nothing
end

function _parse_ref_point(str::AbstractString, expected_dim::Int)
    vals = parse.(Float64, split(str, ","))
    length(vals) == expected_dim || error("Reference point dimension mismatch: expected $expected_dim got $(length(vals))")
    return vals
end

function _load_csv(path::String)
    isfile(path) || error("File not found: $path")
    data = readdlm(path, ',')
    isempty(data) && error("File '$path' is empty")
    if eltype(data) != Float64
        try
            data = Float64.(data)
        catch
            error("Non-numeric data detected in $path")
        end
    end
    ndims(data) == 2 || error("Data in $path must be a 2D matrix")
    return data
end

function _auto_ref_point(reference::AbstractMatrix; margin=0.1)
    maximum(reference, dims=1)[:] .+ margin
end

function _compute_all(front, reference; ref_point)
    results = Dict{String,Float64}()
    results["epsilon"] = compute(AdditiveEpsilonIndicator(), front, reference)
    results["igd"]     = compute(InvertedGenerationalDistanceIndicator(), front, reference)
    results["igdplus"] = compute(InvertedGenerationalDistancePlusIndicator(), front, reference)
    hv_val  = compute(HypervolumeIndicator(ref_point), front)
    nhv_val = compute(NormalizedHypervolumeIndicator(ref_point), front, reference)
    results["hv"]  = hv_val
    results["nhv"] = nhv_val
    return results
end

function _print_results(dict::Dict{String,Float64}; format::Symbol)
    if format == :text
        for k in sort(collect(keys(dict)))
            println("Result ($k): ", dict[k])
        end
    elseif format == :json
        # Simple manual JSON (avoid adding dependencies)
        pairs_str = join(["\"$k\":" * string(dict[k]) for k in sort(collect(keys(dict)))], ",")
        println("{", pairs_str, "}")
    else
        error("Unsupported format $format")
    end
end

function _usage()
    println("""
Usage:
  julia src/util/qualityIndicatorCLI.jl <front.csv> <reference.csv> <indicator> [options]

Indicators:
  epsilon | igd | igdplus | hv | nhv | ALL

Options:
  --normalize               Normalize both fronts (reference_only strategy)
  --ref-point=V1,V2,...     Custom reference point for HV / NHV (overrides auto)
  --format json             Output JSON (default: text)
  --margin M                Margin added when auto-building ref point (default 0.1)
  -h | --help               Show this help

Notes:
  - HV / NHV require a reference point worse than all points.
  - NHV = 1 - HV(front)/HV(referenceFront), can be negative if front dominates reference.
""")
end

function main()
    args = copy(ARGS)
    if length(args) == 0 || any(a -> a in ("-h","--help"), args)
        _usage()
        return
    end
    if length(args) < 3
        println("Error: not enough positional arguments.\n")
        _usage()
        return
    end

    normalize = _parse_bool_flag!(args, "--normalize")
    format_opt = _extract_option!(args, "--format")
    format_sym = format_opt === nothing ? :text : Symbol(lowercase(format_opt))
    margin_opt = _extract_option!(args, "--margin")
    margin = margin_opt === nothing ? 0.1 : parse(Float64, margin_opt)
    ref_point_opt = _extract_option!(args, "--ref-point")

    front_file, reference_file, indicator_name = args[1:3]

    front = _load_csv(front_file)
    reference = _load_csv(reference_file)

    size(front,2) == size(reference,2) || error("Objective dimension mismatch between front and reference")

    if normalize
        if !@isdefined(normalize_fronts)
            error("normalize_fronts function not found. Ensure it is defined/exported.")
        end
        front, reference = normalize_fronts(front, reference; method=:reference_only)
        println("Fronts normalized (method=reference_only)")
    end

    # Build or parse reference point (only needed for HV / NHV / ALL)
    need_ref_point = uppercase(indicator_name) in ("HV","NHV","ALL")
    ref_point = nothing
    if need_ref_point
        if ref_point_opt !== nothing
            ref_point = _parse_ref_point(ref_point_opt, size(front,2))
        else
            # If normalized, default to 1.1 repeated; else auto margin
            ref_point = normalize ? fill(1.1, size(front,2)) : _auto_ref_point(reference; margin=margin)
        end
    end

    ind_lower = lowercase(indicator_name)

    if ind_lower == "all"
        results = _compute_all(front, reference; ref_point=ref_point)
        _print_results(results; format=format_sym)
        return
    end

    if ind_lower == "epsilon"
        result = compute(AdditiveEpsilonIndicator(), front, reference)
    elseif ind_lower == "igd"
        result = compute(InvertedGenerationalDistanceIndicator(), front, reference)
    elseif ind_lower == "igdplus"
        result = compute(InvertedGenerationalDistancePlusIndicator(), front, reference)
    elseif ind_lower == "hv"
        result = compute(HypervolumeIndicator(ref_point), front)
    elseif ind_lower == "nhv"
        result = compute(NormalizedHypervolumeIndicator(ref_point), front, reference)
    else
        println("Unknown indicator: $indicator_name")
        return
    end

    _print_results(Dict(ind_lower => result); format=format_sym)
end

main()