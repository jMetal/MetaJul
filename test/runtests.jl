using metajul

using Test

# Utility functions

function createContinuousSolution(objectives::Vector{Float64})::ContinuousSolution{Float64}
    return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 10.0), Bounds{Float64}(1.0, 10.0)])
end

function createContinuousSolution(numberOfObjectives::Int)::ContinuousSolution{Float64}
    objectives = [_ for _ in range(1, numberOfObjectives)]
    return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 10.0), Bounds{Float64}(1.0, 10.0)])
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
include("componentTests.jl")

"""
coreTests = [
    "core/solutionTest.jl",
    "core/constraintHandlingTest.jl",
    ]

for testProgram in coreTests
    include(testProgram)
end

componentTests = [
    "component/common/evaluationTest.jl",
    "component/common/solutionsCreationTest.jl"
    ]

for testProgram in componentTests
    include(testProgram)
end


utilTests = [
    "util/boundsTest.jl",
    "util/comparatorTest.jl",
    "util/archiveTest.jl",
    "util/rankingTest.jl",
    "util/densityEstimatorTest.jl",
    "util/utilTest.jl"
]

for testProgram in utilTests
    include(testProgram)
end

problemTests = [
    "problem/continuousProblemTest.jl"
]

for testProgram in problemTests
    include(testProgram)
end

operatorTests = [
    "operator/mutationTest.jl"
    "operator/crossoverTest.jl"
]

for testProgram in operatorTests
    include(testProgram)
end

problemTests = [
    "problem/continuousProblemTest.jl",
    "problem/binaryProblemTest.jl",
    "problem/singleObjective/oneMaxTest.jl",
    "problem/multiObjective/oneZeroMaxTest.jl",
    "problem/multiObjective/schafferTest.jl",
    "problem/multiObjective/ZDTTest.jl"
]

for testProgram in problemTests
    include(testProgram)
end
