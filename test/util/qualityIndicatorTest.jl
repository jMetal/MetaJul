const EPSILON_TEST_ATOL = 1e-12

using DelimitedFiles
using MetaJul
using Test

@testset "Additive Epsilon Indicator" begin
    @testset "Basic Cases" begin
        # Identical fronts: epsilon should be 0
        identical_fronts = [0.1 0.2; 0.3 0.4]
        identical_reference = [0.1 0.2; 0.3 0.4]
        @test isapprox(additive_epsilon(identical_fronts, identical_reference), 0.0; atol=EPSILON_TEST_ATOL)

        # Uniform shift: front is worse by 0.1 in all objectives, epsilon should be 0.1
        shifted_fronts = [0.2 0.3; 0.4 0.5]
        shifted_reference = [0.1 0.2; 0.3 0.4]
        @test isapprox(additive_epsilon(shifted_fronts, shifted_reference), 0.1; atol=EPSILON_TEST_ATOL)

        # Mixed dominance: only one solution in front dominates reference, epsilon should be 0.0
        mixed_fronts = [0.1 0.2; 0.5 0.6]
        mixed_reference = [0.1 0.2; 0.3 0.4]
        @test isapprox(additive_epsilon(mixed_fronts, mixed_reference), 0.0; atol=EPSILON_TEST_ATOL)

        # Reference point outside front: epsilon should be positive
        outside_fronts = [0.2 0.2; 0.3 0.3]
        outside_reference = [0.1 0.1]
        @test isapprox(additive_epsilon(outside_fronts, outside_reference), 0.1; atol=EPSILON_TEST_ATOL)

        # Single-point fronts
        single_front = [0.5 0.5]
        single_reference = [0.2 0.3]
        @test isapprox(additive_epsilon(single_front, single_reference), 0.3; atol=EPSILON_TEST_ATOL)

        # Simple 2D case: epsilon = 1.0
        simple_front = [2.0 3.0]
        simple_reference = [1.0 2.0]
        @test isapprox(additive_epsilon(simple_front, simple_reference), 1.0; atol=EPSILON_TEST_ATOL)

        # 2D, three-point fronts: epsilon = 1.0
        three_point_fronts = [1.5 4.0; 2.0 3.0; 3.0 2.0]
        three_point_reference = [1.0 3.0; 1.5 2.0; 2.0 1.5]
        @test isapprox(additive_epsilon(three_point_fronts, three_point_reference), 1.0; atol=EPSILON_TEST_ATOL)

        # 2D, three-point fronts: epsilon = 0.5
        partial_three_fronts = [1.5 4.0; 1.5 2.0; 2.0 1.5]
        partial_three_reference = [1.0 3.0; 1.5 2.0; 2.0 1.5]
        @test isapprox(additive_epsilon(partial_three_fronts, partial_three_reference), 0.5; atol=EPSILON_TEST_ATOL)
    end

    @testset "Edge Cases" begin
        # Single objective
        single_obj_front = [2.0;;]
        single_obj_reference = [1.0;;]
        @test isapprox(additive_epsilon(single_obj_front, single_obj_reference), 1.0; atol=EPSILON_TEST_ATOL)

        # Dimension mismatch should throw error
        front_2d = [0.1 0.2]
        reference_3d = [0.1 0.2 0.3]
        @test_throws AssertionError additive_epsilon(front_2d, reference_3d)

        # Empty matrices should throw error
        empty_front = Matrix{Float64}(undef, 0, 2)
        non_empty_reference = [0.1 0.2]
        @test_throws BoundsError additive_epsilon(empty_front, non_empty_reference)
    end

    @testset "Mathematical Properties" begin
        front_a = [0.0 1.0; 1.0 0.0]
        front_b = [0.5 0.5]
        
        # Non-negativity
        @test additive_epsilon(front_a, front_b) >= 0.0
        @test additive_epsilon(front_b, front_a) >= 0.0
        
        # Test with fronts that guarantee asymmetry
        dominated_front = [0.2 0.2]      # Single point
        dominating_front = [0.1 0.1; 0.0 0.3; 0.3 0.0]  # Multiple points that dominate
        
        eps_dom_to_dominated = additive_epsilon(dominating_front, dominated_front)
        eps_dominated_to_dom = additive_epsilon(dominated_front, dominating_front)
        
        @test eps_dom_to_dominated == 0.0  # Dominating front should have eps = 0
        @test eps_dominated_to_dom > 0.0   # Reverse should be positive
        @test eps_dom_to_dominated != eps_dominated_to_dom  # Should be different
    end

    @testset "Real Data" begin
        # Real data: ZDT1.csv as both front and reference front
        zdt1_path = joinpath(@__DIR__, "..", "..", "data", "referenceFronts", "ZDT1.csv")
        zdt1_front = readdlm(zdt1_path, ',')
        @test isapprox(additive_epsilon(zdt1_front, zdt1_front), 0.0; atol=EPSILON_TEST_ATOL)
    end

    @testset "Interface" begin
        # --- QualityIndicator interface tests ---
        indicator = AdditiveEpsilonIndicator()
        @test name(indicator) == "EP"
        @test occursin("epsilon", lowercase(description(indicator)))
        @test is_minimization(indicator) == true

        # Interface usage
        identical_fronts = [0.1 0.2; 0.3 0.4]
        shifted_fronts = [0.2 0.3; 0.4 0.5]
        shifted_reference = [0.1 0.2; 0.3 0.4]
        zdt1_path = joinpath(@__DIR__, "..", "..", "data", "referenceFronts", "ZDT1.csv")
        zdt1_front = readdlm(zdt1_path, ',')
        
        @test isapprox(compute(indicator, identical_fronts, identical_fronts), 0.0; atol=EPSILON_TEST_ATOL)
        @test isapprox(compute(indicator, shifted_fronts, shifted_reference), 0.1; atol=EPSILON_TEST_ATOL)
        @test isapprox(compute(indicator, zdt1_front, zdt1_front), 0.0; atol=EPSILON_TEST_ATOL)
    end
