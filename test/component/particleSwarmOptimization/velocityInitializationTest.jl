# Unit tests for DefaultVelocityInitialization

function inializeDefaultVelocityInitializationReturnTheRightResult()
    swarmSize = 10
    variables = [1.0, 0.1, 3.9]
    swarm = [ContinuousSolution{Float64}(variables, [1,1,3], [], Dict(), [Bounds{Float64}(1.0, 10.0), Bounds{Float64}(1.0, 10.0)]) for _ in 1:swarmSize]

    velocityInitialization = DefaultVelocityInitialization() 
    speed = initialize(velocityInitialization, swarm)

    return zeros(swarmSize, length(variables)) == speed
end

@testset "Default velocity initialization tests" begin    
    @test inializeDefaultVelocityInitializationReturnTheRightResult()
end

