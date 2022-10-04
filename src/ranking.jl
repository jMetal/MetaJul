# Struct and methods to implement the non-dominated ranking sorting method
include("core.jl")

mutable struct Ranking{T <: Solution}
    rank::Vector{Vector{T}}
end 

function getSubFront(ranking::Ranking, rankId::Integer)
    message = string("The subfront id ", rankId, " is not in the range 1:", length(ranking.rank))
    @assert length(ranking.rank)  >= rankId message
    return ranking.rank[rankId]
end

function numberOfRanks(ranking::Ranking)
    return length(ranking.rank)
end

function appendRank!(newRank::Vector{T}, ranking::Ranking{T}) where {T <: Solution}
    push!(ranking.rank, newRank)
    return Nothing
end

"""
function getRank(solution::Solution)::Int where {T :< Solution}
    return solution.attributes.get("RANKING_ATTRIBUTE")
end

function computeRanking(solutions::Array{T})::Ranking{T} where {T <: Solution}
   return 
end



abstract type Archive end

struct nonDominatedArchive <: Archive
  solutions::Array{Solution}
  comparator::Function
  function nonDominatedArchive()

  end
end

function isEmpty(archive::nonDominatedArchive)::Bool
    return length(archive.solutions) == 0
end

function add(solution::Solution, archive::nonDominatedArchive)::Bool
    solutionIsInserted = false
    if isEmpty(archive)
        push!(solution, archive.solutions)
        solutionIsInserted = true
    else

    end
end
"""