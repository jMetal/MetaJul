struct MuPlusLambdaReplacement <: Replacement
    comparator::Comparator
end

function replace_(x::Vector{S}, y::Vector{S}, replacement::MuPlusLambdaReplacement) where {S <: Solution}
    jointVector = vcat(x, y)
    sort!(jointVector, lt=((a, b) -> compare(replacement.comparator, a, b) <= 0))
    return jointVector[1:length(x)]
end

struct MuCommaLambdaReplacement <: Replacement
    comparator::Comparator
end

function replace_(x::Vector{S}, y::Vector{S}, replacement::MuCommaLambdaReplacement) where {S <: Solution}
    @assert length(x) >= length(y) "The length of the x vector is lower than the length of the y vector"

    resultVector = Vector(y)
    sort!(resultVector, lt=((a, b) -> compare(replacement.comparator,a, b) <= 0))

    return resultVector[1:length(x)]
end

struct RankingAndDensityEstimatorReplacement <: Replacement
    dominanceComparator::Function
end

function replace_(x::Vector{T}, y::Vector{T},
    replacement::RankingAndDensityEstimatorReplacement)::Vector{T} where {T<:Solution}
    jointVector = vcat(x, y)

    ranking = Ranking{T}(replacement.dominanceComparator)
    computeRanking!(ranking, jointVector)

    for rank in ranking.rank
        computeCrowdingDistanceEstimator!(rank)
    end

    sort!(jointVector, lt=((x, y) -> compareRankingAndCrowdingDistance(x, y) < 0))
    return jointVector[1:length(x)]
end

