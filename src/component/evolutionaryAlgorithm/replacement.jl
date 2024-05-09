struct MuPlusLambdaReplacement <: Replacement
    comparator::Function
end


function replace(x::Vector{Solution}, y::Vector{Solution}, replacement::MuPlusLambdaReplacement)
    jointVector = vcat(x, y)
    sort!(jointVector, lt=((a, b) -> replacement.comparator(a, b) <= 0))
    return jointVector[1:length(x)]
end

struct MuCommaLambdaReplacement <: Replacement
    comparator::Function
end

function replace(x::Vector{Solution}, y::Vector{Solution}, replacement::MuCommaLambdaReplacement)
    @assert length(x) >= length(y) "The length of the x vector is lower than the length of the y vector"

    resultVector = Vector(y)
    sort!(resultVector, lt=((a, b) -> replacement.comparator(a, b) <= 0))

    return resultVector[1:length(x)]
end

function compareRankingAndCrowdingDistance(x::Solution, y::Solution)::Int
    result = compareRanking(x, y)
    if (result == 0)
        result =   sdcs(x, y)
    end
    return result
end

struct RankingAndDensityEstimatorReplacement <: Replacement
    dominanceComparator::Function
end

function rankingAndDensityEstimatorReplacement(x::Vector{T}, y::Vector{T},
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

