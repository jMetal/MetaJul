using MetaJul
using DelimitedFiles

function main()
    if length(ARGS) < 3
        println("Usage: julia src/util/qualityIndicatorCLI.jl <front.csv> <reference.csv> <indicator> [--normalize]")
        println("Available indicators: epsilon, igd, igdplus, hv, nhv, ALL")
        return
    end

    front_file = ARGS[1]
    reference_file = ARGS[2]
    indicator_name = ARGS[3]
    normalize = length(ARGS) > 3 && ARGS[4] == "--normalize"

    front = readdlm(front_file, ',')
    reference = readdlm(reference_file, ',')

    if normalize
        front, reference = normalize_fronts(front, reference; method=:reference_only)
        println("Fronts normalized using reference_only method.")
    end

    if indicator_name == "ALL"
        # Compute all indicators
        epsilon = compute(AdditiveEpsilonIndicator(), front, reference)
        igd = compute(InvertedGenerationalDistanceIndicator(), front, reference)
        igdplus = compute(InvertedGenerationalDistancePlusIndicator(), front, reference)
        if normalize
            ref_point = fill(1.1, size(front, 2))
        else
            ref_point = maximum(reference, dims=1)[:] .+ 0.1
        end
        hv = compute(HypervolumeIndicator(ref_point), front)
        nhv = compute(NormalizedHypervolumeIndicator(ref_point), front, reference)
        println("Result (epsilon): ", epsilon)
        println("Result (igd): ", igd)
        println("Result (igdplus): ", igdplus)
        println("Result (hv): ", hv)
        println("Result (nhv): ", nhv)
        return
    end

    indicator = nothing
    result = nothing

    if indicator_name == "epsilon"
        indicator = AdditiveEpsilonIndicator()
        result = compute(indicator, front, reference)
    elseif indicator_name == "igd"
        indicator = InvertedGenerationalDistanceIndicator()
        result = compute(indicator, front, reference)
    elseif indicator_name == "igdplus"
        indicator = InvertedGenerationalDistancePlusIndicator()
        result = compute(indicator, front, reference)
    elseif indicator_name == "hv"
        if normalize
            ref_point = fill(1.1, size(front, 2))
        else
            ref_point = maximum(reference, dims=1)[:] .+ 0.1
        end
        indicator = HypervolumeIndicator(ref_point)
        result = compute(indicator, front)
    elseif indicator_name == "nhv"
        if normalize
            ref_point = fill(1.1, size(front, 2))
        else
            ref_point = maximum(reference, dims=1)[:] .+ 0.1
        end
        indicator = NormalizedHypervolumeIndicator(ref_point)
        result = compute(indicator, front, reference)
    else
        println("Unknown indicator: $indicator_name")
        return
    end

    println("Result ($indicator_name): ", result)
end

main()