struct FrequencySelectionMutationBasedPerturbation <: Perturbation 
    frequencyOfApplication::Int
    mutation::MutationOperator
end

function perturbate(perturbation::FrequencySelectionMutationBasedPerturbation, swarm)
    @assert length(swarm) > 0

    for i in 1:length(swarm)
        if i % perturbation.frequencyOfApplication == 0
            mutate(swarm[i], perturbation.mutation)
        end
    end
    
    return swarm
end
