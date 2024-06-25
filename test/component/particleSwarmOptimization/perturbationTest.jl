# Unit tests for FrequencySelectionMutationBasedPerturbation

function constructorIsCorrectlyInitialized()
    frequencyOfApplication = 5 
    mutationOperator = PolynomialMutation(probability = 0.5, distributionIndex = 20.0, bounds = [Bounds{Float64}(1.0, 10.0)]) ;

    perturbation = FrequencySelectionMutationBasedPerturbation(frequencyOfApplication, mutationOperator)

    return frequencyOfApplication == perturbation.frequencyOfApplication && mutationOperator == perturbation.mutation
end


function perturbationOnlyModifiesTheRightParticle()
    frequencyOfApplication = 2 
    mutationOperator = PolynomialMutation(probability = 1.0, distributionIndex = 20.0, bounds = [Bounds{Float64}(1.0, 10.0), Bounds{Float64}(1.0, 10.0)]) ;

    bounds = [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(10, 20.0)]
    particle1 = ContinuousSolution{Float64}([1.0, 2.0], [1.5, 2.5], [], Dict(), bounds)
    particle2 = ContinuousSolution{Float64}([2.0, 4.0], [2.5, 4.5], [], Dict(), bounds)
    particle3 = ContinuousSolution{Float64}([1.3, 5.2], [3.5, 5.5], [], Dict(), bounds)

    swarm = [copySolution(particle1), copySolution(particle2), copySolution(particle3)]

    perturbation = FrequencySelectionMutationBasedPerturbation(frequencyOfApplication, mutationOperator)

    swarm = perturbate!(perturbation, swarm)

    return particle2.variables != swarm[2].variables && isequal(particle1, swarm[1]) && isequal(particle3, swarm[3])
end

@testset "Perturbation tests" begin    
    @test constructorIsCorrectlyInitialized()
    @test perturbationOnlyModifiesTheRightParticle()
end