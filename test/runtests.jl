using MetaJul
using Test

tsp_data_dir = joinpath(@__DIR__, "..", "resources/tspDataFiles")

# Utility functions

function createContinuousSolution(objectives::Vector{Float64})::ContinuousSolution{Float64}
    return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 10.0), Bounds{Float64}(1.0, 10.0)])
end

function createContinuousSolution(numberOfObjectives::Int)::ContinuousSolution{Float64}
    objectives = [_ for _ in range(1, numberOfObjectives)]
    return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 10.0), Bounds{Float64}(1.0, 10.0)])
end

coreTests = [
    "core/constraintHandlingTest.jl"
    ]

for testProgram in coreTests
    include(testProgram)
end

componentTests = [
    "component/common/evaluationTest.jl",
    "component/common/solutionsCreationTest.jl",
    "component/common/terminationTest.jl",
    "component/evolutionaryAlgorithm/selectionTest.jl",
    "component/evolutionaryAlgorithm/variationTest.jl",
    "component/evolutionaryAlgorithm/replacementTest.jl",
    "component/particleSwarmOptimization/inertiaWeightComputingStrategyTest.jl",
    "component/particleSwarmOptimization/velocityInitializationTest.jl",
    "component/particleSwarmOptimization/globalBestInitializationTest.jl",
    "component/particleSwarmOptimization/globalBestSelectionTest.jl",
    "component/particleSwarmOptimization/globalBestUpdateTest.jl",
    "component/particleSwarmOptimization/localBestInitializationTest.jl",
    "component/particleSwarmOptimization/localBestUpdateTest.jl",
    "component/particleSwarmOptimization/perturbationTest.jl",
    "component/particleSwarmOptimization/positionUpdateTest.jl",
    "component/particleSwarmOptimization/velocityUpdateTest.jl"
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
    "util/utilTest.jl",
    "util/tspUtilsTest.jl"
]

for testProgram in utilTests
    include(testProgram)
end

operatorTests = [
    "operator/mutationTest.jl"
    "operator/crossoverTest.jl"
    "operator/selectionTest.jl"
]

for testProgram in operatorTests
    include(testProgram)
end

solutionTests = [
    "solution/continuousSolutionTest.jl",
    "solution/binarySolutionTest.jl",
    "solution/permutationSolutionTest.jl"
]

for testProgram in solutionTests
    include(testProgram)
end

problemTests = [
    "problem/continuousProblemTest.jl",
    "problem/binaryProblemTest.jl",
    "problem/permutationProblemTest.jl",
    "problem/singleObjective/oneMaxTest.jl",
    "problem/multiObjective/oneZeroMaxTest.jl",
    "problem/multiObjective/schafferTest.jl",
    "problem/multiObjective/ZDTTest.jl",
    "problem/multiObjective/multiObjectiveTSPTest.jl",
    "problem/multiObjective/multiObjectiveKnapsackTest.jl"
]

for testProgram in problemTests
    include(testProgram)
end

algorithmTests = [
    "algorithm/localSearchTest.jl",
]

for testProgram in algorithmTests
    include(testProgram)
end

include("util/pointTest.jl")
include("util/aggregationFunctionTest.jl")

include("util/neighborhoodTest.jl")


