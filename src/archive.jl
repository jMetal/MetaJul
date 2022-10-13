include("core.jl")
include("solution.jl")
include("comparator.jl")

abstract type Archive end


"""
  struct containing an unbounded archive of non-dominated solutions
"""
struct NonDominatedArchive{T} <: Archive where {T}
  solutions::Array{T}
end

function isEmpty(archive::Archive)::Bool
    return length(archive.solutions) == 0
end

function Base.length(archive::Archive)::Int
  return length(archive.solutions)
end

function add!(archive::NonDominatedArchive{T}, solution::T, comparator::Function = compareForDominance)::Bool where {T <: Solution}
    solutionIsInserted = false
    if isEmpty(archive)
        push!(archive.solutions, solution)
        solutionIsInserted = true
    else
      solutionIsDominated = false
      solutionIsAlreadyInTheArchive = false
      currentSolutionIndex = 1
      while !solutionIsDominated && !solutionIsAlreadyInTheArchive && currentSolutionIndex <= length(archive)
        result = comparator(solution.objectives, archive.solutions[currentSolutionIndex].objectives)
        if result == -1
          deleteat!(archive.solutions, 1)
        elseif result == 1
          solutionIsDominated = true
        elseif isequal(solution.objectives, archive.solutions[currentSolutionIndex].objectives)
          solutionIsAlreadyInTheArchive = true
        else
          currentSolutionIndex += 1
        end
      end

      if !solutionIsDominated && !solutionIsAlreadyInTheArchive
        push!(archive.solutions, solution)
        solutionIsInserted = true
      end
    end

    return solutionIsInserted
end

function contain(archive::NonDominatedArchive{T}, solution::T)::Bool where {T <: Solution}
  result = false
  for solutionInArchive in archive.solutions
    if isequal(solutionInArchive.objectives, solution.objectives)
      result = true 
      break
    end
  end

  return result
end
