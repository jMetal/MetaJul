struct RandomSelection <: Selection
    matingPoolSize::Int
    withReplacement::Bool
end

function select(vector::Vector, selection::RandomSelection)::Vector
    matingPoolSize::Int = selection.matingPoolSize
    withReplacement::Bool = selection.withReplacement
    if withReplacement
        result = [vector[rand(1:length(vector))] for _ in range(1, matingPoolSize)]

        return result
    else
        @assert matingPoolSize <= length(vector) string("The mating pool size ", matingPoolSize, " is higher than the population size ", length(vector))
        result = [vector[i] for i in randperm(length(vector))[1:matingPoolSize]]

        return result
    end
end


function select(solutions::Vector{T}, selection::RandomSelection)::Vector{T} where {T<:Solution}
    matingPoolSize::Int = selection.matingPoolSize
    withReplacement::Bool = selection.withReplacement
    if withReplacement
        result = [solutions[rand(1:length(solutions))] for _ in range(1, matingPoolSize)]

        return result
    else
        @assert matingPoolSize <= length(solutions) string("The mating pool size ", matingPoolSize, " is higher than the population size ", length(solutions))
        result = [solutions[i] for i in randperm(length(solutions))[1:matingPoolSize]]

        return result
    end
end

struct BinaryTournamentSelection <: Selection
    matingPoolSize::Int
    comparator::Function
end

function select(solutions::Vector{S}, selection::BinaryTournamentSelection)::Vector{S} where {S<:Solution}
    matingPoolSize::Int = selection.matingPoolSize
    selectionOperator = BinaryTournamentSelectionOperator(selection.comparator)
    return [select(solutions, selectionOperator) for _ in range(1, matingPoolSize)]
end

