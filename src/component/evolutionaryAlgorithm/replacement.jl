struct MuPlusLambdaReplacement <: Replacement
    comparator::Comparator
end

function replace_(replacement::MuPlusLambdaReplacement, x::Vector{S}, y::Vector{S}) where {S<:Solution}
    jointVector = vcat(x, y)
    sort!(jointVector, lt=((a, b) -> compare(replacement.comparator, a, b) <= 0))
    return jointVector[1:length(x)]
end

struct MuCommaLambdaReplacement <: Replacement
    comparator::Comparator
end

function replace_(replacement::MuCommaLambdaReplacement, x::Vector{S}, y::Vector{S}) where {S<:Solution}
    @assert length(x) >= length(y) "The length of the x vector is lower than the length of the y vector"

    resultVector = Vector(y)
    sort!(resultVector, lt=((a, b) -> compare(replacement.comparator, a, b) <= 0))

    return resultVector[1:length(x)]
end

struct RankingAndDensityEstimatorReplacement <: Replacement
    ranking
    densityEstimator
    rankingAndDensityEstimatorComparator

    RankingAndDensityEstimatorReplacement(ranking, densityEstimator) = new(ranking, densityEstimator, RankingAndCrowdingDistanceComparator())
end


function replace_(replacement::RankingAndDensityEstimatorReplacement, x::Vector{T}, y::Vector{T})::Vector{T} where {T<:Solution}
    jointVector = vcat(x, y)

    compute!(replacement.ranking, jointVector)

    for rank in replacement.ranking.ranks
        compute!(replacement.densityEstimator, rank)
    end

    sort!(jointVector, lt=((x, y) -> compare(replacement.rankingAndDensityEstimatorComparator, x, y) < 0))
    return jointVector[1:length(x)]
end

mutable struct MOEADReplacement <: Replacement
    matingPoolSelection::PopulationAndNeighborhoodSelection
    weightVectorNeighborhood::WeightVectorNeighborhood
    aggregationFunction::AggregationFunction
    sequenceGenerator::SequenceGenerator
    maximumNumberOfReplacedSolutions::Int
    normalize::Bool
    idealPoint::IdealPoint
    nadirPoint::NadirPoint
    nonDominatedArchive::NonDominatedArchive
    firstReplacement::Bool

    MOEADReplacement(matingPoolSelection, weightVectorNeighborhood, aggregationFunction, sequenceGenerator, maxReplaced, normalize) = new(
        matingPoolSelection,
        weightVectorNeighborhood,
        aggregationFunction,
        sequenceGenerator,
        maxReplaced,
        normalize,
        IdealPoint(),
        NadirPoint(),
        NonDominatedArchive(ContinuousSolution{Float64}),
        true
    )
end

function replace_(replacement::MOEADReplacement, population::Vector{T}, offspring::Vector{T}) where {T <: Solution}
    new_solution = offspring[1]

    update_ideal_point!(replacement, population, new_solution)
    update_nadir_point!(replacement, population, new_solution)

    neighborType = replacement.matingPoolSelection.neighborhood.neighborType
    # NeighborType Neighbor = true
    random_permutation = if neighborType == true
        IntegerPermutationGenerator(size(replacement.weightVectorNeighborhood.neighborhood.neighborhoodSize, 1))
    else
        IntegerPermutationGenerator(length(population))
    end

    replacements = 0
    while replacements < replacement.maximumNumberOfReplacedSolutions && hasNext(random_permutation)
        # NeighborType Neighbor = true
        k = if neighborType == true
            replacement.weightVectorNeighborhood.neighborhood[replacement.sequenceGenerator.currentValue][generateNext!(random_permutation)]
        else
            generateNext!(random_permutation)
        end

        println(population[k])

        f1 = compute(replacement.aggregationFunction, population[k].objectives, replacement.weightVectorNeighborhood.weightVector[k], replacement.idealPoint, replacement.nadirPoint)
        f2 = compute(replacement.aggregationFunction, new_solution.objectives, replacement.weightVectorNeighborhood.weightVector[k], replacement.idealPoint, replacement.nadirPoint)

        if f2 < f1
            population[k] = copySolution(new_solution)
            replacements += 1
        end
    end

    generateNext!(replacement.sequenceGenerator)
    return population
end

function update_ideal_point!(replacement::MOEADReplacement, population::Vector{S}, new_solution::S) where {S <: Solution}
    if replacement.firstReplacement
        replacement.idealPoint = IdealPoint(length(new_solution.objectives))
        if replacement.normalize
            add_all!(replacement.nonDominatedArchive, population)
            add!(replacement.nonDominatedArchive, new_solution)
        end
        replacement.firstReplacement = false
    end
    update!(replacement.idealPoint, new_solution.objectives)
end

function update_nadir_point!(replacement::MOEADReplacement, population::Vector{S}, new_solution::S) where {S <: Solution}
    if replacement.normalize
        replacement.nadirPoint = NadirPoint(length(new_solution.objectives))
        add!(replacement.nonDominatedArchive, new_solution)
        for solution in replacement.nonDominatedArchive.solutions
            update!(replacement.nadirPoint, solution.objectives)
        end
    end
end

function add_all!(archive::NonDominatedArchive, solutions::Vector{S}) where {S <: Solution}
    for solution in solutions
        add!(archive, solution)
    end
end