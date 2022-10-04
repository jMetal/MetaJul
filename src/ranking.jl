# Struct and methods to implement the non-dominated ranking sorting method
include("core.jl")

mutable struct Ranking{T <: Solution}
    rank::Array{Array{T}}
end 

function getSubFront(ranking::Ranking, subFrontId::Integer)
    return ranking.rank[subFrontId]
end

function numberOfSubFronts(ranking::Ranking)
    return length(ranking.rank)
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