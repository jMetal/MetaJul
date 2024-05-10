struct ConstantValueStrategy <: InertiaWeightComputingStrategy
    inertiaWeight::Real
end

function compute(strategy::ConstantValueStrategy)::Real
    return strategy.inertiaWeight
end