end

@testset "Inverted Generational Distance (IGD) Indicator" begin
    @testset "Basic Cases" begin
        # Identical 2D fronts: IGD = 0
        identical_fronts = [0.1 0.2; 0.3 0.4]
        identical_reference = [0.1 0.2; 0.3 0.4]
        @test isapprox(inverted_generational_distance(identical_fronts, identical_reference), 0.0; atol=EPSILON_TEST_ATOL)

        # Uniform shift in 2D: IGD = sqrt(0.1^2 + 0.1^2)
        shifted_fronts = [0.2 0.3; 0.4 0.5]
        shifted_reference = [0.1 0.2; 0.3 0.4]
        @test isapprox(inverted_generational_distance(shifted_fronts, shifted_reference), 0.14142135623730953; atol=EPSILON_TEST_ATOL)

        # Single-point fronts in 2D
        single_front = [0.5 0.5]
        single_reference = [0.2 0.3]
        @test isapprox(inverted_generational_distance(single_front, single_reference), sqrt((0.5-0.2)^2 + (0.5-0.3)^2); atol=EPSILON_TEST_ATOL)

        # Three-objective fronts: IGD = 0
        three_obj_fronts = [0.1 0.2 0.3; 0.4 0.5 0.6]
        three_obj_reference = [0.1 0.2 0.3; 0.4 0.5 0.6]
        @test isapprox(inverted_generational_distance(three_obj_fronts, three_obj_reference), 0.0; atol=EPSILON_TEST_ATOL)

        # Shifted three-objective fronts: IGD = sqrt(0.1^2 + 0.1^2 + 0.1^2)
        shifted_three_obj_fronts = [0.2 0.3 0.4; 0.5 0.6 0.7]
        shifted_three_obj_reference = [0.1 0.2 0.3; 0.4 0.5 0.6]
        @test isapprox(inverted_generational_distance(shifted_three_obj_fronts, shifted_three_obj_reference), 0.17320508075688776; atol=EPSILON_TEST_ATOL)

        # Perfect match in 2D → IGD = 0
        perfect_match_fronts = [0.0 0.0; 0.5 0.5; 1.0 1.0]
        perfect_match_reference = [0.0 0.0; 0.5 0.5; 1.0 1.0]
        @test isapprox(inverted_generational_distance(perfect_match_fronts, perfect_match_reference), 0.0; atol=EPSILON_TEST_ATOL)

        # Uniformly shifted solutions in 2D
        uniform_shifted_fronts = [0.1 0.1; 0.6 0.6; 1.1 1.1]
        uniform_shifted_reference = [0.0 0.0; 0.5 0.5; 1.0 1.0]
        @test isapprox(inverted_generational_distance(uniform_shifted_fronts, uniform_shifted_reference), 0.14142135623730956; atol=EPSILON_TEST_ATOL)

        # Partial coverage of the front in 2D
        partial_coverage_fronts = [0.0 0.0; 1.0 0.0]
        partial_coverage_reference = [0.0 0.0; 0.0 1.0; 1.0 0.0; 1.0 1.0]
        @test isapprox(inverted_generational_distance(partial_coverage_fronts, partial_coverage_reference), 0.7071067811865476; atol=EPSILON_TEST_ATOL)

        # Sparse approximation of continuous front in 2D
        sparse_fronts = [0.0 1.0; 0.5 0.5; 1.0 0.0]
        sparse_reference = [0.0 1.0; 0.25 0.75; 0.5 0.5; 0.75 0.25; 1.0 0.0]
        @test isapprox(inverted_generational_distance(sparse_fronts, sparse_reference), 0.223606797749979; atol=EPSILON_TEST_ATOL)
    end

    @testset "Edge Cases" begin
        # Single objective
        single_obj_front = [2.0;;]
        single_obj_reference = [1.0;;]
        @test isapprox(inverted_generational_distance(single_obj_front, single_obj_reference), 1.0; atol=EPSILON_TEST_ATOL)

        # Dimension mismatch should throw error
        front_2d = [0.1 0.2]
        reference_3d = [0.1 0.2 0.3]
        @test_throws AssertionError inverted_generational_distance(front_2d, reference_3d)

        # Empty reference front should return NaN or specific value
        empty_front = Matrix{Float64}(undef, 0, 2)
        non_empty_reference = [0.1 0.2]
        result = inverted_generational_distance(empty_front, non_empty_reference)
        @test isnan(result) || result == 0.0  # Accept either NaN or 0.0 as valid for empty front
        
        # Empty reference front - this would cause division by zero
        non_empty_front = [0.1 0.2]
        empty_reference = Matrix{Float64}(undef, 0, 2)
        result_empty_ref = inverted_generational_distance(non_empty_front, empty_reference)
        @test result_empty_ref == 0.0  # Should return 0 when no reference points exist
    end

    @testset "Mathematical Properties" begin
        front_a = [0.0 1.0; 1.0 0.0]
        front_b = [0.5 0.5]
        
        # Non-negativity
        @test inverted_generational_distance(front_a, front_b) >= 0.0
        @test inverted_generational_distance(front_b, front_a) >= 0.0
        
        # Asymmetry: IGD(A,B) != IGD(B,A) in general
        igd_ab = inverted_generational_distance(front_a, front_b)
        igd_ba = inverted_generational_distance(front_b, front_a)
        @test igd_ab != igd_ba
    end

    @testset "Power Parameters" begin
        test_fronts = [0.1 0.1; 0.6 0.6; 1.1 1.1]
        test_reference = [0.0 0.0; 0.5 0.5; 1.0 1.0]
        
        # Test different power values
        indicator_l1 = InvertedGenerationalDistanceIndicator(pow=1.0)
        indicator_l2 = InvertedGenerationalDistanceIndicator(pow=2.0)
        indicator_l3 = InvertedGenerationalDistanceIndicator(pow=3.0)
        
        igd_l1 = compute(indicator_l1, test_fronts, test_reference)
        igd_l2 = compute(indicator_l2, test_fronts, test_reference)
        igd_l3 = compute(indicator_l3, test_fronts, test_reference)
        
        @test igd_l1 != igd_l2
        @test igd_l2 != igd_l3
        @test igd_l1 > 0.0 && igd_l2 > 0.0 && igd_l3 > 0.0
        
        # Test direct function with power parameter
        igd_direct_l1 = inverted_generational_distance(test_fronts, test_reference; pow=1.0)
        igd_direct_l2 = inverted_generational_distance(test_fronts, test_reference; pow=2.0)
        
        @test isapprox(igd_l1, igd_direct_l1; atol=EPSILON_TEST_ATOL)
        @test isapprox(igd_l2, igd_direct_l2; atol=EPSILON_TEST_ATOL)
    end

    @testset "Performance Cases" begin
        # Large fronts (performance test)
        large_front = rand(100, 2)
        large_reference = rand(50, 2)
        @test typeof(inverted_generational_distance(large_front, large_reference)) == Float64
        
        # High-dimensional problems
        front_5d = rand(10, 5)
        reference_5d = rand(5, 5)
        @test typeof(inverted_generational_distance(front_5d, reference_5d)) == Float64
    end

    @testset "Real Data" begin
        # Real data: ZDT1.csv as both front and reference front
        zdt1_path = joinpath(@__DIR__, "..", "..", "data", "referenceFronts", "ZDT1.csv")
        zdt1_front = readdlm(zdt1_path, ',')
        @test isapprox(inverted_generational_distance(zdt1_front, zdt1_front), 0.0; atol=EPSILON_TEST_ATOL)
    end

    @testset "Interface" begin
        # --- QualityIndicator interface tests ---
        indicator = InvertedGenerationalDistanceIndicator()
        @test name(indicator) == "IGD"
        @test occursin("generational", lowercase(description(indicator)))
        @test is_minimization(indicator) == true

        # Interface usage
        identical_fronts = [0.1 0.2; 0.3 0.4]
        shifted_fronts = [0.2 0.3; 0.4 0.5]
        shifted_reference = [0.1 0.2; 0.3 0.4]
        zdt1_path = joinpath(@__DIR__, "..", "..", "data", "referenceFronts", "ZDT1.csv")
        zdt1_front = readdlm(zdt1_path, ',')
        
        @test isapprox(compute(indicator, identical_fronts, identical_fronts), 0.0; atol=EPSILON_TEST_ATOL)
        @test isapprox(compute(indicator, shifted_fronts, shifted_reference), 0.14142135623730953; atol=EPSILON_TEST_ATOL)
        @test isapprox(compute(indicator, zdt1_front, zdt1_front), 0.0; atol=EPSILON_TEST_ATOL)
    end
end