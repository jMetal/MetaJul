# Struct and methods to implement the non-dominated ranking sorting method
include("core.jl")
include("solution.jl")
include("archive.jl")

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

function appendRank!(ranking::Ranking{T}, newRank::Vector{T}) where {T <: Solution}
    push!(ranking.rank, newRank)
    return Nothing
end

function getRank(solution::T) where {T <: Solution}
    return solution.attributes["RANKING_ATTRIBUTE"]
end

function setRank(solution::T, rank::Int) where {T <: Solution}
    return solution.attributes["RANKING_ATTRIBUTE"] = rank
end

function computeRanking(solutions::Array{T})::Ranking{T} where {T <: Solution}
    ranking = Ranking{T}()

    solutionsToRank = [solution for solution in solutions]
    rankCounter = 1

    println("Solutions to rank. START: ", solutionsToRank)

    while length(solutionsToRank) > 0
        nonDominatedArchive = NonDominatedArchive{T}([])
        for (index, solution) in enumerate(solutionsToRank)
            solution.attributes["INDEX"] = index
            add!(nonDominatedArchive, solution)
        end

        counterOfDeletedSolutions = 0
        for solution in nonDominatedArchive.solutions
            setRank(solution, rankCounter)
            println("Index: ", solution.attributes["INDEX"])
            deleteat!(solutionsToRank, solution.attributes["INDEX"]-counterOfDeletedSolutions)
            counterOfDeletedSolutions += 1
        end

        println("Solutions to rank: ", solutionsToRank)
        appendRank!(ranking, nonDominatedArchive.solutions)
        
        rankCounter += 1
    end

    return ranking
end
