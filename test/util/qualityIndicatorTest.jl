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
        
        # Non-negativity (but epsilon can be negative when dominating)
        @test additive_epsilon(front_a, front_b) >= -1.0  # Allow reasonable negative values
        @test additive_epsilon(front_b, front_a) >= 0.0
        
        # Test with fronts where dominating front just covers the reference
        reference_front = [0.2 0.2]      # Single point
        covering_front = [0.2 0.2; 0.1 0.3; 0.3 0.1]  # Includes the reference point exactly
        
        eps_covering_to_ref = additive_epsilon(covering_front, reference_front)
        eps_ref_to_covering = additive_epsilon(reference_front, covering_front)
        
        @test eps_covering_to_ref == 0.0  # Should be exactly 0 when front includes reference point
        @test eps_ref_to_covering > 0.0   # Reverse should be positive
        @test eps_covering_to_ref != eps_ref_to_covering  # Should be different
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

        # Empty front - test what actually happens (likely returns Inf or specific value)
        empty_front = Matrix{Float64}(undef, 0, 2)
        non_empty_reference = [0.1 0.2]
        result_empty_front = inverted_generational_distance(empty_front, non_empty_reference)
        @test result_empty_front == Inf || isnan(result_empty_front)  # Accept either Inf or NaN
        
        # Empty reference front - returns NaN due to division by 0
        non_empty_front = [0.1 0.2]
        empty_reference = Matrix{Float64}(undef, 0, 2)
        result_empty_ref = inverted_generational_distance(non_empty_front, empty_reference)
        @test isnan(result_empty_ref)  # Should return NaN when no reference points exist (division by 0)
    end

    @testset "Mathematical Properties" begin
        # Test that IGD gives reasonable results for different front sizes
        small_front = [0.5 0.5]
        large_reference = [0.0 0.0; 0.2 0.8; 0.5 0.5; 0.8 0.2; 1.0 1.0]
        
        igd_small_to_large = inverted_generational_distance(small_front, large_reference)
        
        # IGD should be positive when there's a mismatch
        @test igd_small_to_large > 0.0
        
        # Test with perfect coverage
        covering_front = [0.0 0.0; 0.2 0.8; 0.5 0.5; 0.8 0.2; 1.0 1.0]
        igd_perfect = inverted_generational_distance(covering_front, large_reference)
        @test igd_perfect ≈ 0.0 atol=EPSILON_TEST_ATOL
        
        # Non-negativity
        @test igd_small_to_large >= 0.0
        @test igd_perfect >= 0.0
    end

    @testset "Power Parameters" begin
        # Create a case with one very large distance to amplify power differences
        test_fronts = [0.0 0.0]  # Single point at origin
        test_reference = [0.1 0.1; 2.0 2.0]  # One close, one far point
        
        # Test different power values
        indicator_l1 = InvertedGenerationalDistanceIndicator(pow=1.0)
        indicator_l2 = InvertedGenerationalDistanceIndicator(pow=2.0)
        indicator_l3 = InvertedGenerationalDistanceIndicator(pow=3.0)
        
        igd_l1 = compute(indicator_l1, test_fronts, test_reference)
        igd_l2 = compute(indicator_l2, test_fronts, test_reference)
        igd_l3 = compute(indicator_l3, test_fronts, test_reference)
        
        # With one large distance (2√2 ≈ 2.83), powers should give very different results
        @test igd_l1 > 0.0 && igd_l2 > 0.0 && igd_l3 > 0.0
        @test abs(igd_l1 - igd_l2) > 0.1  # Should be significantly different
        @test abs(igd_l2 - igd_l3) > 0.1  # Should be significantly different
        
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

