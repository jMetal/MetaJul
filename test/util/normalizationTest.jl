const NORMALIZATION_TEST_ATOL = 1e-12

using MetaJul
using Test
using Statistics

@testset "Front Normalization Functions" begin
    @testset "normalize_fronts - Basic Cases" begin
        # Simple 2D case with different scales
        front = [1.0 100.0; 2.0 200.0; 3.0 150.0]
        reference_front = [0.5 80.0; 1.5 120.0; 2.5 180.0]
        
        # Test default method (:reference_only)
        norm_front, norm_ref = normalize_fronts(front, reference_front)
        
        # Check dimensions are preserved
        @test size(norm_front) == size(front)
        @test size(norm_ref) == size(reference_front)
        
        # Reference front should be normalized to [0,1] range
        @test minimum(norm_ref[:, 1]) ≈ 0.0 atol=NORMALIZATION_TEST_ATOL
        @test maximum(norm_ref[:, 1]) ≈ 1.0 atol=NORMALIZATION_TEST_ATOL
        @test minimum(norm_ref[:, 2]) ≈ 0.0 atol=NORMALIZATION_TEST_ATOL
        @test maximum(norm_ref[:, 2]) ≈ 1.0 atol=NORMALIZATION_TEST_ATOL
    end

    @testset "normalize_fronts - Reference Only Method" begin
        front = [0.0 2.0; 4.0 6.0]
        reference_front = [1.0 3.0; 3.0 5.0]
        
        norm_front, norm_ref = normalize_fronts(front, reference_front; method=:reference_only)
        
        # Reference bounds: obj1 [1,3], obj2 [3,5]
        # Expected normalized reference: [0,0; 1,1]
        @test norm_ref ≈ [0.0 0.0; 1.0 1.0] atol=NORMALIZATION_TEST_ATOL
        
        # Expected normalized front: [-0.5 -0.5; 1.5 1.5]
        @test norm_front ≈ [-0.5 -0.5; 1.5 1.5] atol=NORMALIZATION_TEST_ATOL
    end

    @testset "normalize_fronts - MinMax Method" begin
        front = [1.0 5.0; 3.0 7.0]
        reference_front = [2.0 6.0; 4.0 8.0]
        
        norm_front, norm_ref = normalize_fronts(front, reference_front; method=:minmax)
        
        # Global bounds: obj1 [1,4], obj2 [5,8]
        # All values should be in [0,1]
        @test all(0.0 .<= norm_front .<= 1.0)
        @test all(0.0 .<= norm_ref .<= 1.0)
        
        # Check specific values
        expected_front = [0.0 0.0; 2/3 2/3]
        expected_ref = [1/3 1/3; 1.0 1.0]
        @test norm_front ≈ expected_front atol=NORMALIZATION_TEST_ATOL
        @test norm_ref ≈ expected_ref atol=NORMALIZATION_TEST_ATOL
    end

    @testset "normalize_fronts - Z-Score Method" begin
        front = [1.0 1.0; 2.0 2.0]
        reference_front = [3.0 3.0; 4.0 4.0]
        
        norm_front, norm_ref = normalize_fronts(front, reference_front; method=:zscore)
        
        # Check that mean is approximately 0
        combined_normalized = vcat(norm_front, norm_ref)
        @test abs(mean(combined_normalized[:, 1])) < NORMALIZATION_TEST_ATOL
        @test abs(mean(combined_normalized[:, 2])) < NORMALIZATION_TEST_ATOL
    end

    @testset "normalize_fronts - Edge Cases" begin
        # Identical fronts
        identical_front = [1.0 2.0; 3.0 4.0]
        norm_front, norm_ref = normalize_fronts(identical_front, identical_front)
        @test norm_front ≈ [0.0 0.0; 1.0 1.0] atol=NORMALIZATION_TEST_ATOL
        @test norm_ref ≈ [0.0 0.0; 1.0 1.0] atol=NORMALIZATION_TEST_ATOL

        # Constant column in reference front
        front_const = [1.0 2.0; 2.0 3.0]
        reference_const = [1.5 2.5; 1.5 2.5]  # First column is constant
        norm_front, norm_ref = normalize_fronts(front_const, reference_const)
        
        # First column should be centered around 0 (constant removed)
        @test norm_front[:, 1] ≈ [-0.5, 0.5] atol=NORMALIZATION_TEST_ATOL
        @test norm_ref[:, 1] ≈ [0.0, 0.0] atol=NORMALIZATION_TEST_ATOL

        # Single point fronts
        single_front = [2.0 3.0]
        single_ref = [1.0 2.0]
        norm_single_front, norm_single_ref = normalize_fronts(single_front, single_ref)
        @test norm_single_ref ≈ [0.0 0.0] atol=NORMALIZATION_TEST_ATOL

        # Dimension mismatch should throw error
        front_2d = [1.0 2.0]
        reference_3d = [1.0 2.0 3.0]
        @test_throws AssertionError normalize_fronts(front_2d, reference_3d)

        # Invalid method should throw error
        @test_throws ArgumentError normalize_fronts(front_const, reference_const; method=:invalid)
    end

    @testset "normalize_fronts - Three Objectives" begin
        front_3d = [1.0 10.0 100.0; 2.0 20.0 200.0]
        reference_3d = [0.5 5.0 50.0; 1.5 15.0 150.0]
        
        norm_front, norm_ref = normalize_fronts(front_3d, reference_3d)
        
        # Check all objectives are properly normalized
        @test size(norm_front) == (2, 3)
        @test size(norm_ref) == (2, 3)
        
        # Reference should span [0,1] for each objective
        for obj in 1:3
            @test minimum(norm_ref[:, obj]) ≈ 0.0 atol=NORMALIZATION_TEST_ATOL
            @test maximum(norm_ref[:, obj]) ≈ 1.0 atol=NORMALIZATION_TEST_ATOL
        end
    end

    @testset "normalize_front - Predefined Bounds" begin
        front = [1.0 100.0; 2.0 200.0; 3.0 150.0]
        min_bounds = [0.0, 50.0]
        max_bounds = [5.0, 250.0]
        
        normalized = normalize_front(front, min_bounds, max_bounds)
        
        # Check dimensions
        @test size(normalized) == size(front)
        
        # Check normalization correctness
        expected = [0.2 0.25; 0.4 0.75; 0.6 0.5]
        @test normalized ≈ expected atol=NORMALIZATION_TEST_ATOL
        
        # All values should be in reasonable range
        @test all(normalized .>= 0.0)
        @test all(normalized .<= 1.0)
    end

    @testset "normalize_front - Edge Cases" begin
        # Zero range in bounds
        front = [1.0 2.0; 3.0 4.0]
        min_bounds = [0.0, 3.0]
        max_bounds = [2.0, 3.0]  # Second objective has zero range
        
        normalized = normalize_front(front, min_bounds, max_bounds)
        
        # First objective should normalize properly
        @test normalized[:, 1] ≈ [0.5, 1.5] atol=NORMALIZATION_TEST_ATOL
        # Second objective should just subtract the constant
        @test normalized[:, 2] ≈ [-1.0, 1.0] atol=NORMALIZATION_TEST_ATOL

        # Dimension mismatch
        front_2d = [1.0 2.0]
        bounds_3d = [0.0, 0.0, 0.0]
        @test_throws AssertionError normalize_front(front_2d, bounds_3d, bounds_3d)

        # Single point
        single_point = [1.5 2.5]
        min_bounds_single = [1.0, 2.0]
        max_bounds_single = [2.0, 3.0]
        normalized_single = normalize_front(single_point, min_bounds_single, max_bounds_single)
        @test normalized_single ≈ [0.5 0.5] atol=NORMALIZATION_TEST_ATOL
    end

    @testset "normalize_fronts - Mathematical Properties" begin
        front = [1.0 10.0; 2.0 20.0; 3.0 30.0]
        reference_front = [0.5 5.0; 1.5 15.0; 2.5 25.0]
        
        # Test that relative ordering is preserved
        norm_front, norm_ref = normalize_fronts(front, reference_front)
        
        # Original ordering in first objective: 1 < 2 < 3
        @test norm_front[1, 1] < norm_front[2, 1] < norm_front[3, 1]
        # Original ordering in second objective: 10 < 20 < 30
        @test norm_front[1, 2] < norm_front[2, 2] < norm_front[3, 2]
        
        # Test that distance ratios are preserved (for reference_only method)
        original_diff_obj1 = front[2, 1] - front[1, 1]  # 2 - 1 = 1
        original_diff_obj2 = front[3, 1] - front[2, 1]  # 3 - 2 = 1
        
        normalized_diff_obj1 = norm_front[2, 1] - norm_front[1, 1]
        normalized_diff_obj2 = norm_front[3, 1] - norm_front[2, 1]
        
        # Ratios should be the same since differences are equal
        @test abs(normalized_diff_obj1 - normalized_diff_obj2) < NORMALIZATION_TEST_ATOL
    end
end