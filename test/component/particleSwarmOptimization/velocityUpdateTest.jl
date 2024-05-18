# Unit tests for DefaultVelocityUpdate

function defaultVelocityUpdateIsCorrectlyInitialized()
    c1Min = 0.1
    c1Max = 0.5
    c2Min = 0.2
    c2Max = 0.6
    
    velocityUpdate = DefaultVelocityUpdate(c1Min, c1Max, c2Min, c2Max)

    return c1Min == velocityUpdate.c1Min && c1Max == velocityUpdate.c1Max && c2Min == velocityUpdate.c2Min && c2Max == velocityUpdate.c2Max 
end


@testset "DefaultVelocityUpdate tests" begin    
    @test defaultVelocityUpdateIsCorrectlyInitialized()
end

# Unit tests for ConstrainedVelocityUpdate

function constrainedVelocityUpdateIsCorrectlyInitialized()
    c1Min = 0.1
    c1Max = 0.5
    c2Min = 0.2
    c2Max = 0.6
    problem = fonseca()

    velocityUpdate = ConstrainedVelocityUpdate(c1Min, c1Max, c2Min, c2Max, problem)
    
    # Bounds for the tree variables of problen Fonseca: [-4.0, 4.0]
    deltaMax = [(4.0 - -4.0)/2.0 for _ in 1:3]
    deltaMin = -deltaMax


    return c1Min == velocityUpdate.c1Min && c1Max == velocityUpdate.c1Max && c2Min == velocityUpdate.c2Min && c2Max == velocityUpdate.c2Max && deltaMax == velocityUpdate.deltaMax && deltaMin == velocityUpdate.deltaMin
end

@testset "ConstrainedVelocityUpdate tests" begin    
    @test constrainedVelocityUpdateIsCorrectlyInitialized()
end