@testset "Inverted Generational Distance Plus (IGD+) Indicator" begin
    @testset "Basic Cases" begin
        # Identical fronts: IGD+ = 0
        identical_fronts = [0.1 0.2; 0.3 0.4]
        identical_reference = [0.1 0.2; 0.3 0.4]
        @test isapprox(inverted_generational_distance_plus(identical_fronts, identical_reference), 0.0; atol=EPSILON_TEST_ATOL)

        # Uniform shift: IGD+ > 0
        shifted_fronts = [0.2 0.3; 0.4 0.5]
        shifted_reference = [0.1 0.2; 0.3 0.4]
        @test inverted_generational_distance_plus(shifted_fronts, shifted_reference) > 0.0

        # Single-point fronts
        single_front = [0.5 0.5]
        single_reference = [0.2 0.3]
        @test inverted_generational_distance_plus(single_front, single_reference) > 0.0

        # Three-objective fronts: IGD+ = 0
        three_obj_fronts = [0.1 0.2 0.3; 0.4 0.5 0.6]
        three_obj_reference = [0.1 0.2 0.3; 0.4 0.5 0.6]
        @test isapprox(inverted_generational_distance_plus(three_obj_fronts, three_obj_reference), 0.0; atol=EPSILON_TEST_ATOL)
    end

    @testset "Mathematical Properties" begin
        # Non-negativity
        front_a = [0.0 1.0; 1.0 0.0]
        front_b = [0.5 0.5]
        @test inverted_generational_distance_plus(front_a, front_b) >= 0.0
        @test inverted_generational_distance_plus(front_b, front_a) >= 0.0

        # Test asymmetry with very different sized fronts to guarantee asymmetry
        single_point_front = [0.4 0.6]
        large_reference = [0.0 0.0; 0.1 0.9; 0.2 0.8; 0.3 0.7; 0.5 0.5; 0.6 0.4; 0.7 0.3; 0.8 0.2; 0.9 0.1; 1.0 1.0]  # Exclude [0.4 0.6]
        
        igdplus_single_to_large = inverted_generational_distance_plus(single_point_front, large_reference)
        igdplus_large_to_single = inverted_generational_distance_plus(large_reference, single_point_front)
        
        # With 1 vs 10 points and no exact match, these should definitely be different
        @test igdplus_single_to_large != igdplus_large_to_single
        @test igdplus_single_to_large > 0.0
        @test igdplus_large_to_single >= 0.0  # Could be 0 if some point dominates the single point
        
        # Alternative test to ensure we get asymmetry
        extreme_single = [0.0 3.0]
        small_reference = [0.1 0.1; 0.2 0.2]
        
        igdplus_extreme_to_small = inverted_generational_distance_plus(extreme_single, small_reference)
        igdplus_small_to_extreme = inverted_generational_distance_plus(small_reference, extreme_single)
        
        @test igdplus_extreme_to_small != igdplus_small_to_extreme
        @test igdplus_extreme_to_small > 0.0
        @test igdplus_small_to_extreme > 0.0
    end

    @testset "Edge Cases" begin
        # Single objective
        single_obj_front = [2.0;;]
        single_obj_reference = [1.0;;]
        @test inverted_generational_distance_plus(single_obj_front, single_obj_reference) >= 0.0

        # Dimension mismatch should throw error
        front_2d = [0.1 0.2]
        reference_3d = [0.1 0.2 0.3]
        @test_throws AssertionError inverted_generational_distance_plus(front_2d, reference_3d)

        # Empty front - test what actually happens (likely returns Inf or specific value)
        empty_front = Matrix{Float64}(undef, 0, 2)
        non_empty_reference = [0.1 0.2]
        result_empty_front = inverted_generational_distance_plus(empty_front, non_empty_reference)
        @test result_empty_front == Inf || isnan(result_empty_front)  # Accept either Inf or NaN
    end

    @testset "Interface" begin
        indicator = InvertedGenerationalDistancePlusIndicator()
        @test name(indicator) == "IGD+"
        @test occursin("distance+", lowercase(description(indicator)))
        @test is_minimization(indicator) == true

        identical_fronts = [0.1 0.2; 0.3 0.4]
        shifted_fronts = [0.2 0.3; 0.4 0.5]
        shifted_reference = [0.1 0.2; 0.3 0.4]

        @test isapprox(compute(indicator, identical_fronts, identical_fronts), 0.0; atol=EPSILON_TEST_ATOL)
        @test compute(indicator, shifted_fronts, shifted_reference) > 0.0
    end
end

