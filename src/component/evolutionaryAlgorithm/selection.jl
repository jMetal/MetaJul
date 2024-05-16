struct RandomSelection <: Selection
    matingPoolSize::Int
    withReplacement::Bool
end

function select(selection::RandomSelection, vector::Vector)::Vector
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


function select(selection::RandomSelection, solutions::Vector{T})::Vector{T} where {T<:Solution}
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
    comparator::Comparator
end

function select(selection::BinaryTournamentSelection, solutions::Vector{S})::Vector{S} where {S<:Solution}
    matingPoolSize::Int = selection.matingPoolSize
    selectionOperator = BinaryTournamentSelectionOperator(selection.comparator)
    return [select(solutions, selectionOperator) for _ in range(1, matingPoolSize)]
end

