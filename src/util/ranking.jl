# Struct and methods to implement the non-dominated ranking sorting method

mutable struct DominanceRanking <: Ranking
    rank::Vector
    dominanceComparator::Comparator
end 

function DominanceRanking(dominanceComparator::Comparator)  
    DominanceRanking(Vector{Vector}(undef, 0), dominanceComparator)
end

function DominanceRanking() 
     return DominanceRanking(DefaultDominanceComparator())
end

function getSubFront(ranking::DominanceRanking, rankId::Integer)
    message = string("The subfront id ", rankId, " is not in the range 1:", length(ranking.rank))
    @assert length(ranking.rank)  >= rankId message
    return ranking.rank[rankId]
end

function numberOfRanks(ranking::DominanceRanking)::Int
    return length(ranking.rank)
end

function appendRank!(ranking::DominanceRanking, newRank::Vector{T}) where {T <: Solution}
    push!(ranking.rank, newRank)
    return Nothing
end

function getRank(solution::Solution) 
    return get(solution.attributes,"RANKING_ATTRIBUTE", 0)
end

function setRank(solution::Solution, rank::Int) 
    return solution.attributes["RANKING_ATTRIBUTE"] = rank
end

struct DominanceRankingComparator <: Comparator end

function compare(comparator::DominanceRankingComparator, solution1::Solution, solution2::Solution) 
    result = 0
    if getRank(solution1) < getRank(solution2)
        result = -1
    elseif getRank(solution1) > getRank(solution2)
        result = 1
    end

    return result
end

function compute!(ranking::DominanceRanking, solutions::Array{T}) where {T <: Solution}
    ranking.rank = []
    solutionsToRank = [solution for solution in solutions]
    rankCounter = 1

    while length(solutionsToRank) > 0
        nonDominatedArchive = NonDominatedArchive(T[], ranking.dominanceComparator)
        for (index, solution) in enumerate(solutionsToRank)
            solution.attributes["INDEX"] = index
            add!(nonDominatedArchive, solution)
        end

        counterOfDeletedSolutions = 0
        for solution in nonDominatedArchive.solutions
            setRank(solution, rankCounter)
            deleteat!(solutionsToRank, solution.attributes["INDEX"]-counterOfDeletedSolutions)
            counterOfDeletedSolutions += 1
        end

        appendRank!(ranking, nonDominatedArchive.solutions)
        
        rankCounter += 1
    end
end
