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

# Enum for NeighborType
@enum NeighborType begin
    NEIGHBOR
    POPULATION
    ARCHIVE
end

#abstract type Neighborhood{S} end

struct PopulationAndNeighborhoodSelection{T} <: Selection
    matingPoolSize::Int
    solutionIndexGenerator::Function
    neighborhood::Neighborhood{T}
    neighborhoodSelectionProbability::Float64
    selectCurrentSolution::Bool
    selectionOperator::SelectionOperator
end

# Constructor for PopulationAndNeighborhoodSelection
function PopulationAndNeighborhoodSelection(matingPoolSize::Int,
                                             solutionIndexGenerator::Function,
                                             neighborhood::Neighborhood{T},
                                             neighborhoodSelectionProbability::Float64,
                                             selectCurrentSolution::Bool) where T
    selectionOperator = NaryRandomSelection(selectCurrentSolution ? matingPoolSize - 1 : matingPoolSize)
    return PopulationAndNeighborhoodSelection(matingPoolSize, solutionIndexGenerator, neighborhood, neighborhoodSelectionProbability, selectCurrentSolution, selectionOperator)
end

# Selection method for PopulationAndNeighborhoodSelection
function select(selection::PopulationAndNeighborhoodSelection{T}, solutionList::Vector{T})::Vector{T} where T
    matingPool = Vector{T}()
    randomValue = rand()

    if randomValue < selection.neighborhoodSelectionProbability
        # Select from neighborhood
        neighborType = NEIGHBOR
        neighbors = selection.neighborhood.getNeighbors(solutionList, selection.solutionIndexGenerator())
        matingPool = selection.selectionOperator.execute(neighbors, selectionOperator)
    else
        # Select from population
        neighborType = POPULATION
        matingPool = selection.selectionOperator.execute(solutionList, selection.selectionOperator)
    end

    if selection.selectCurrentSolution
        # Add the current solution to the mating pool
        currentSolution = solutionList[selection.solutionIndexGenerator()]
        push!(matingPool, currentSolution)
    end

    @assert length(matingPool) == selection.matingPoolSize string("The mating pool size ", length(matingPool), " is not equal to the required size ", selection.matingPoolSize)

    return matingPool
end