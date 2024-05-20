# Unit tests for DefaultPositionUpdate

function defaultPositionUpdateConstructorIsCorrectlyInitialized()
    velocityChangeWhenLowerLimitIsReached = -1.0
    velocityChangeWhenUpperLimitIsReached = 0.25
    positionBounds = [Bounds{Float64}(1.0, 10.0)]

    positionUpdate = DefaultPositionUpdate(velocityChangeWhenLowerLimitIsReached, velocityChangeWhenUpperLimitIsReached, positionBounds)

    return velocityChangeWhenLowerLimitIsReached == positionUpdate.velocityChangeWhenLowerLimitIsReached && velocityChangeWhenUpperLimitIsReached == positionUpdate.velocityChangeWhenUpperLimitIsReached && positionBounds == positionUpdate.positionBounds
end


function positionUpdateWorksProperlyWithASingleParticle()
    velocityChangeWhenLowerLimitIsReached = -1.0
    velocityChangeWhenUpperLimitIsReached = 0.25
    positionBounds = [Bounds{Float64}(-10.0, 10.0), Bounds{Float64}(-15.0, 15.0)]
    speed = [0.5 -0.5]
    variables = [2.0, 4.0]

    particle = ContinuousSolution{Float64}(copy(variables), [1.5, 2.5], [], Dict(), positionBounds)
    swarm = [particle]

    positionUpdate = DefaultPositionUpdate(velocityChangeWhenLowerLimitIsReached, velocityChangeWhenUpperLimitIsReached, positionBounds)

    update(positionUpdate, swarm, speed)

    return [2.5, 3.5] == particle.variables
end

function positionUpdateWorksProperlyWithASingleParticleWithPositionsOutOfBounds()
    velocityChangeWhenLowerLimitIsReached = -1.0
    velocityChangeWhenUpperLimitIsReached = 1
    positionBounds = [Bounds{Float64}(-10.0, 10.0), Bounds{Float64}(-15.0, 15.0)]
    speed = [-1.0 1.0]
    variables = [-9.5, 14.5]

    particle = ContinuousSolution{Float64}(copy(variables), [1.5, 2.5], [], Dict(), positionBounds)
    swarm = [particle]

    positionUpdate = DefaultPositionUpdate(velocityChangeWhenLowerLimitIsReached, velocityChangeWhenUpperLimitIsReached, positionBounds)

    update(positionUpdate, swarm, speed)

    return [-10.0, 15.0] == particle.variables
end


@testset "Default position update tests" begin    
    @test defaultPositionUpdateConstructorIsCorrectlyInitialized()
    @test positionUpdateWorksProperlyWithASingleParticle()
    @test positionUpdateWorksProperlyWithASingleParticleWithPositionsOutOfBounds()
end
