const EPSILON_TEST_ATOL = 1e-12

using DelimitedFiles

@testset "Additive Epsilon Indicator" begin
    # Simple case: fronts are identical, epsilon should be 0
    front1 = [0.1 0.2; 0.3 0.4]
    ref1 = [0.1 0.2; 0.3 0.4]
    @test isapprox(additive_epsilon(front1, ref1), 0.0; atol=EPSILON_TEST_ATOL)

    # Simple shift: front is worse by 0.1 in all objectives, epsilon should be 0.1
    front2 = [0.2 0.3; 0.4 0.5]
    ref2 = [0.1 0.2; 0.3 0.4]
    @test isapprox(additive_epsilon(front2, ref2), 0.1; atol=EPSILON_TEST_ATOL)

    # Mixed case: only one solution in front dominates reference, epsilon should be 0.0
    front3 = [0.1 0.2; 0.5 0.6]
    ref3 = [0.1 0.2; 0.3 0.4]
    @test isapprox(additive_epsilon(front3, ref3), 0.0; atol=EPSILON_TEST_ATOL)

    # Reference point outside front: epsilon should be positive
    front4 = [0.2 0.2; 0.3 0.3]
    ref4 = [0.1 0.1]
    @test isapprox(additive_epsilon(front4, ref4), 0.1; atol=EPSILON_TEST_ATOL)

    # Single-point fronts
    front5 = [0.5 0.5]
    ref5 = [0.2 0.3]
    @test isapprox(additive_epsilon(front5, ref5), 0.3; atol=EPSILON_TEST_ATOL)

    # Case: front = [2 3], referenceFront = [1 2], expected epsilon = 1.0
    front6 = [2.0 3.0]
    ref6 = [1.0 2.0]
    @test isapprox(additive_epsilon(front6, ref6), 1.0; atol=EPSILON_TEST_ATOL)

    # Case: front = [1.5 4.0; 2.0 3.0; 3.0 2.0], referenceFront = [1.0 3.0; 1.5 2.0; 2.0 1.5]
    front7 = [1.5 4.0; 2.0 3.0; 3.0 2.0]
    ref7 = [1.0 3.0; 1.5 2.0; 2.0 1.5]
    # The expected epsilon is 1.0 (the minimal shift needed for all reference points to be weakly dominated)
    @test isapprox(additive_epsilon(front7, ref7), 1.0; atol=EPSILON_TEST_ATOL)

    # Case: front = [1.5 4.0; 1.5 2.0; 2.0 1.5], referenceFront = [1.0 3.0; 1.5 2.0; 2.0 1.5]
    front8 = [1.5 4.0; 1.5 2.0; 2.0 1.5]
    ref8 = [1.0 3.0; 1.5 2.0; 2.0 1.5]
    # The expected epsilon is 1.0 (the minimal shift needed for all reference points to be weakly dominated)
    @test isapprox(additive_epsilon(front8, ref8), 0.5; atol=EPSILON_TEST_ATOL)

    # Test with ZDT1.csv as both front and reference front
    zdt1_path = joinpath(@__DIR__, "..", "..", "data", "referenceFronts", "ZDT1.csv")
    zdt1_front = readdlm(zdt1_path, ',')

    @test isapprox(additive_epsilon(zdt1_front, zdt1_front), 0.0; atol=EPSILON_TEST_ATOL)
end