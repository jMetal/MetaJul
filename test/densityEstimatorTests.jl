include("../src/solution.jl")
include("../src/densityEstimator.jl")

# Utility functions
function createContinuousSolution(objectives::Vector{Float64})::ContinuousSolution{Float64}
    return ContinuousSolution{Float64}([1.0], objectives, [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(1.0, 2.0)])
end

function computingTheCrowdingDistanceRaisesAnExceptionIfTheSolutionListIsEmpty()
    computeCrowdingDistanceEstimator!(Vector{ContinuousSolution{Float64}}(undef, 0))
end

function computingTheCrowdingDistanceOnAListWithASolutionAssignsTheMaxValueToTheSolution()
    solutions = [createContinuousSolution([1.0, 2.0])]
    computeCrowdingDistanceEstimator!(solutions)

    return solutions[1].attributes["CROWDING_DISTANCE_ATTRIBUTE"] == typemax(Float64)
end

function computingTheCrowdingDistanceOnAListWithTwoSolutionAssignsTheMaxValueToThem()
    solutions = [createContinuousSolution([1.0, 2.0]), createContinuousSolution([2.0, 1.0])]
    computeCrowdingDistanceEstimator!(solutions)

    return solutions[1].attributes["CROWDING_DISTANCE_ATTRIBUTE"] == typemax(Float64)
    return solutions[2].attributes["CROWDING_DISTANCE_ATTRIBUTE"] == typemax(Float64)
end

function computingTheCrowdingDistanceOnAListWithThreeBiObjectiveSolutionAssignsTheRightValues()
    solution1 = createContinuousSolution([0.0, 1.0])
    solution2 = createContinuousSolution([1.0, 0.0])
    solution3 = createContinuousSolution([0.5, 0.5])
    solutions = [solution1, solution2, solution3]

    computeCrowdingDistanceEstimator!(solutions)

    return solutions[1].attributes["CROWDING_DISTANCE_ATTRIBUTE"] == typemax(Float64)
    return solutions[2].attributes["CROWDING_DISTANCE_ATTRIBUTE"] == 2.0
    return solutions[3].attributes["CROWDING_DISTANCE_ATTRIBUTE"] == typemax(Float64)
end

@testset "Crowding distance estimator test cases" begin    
    @test_throws "The solution list is empty" computingTheCrowdingDistanceRaisesAnExceptionIfTheSolutionListIsEmpty()

    @test computingTheCrowdingDistanceOnAListWithASolutionAssignsTheMaxValueToTheSolution()
    @test computingTheCrowdingDistanceOnAListWithTwoSolutionAssignsTheMaxValueToThem()
    @test computingTheCrowdingDistanceOnAListWithThreeBiObjectiveSolutionAssignsTheRightValues()
end