# Struct and methods to implement the non-dominated ranking sorting method
include("core.jl")
include("solution.jl")

mutable struct Ranking{T <: Solution}
    rank::Vector{Vector{T}}
end 

Ranking{T}() where {T <: Solution} = Ranking{T}(Vector{Vector{T}}(undef, 0))

function getSubFront(ranking::Ranking, rankId::Integer)
    message = string("The subfront id ", rankId, " is not in the range 1:", length(ranking.rank))
    @assert length(ranking.rank)  >= rankId message
    return ranking.rank[rankId]
end

function numberOfRanks(ranking::Ranking)::Int
    return length(ranking.rank)
end

function appendRank!(newRank::Vector{T}, ranking::Ranking{T}) where {T <: Solution}
    push!(ranking.rank, newRank)
    return Nothing
end

function getRank2(solution::T) where {T <: Solution}
    return solution.attributes.get("RANKING_ATTRIBUTE")
end

function computeRanking(solutions::Array{T})::Ranking{T} where {T <: Solution}
    @assert length(solutions) == 0 "The solution list is empty"

   return 
end
