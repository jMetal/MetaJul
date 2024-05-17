# Default velocity update strategy

struct DefaultVelocityUpdate <: VelocityUpdate
    c1Min
    c1Max
    c2Min
    c2Max
end

function update(velocityUpdate::DefaultVelocityUpdate, swarm, speed, localBest, leaders, globalBestSelection, inertiaWeightComputingStrategy)

    for i in 1:length(swarm)
        particle = copySolution(swarm[i])
        localBestParticle = copySolution(localBest[i])
        globalBestParticle = select(globalBestSelection, leaders)

        r1 = rand()
        r2 = rand()
        c1 = velocityUpdate.c1Min + rand() * (velocityUpdate.c1Max - velocityUpdate.c1Min)
        c2 = velocityUpdate.c2Min + rand() * (velocityUpdate.c2Max - velocityUpdate.c2Min)

        inertiaWeight = compute(inertiaWeightComputingStrategy)

        for j in 1:length(particle.variables)
            speed[i][j] = inertiaWeight * speed[i][j] + c1 * r1 * (localBestParticle.variables[j] - particle.variables[j]) + c2 * r2 * (globalBestParticle.variables[j] - particle.variables[j])

        end
    end

    return speed
end


# Constrained velocity update strategy

struct ConstrainedVelocityUpdate <: VelocityUpdate
    c1Min
    c1Max
    c2Min
    c2Max

    deltaMin::Vector
    deltaMax::Vector

    function ConstrainedVelocityUpdate(c1Min, c1Max, c2Min, c2Max, problem)
        deltaMin = Array{Float64}(undef, numberOfVariables(problem))
        deltaMax = Array{Float64}(undef, numberOfVariables(problem))

        for i in 1:numberOfVariables(problem)
            bounds = bounds(problem)[i]
            deltaMax[i] = (bounds.upperBound - bounds.lowerBound) / 2.0
            deltaMin[i] = -deltaMax[i]
        end

        return new(c1Min, c1Max, c2Min, c2Max, deltaMin, deltaMax)
    end
end

function update(velocityUpdate::ConstrainedVelocityUpdate, swarm, speed, localBest, leaders, globalBestSelection, inertiaWeightComputingStrategy)

    for i in 1:length(swarm)
        particle = copySolution(swarm[i])
        localBestParticle = copySolution(localBest[i])
        globalBestParticle = select(globalBestSelection, leaders)

        r1 = rand()
        r2 = rand()
        c1 = velocityUpdate.c1Min + rand() * (velocityUpdate.c1Max - velocityUpdate.c1Min)
        c2 = velocityUpdate.c2Min + rand() * (velocityUpdate.c2Max - velocityUpdate.c2Min)

        inertiaWeight = compute(inertiaWeightComputingStrategy)

        for j in 1:length(particle.variables)
            speed[i][j] = velocityConstriction(constrictionCoefficient(c1, c2) * inertiaWeight * speed[i][j] + c1 * r1 * (localBestParticle.variables[j] - particle.variables[j]) + c2 * r2 * (globalBestParticle.variables[j] - particle.variables[j]), velocityUpdate.deltaMin, velocityUpdate.deltaMax, j)
        end
    end

    return speed
end

function velocityConstriction(velocity, deltaMin, deltaMax, variableIndex)
    dmax = deltaMax[variableIndex]
    dmin = deltaMin[variableIndex]

    result = velocity

    if velocity > dmax
        result = dmax
    end

    if velocity < dmin
        result = dmin
    end

    return result
end

function constrictionCoefficient(c1, c2)
    rho = c1 + c2
    result
    if rho <= 4.0
        result = 1.0
    else
        result = 2.0 / (2.0 - rho - sqrt(rho^2.0 - 4.0 * rho))
    end

    return result
end