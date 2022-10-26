
include("../src/solution.jl")

using Test

# Utility functions
function createContinuousSolution(objectives::Vector{Float64})::ContinuousSolution{Float64}
    return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(1.0, 10.0)])
end

function createContinuousSolution(numberOfObjectives::Int)::ContinuousSolution{Float64}
    objectives = [_ for _ in range(1, numberOfObjectives)]
    return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(1.0, 10.0)])
end

"""
include("boundsTests.jl")
include("continuousProblemTests.jl")
include("densityEstimatorTests.jl")
include("archiveTests.jl")
include("comparatorTests.jl")
include("rankingTests.jl")
include("utilTests.jl")
include("solutionTests.jl")
include("operatorTests.jl")