include("core.jl")
include("solution.jl")
include("comparator.jl")

abstract type Archive end

struct NonDominatedArchive{T} <: Archive where {T}
  solutions::Array{T}
end

function isEmpty(archive::NonDominatedArchive)::Bool
    return length(archive.solutions) == 0
end

function Base.length(archive::NonDominatedArchive)::Int
  return length(archive.solutions)
end

function add(archive::NonDominatedArchive{T}, solution::T, comparator::Function = dominanceComparator)::Bool where {T <: Solution}
    solutionIsInserted = false
    if isEmpty(archive)
        push!(archive.solutions, solution)
        solutionIsInserted = true
    else
      if dominanceComparator(solution.objectives, archive.solutions[1].objectives) == 0
        push!(archive.solutions, solution)
        solutionIsInserted = true
      elseif dominanceComparator(solution.objectives, archive.solutions[1].objectives) == -1
        deleteat!(archive.solutions, 1)
        push!(archive.solutions, solution)
        solutionIsInserted = true
      end
    end

    return solutionIsInserted
end