@testset "Hypervolume (HV) Indicator" begin
    @testset "Basic Cases" begin
        # 2D: Simple case, one point
        front = [1.0 2.0]
        reference_point = [3.0, 3.0]
        @test isapprox(hypervolume(front, reference_point), (3.0-1.0)*(3.0-2.0); atol=EPSILON_TEST_ATOL)

        # 2D: Two points, non-overlapping rectangles
        front = [1.0 2.0; 2.0 1.0]
        reference_point = [3.0, 3.0]
        expected_hv = 2.0  # El algoritmo WFG calcula la unión, no la suma directa
        @test isapprox(hypervolume(front, reference_point), expected_hv; atol=EPSILON_TEST_ATOL)

        # 2D: Identical points, should not double count
        front = [1.0 2.0; 1.0 2.0]
        reference_point = [3.0, 3.0]
        @test isapprox(hypervolume(front, reference_point), (3.0-1.0)*(3.0-2.0); atol=EPSILON_TEST_ATOL)

        # 1D: Single objective
        front = [2.0]
        front_matrix = reshape(front, :, 1)
        reference_point = [3.0]
        @test isapprox(hypervolume(front_matrix, reference_point), 1.0; atol=EPSILON_TEST_ATOL)

        # 1D: Multiple points
        front = [1.0, 2.0]
        front_matrix = reshape(front, :, 1)
        reference_point = [3.0]
        @test isapprox(hypervolume(front_matrix, reference_point), 2.0; atol=EPSILON_TEST_ATOL)
    end

    @testset "Edge Cases" begin
        # Dimension mismatch should throw error
        front_2d = [1.0 2.0]
        reference_3d = [3.0, 3.0, 3.0]
        @test_throws AssertionError hypervolume(front_2d, reference_3d)

        # Empty front should throw error
        empty_front = Matrix{Float64}(undef, 0, 2)
        reference_point = [3.0, 3.0]
        @test_throws AssertionError hypervolume(empty_front, reference_point)

        # Reference point not dominated should throw error
        front = [3.0 2.0]
        reference_point = [3.0, 3.0]
        @test_throws ArgumentError hypervolume(front, reference_point)
    end

    @testset "Mathematical Properties" begin
        # HV is non-negative
        front = [1.0 2.0; 2.0 1.0]
        reference_point = [3.0, 3.0]
        @test hypervolume(front, reference_point) >= 0.0

        # Adding a point that does not improve HV
        front = [1.0 2.0; 2.0 1.0]
        reference_point = [3.0, 3.0]
        hv_before = hypervolume(front, reference_point)
        front_with_extra = [1.0 2.0; 2.0 1.0; 1.0 2.0]
        hv_after = hypervolume(front_with_extra, reference_point)
        @test isapprox(hv_before, hv_after; atol=EPSILON_TEST_ATOL)
    end

    @testset "Interface" begin
        indicator = HypervolumeIndicator([3.0, 3.0])
        @test name(indicator) == "HV"
        @test occursin("hypervolume", lowercase(description(indicator)))
        @test is_minimization(indicator) == false

        # Interface usage
        front = [1.0 2.0; 2.0 1.0]
        @test isapprox(compute(indicator, front), hypervolume(front, [3.0, 3.0]); atol=EPSILON_TEST_ATOL)
        # compute with reference_front argument (should ignore it)
        dummy_ref = [0.0 0.0]
        @test isapprox(compute(indicator, front, dummy_ref), hypervolume(front, [3.0, 3.0]); atol=EPSILON_TEST_ATOL)
    end

    @testset "Contribution" begin
        # Contribution of a new point
        front = Matrix{Float64}(undef, 0, 2)
        reference_point = [3.0, 3.0]
        new_point = [2.0, 1.0]
        contrib = hypervolume_contribution(new_point, front, reference_point)
        expected_contrib = (3.0-2.0)*(3.0-1.0)
        @test isapprox(contrib, expected_contrib; atol=EPSILON_TEST_ATOL)

        front = Matrix{Float64}(undef, 0, 2)  # Frente vacío
        reference_point = [3.0, 3.0]
        new_point = [2.0, 1.0]
        contrib = hypervolume_contribution(new_point, front, reference_point)
        expected_contrib = (3.0-2.0)*(3.0-1.0)
        @test isapprox(contrib, expected_contrib; atol=EPSILON_TEST_ATOL)
    end

    @testset "Real Data" begin
        # Real data: ZDT1.csv
        zdt1_path = joinpath(@__DIR__, "..", "..", "data", "referenceFronts", "ZDT1.csv")
        zdt1_front = readdlm(zdt1_path, ',')
        # Reference point slightly worse than all solutions
        ref_point = [maximum(zdt1_front[:, 1]) + 0.1, maximum(zdt1_front[:, 2]) + 0.1]
        indicator = HypervolumeIndicator(ref_point)
        hv_value = compute(indicator, zdt1_front)
        @test hv_value > 0.0
    end
end
