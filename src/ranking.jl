include("core.jl")
include("solution.jl")
include("archive.jl")

# Struct and methods to implement the non-dominated ranking sorting method

using Test

mutable struct Ranking{T <: Solution}
    rank::Vector{Vector{T}}
    comparator::Function
end 

function Ranking{T}(dominanceComparator::Function) where {T <: Solution} 
    Ranking{T}(Vector{Vector{T}}(undef, 0), dominanceComparator)
end

function Ranking{T}() where {T <: Solution} 
     return Ranking{T}(compareForDominance)
end

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

function getRank(solution::Solution) 
    return get(solution.attributes,"RANKING_ATTRIBUTE", 0)
end

function setRank(solution::Solution, rank::Int) 
    return solution.attributes["RANKING_ATTRIBUTE"] = rank
end

function compareRanking(solution1::Solution, solution2::Solution) 
    result = 0
    if getRank(solution1) < getRank(solution2)
        result = -1
    elseif getRank(solution1) > getRank(solution2)
        result = 1
    end

    return result
end

function computeRanking(solutions::Array{T})::Ranking{T} where {T <: Solution}
    ranking = Ranking{T}()

    solutionsToRank = [solution for solution in solutions]
    rankCounter = 1

    while length(solutionsToRank) > 0
        nonDominatedArchive = NonDominatedArchive(T[], ranking.comparator)
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

    return ranking
end

"""

function computeRankingV2(solutions::Array{T})::Ranking{T} where {T <: Solution}
    ranking = Ranking{T}()

        # number of solutions dominating solution ith
        dominating_ith = [0 for _ in range(len(solutions))]

        # list of solutions dominated by solution ith
        ith_dominated = [[] for _ in range(len(solutions))]

        # front[i] contains the list of solutions belonging to front i
        front = [[] for _ in range(len(solutions) + 1)]

        for p in range(len(solutions) - 1)
            for q in range(p + 1, len(solutions))
                dominance_test_result = self.comparator.compare(solutions[p], solutions[q])
                self.number_of_comparisons += 1

                if dominance_test_result == -1
                    ith_dominated[p].append(q)
                    dominating_ith[q] += 1
                elseif dominance_test_result == 1
                    ith_dominated[q].append(p)
                    dominating_ith[p] += 1
                end
            end
        for i in range(1:len(solutions))
            if dominating_ith[i] == 0
                front[0].append(i)
                solutions[i].attributes["dominance_ranking"] = 0
            end
        end

        i = 0
        while len(front[i]) != 0
            i += 1
            for p in front[i - 1]
                if p <= len(ith_dominated)
                    for q in ith_dominated[p]
                        dominating_ith[q] -= 1
                        if dominating_ith[q] == 0
                            front[i].append(q)
                            solutions[q].attributes["dominance_ranking"] = i
                        end
                    end
                end
            end
        end

        self.ranked_sublists = [[]] * i
        for j in range(i)
            q = [0] * len(front[j])
            for m in range(len(front[j]))
                q[m] = solutions[front[j][m]]
            end
            self.ranked_sublists[j] = q
        end

        if k
            count = 0
            for i, front in enumerate(ranked_sublists)
                count += len(front)
                if count >= k
                    self.ranked_sublists = self.ranked_sublists[: i + 1]
                    break
                end
            end
        end

        return self.ranked_sublists
end
"""