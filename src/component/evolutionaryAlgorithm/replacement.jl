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
    sort!(resultVector, lt=((a, b) -> compare(replacement.comparator, a, b) <= 0))

    return resultVector[1:length(x)]
end

struct RankingAndDensityEstimatorReplacement <: Replacement
    ranking
    densityEstimator
end

function replace_(replacement::RankingAndDensityEstimatorReplacement, x::Vector{T}, y::Vector{T})::Vector{T} where {T<:Solution}
    jointVector = vcat(x, y)

    compute!(replacement.ranking, jointVector)

    for rank in ranking.rank
        compute!(replacement.densityEstimator, rank)
    end

    sort!(jointVector, lt=((x, y) -> compare(replacement.rankingAndCrowdingDistanceComparator, x, y) < 0))
    return jointVector[1:length(x)]
end

