@testset "Constant value tests" begin    
    @test 25 == ConstantValueStrategy(25).inertiaWeight
    @test 30.5 == compute(ConstantValueStrategy(30.5))
end

