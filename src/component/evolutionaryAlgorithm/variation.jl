using Base.Iterators

struct CrossoverAndMutationVariation <: Variation
    offspringPopulationSize::Int
    crossover::CrossoverOperator
    mutation::MutationOperator
    matingPoolSize::Int

    function CrossoverAndMutationVariation(offspringPopulationSize, crossover::CrossoverOperator, mutation::MutationOperator)
        matingPoolSize = offspringPopulationSize * numberOfRequiredParents(crossover) / numberOfDescendants(crossover)

        remainder = matingPoolSize % numberOfRequiredParents(crossover)
        if remainder != 0
            matingPoolSize += remainder
        end

        return new(offspringPopulationSize, crossover, mutation, matingPoolSize)
    end
end

function variate(solutions::Vector{S}, matingPool::Vector{S}, variation::CrossoverAndMutationVariation)::Vector{S} where {S <: Solution} 
    parents = collect(zip(matingPool[1:2:end], matingPool[2:2:end]))

    crossover = variation.crossover
    mutation = variation.mutation
    offspringPopulationSize = variation.offspringPopulationSize

    crossedSolutions = [recombine(parent[1], parent[2], crossover) for parent in parents]
    solutionsToMutate = collect(flatten(crossedSolutions))
    offpring = [mutate(solutionsToMutate[i], mutation) for i in range(1, offspringPopulationSize)]

    return offpring
end
