"""
  struct containing an unbounded archive of non-dominated solutions
"""

struct NonDominatedArchive{T <: Solution} <: Archive
  solutions::Array{T}
  comparator::Comparator
end

function NonDominatedArchive(T::Type{<: Solution})
  return NonDominatedArchive{T}(T[], DefaultDominanceComparator())
end

function Base.length(archive::Archive)::Int
  return length(archive.solutions)
end

function isEmpty(archive::Archive)::Bool
  return length(archive) == 0
end

function getSolutions(archive::Archive)
  return archive.solutions
end

function add!(archive::NonDominatedArchive{T}, solution::T)::Bool where {T <: Solution}
    comparator = archive.comparator
    solutionIsInserted = false
    if isEmpty(archive)
        push!(archive.solutions, solution)
        solutionIsInserted = true
    else
      solutionIsDominated = false
      solutionIsAlreadyInTheArchive = false
      currentSolutionIndex = 1
      while !solutionIsDominated && !solutionIsAlreadyInTheArchive && currentSolutionIndex <= length(archive)
        result = compare(comparator, solution, archive.solutions[currentSolutionIndex])
        if result == -1
          deleteat!(archive.solutions, currentSolutionIndex)
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

# Crowding distance archive 
struct CrowdingDistanceArchive{T<:Solution} <: Archive
  capacity::Int
  internalNonDominatedArchive::NonDominatedArchive{T}
  crowdingDistanceComparator::CrowdingDistanceComparator
  densityEstimator::CrowdingDistanceDensityEstimator
end

function CrowdingDistanceArchive(capacity::Int, T::Type{<:Solution})
  return CrowdingDistanceArchive(capacity, NonDominatedArchive(T), CrowdingDistanceComparator(), CrowdingDistanceDensityEstimator()) 
end

function Base.length(archive::CrowdingDistanceArchive)::Int
  return length(archive.internalNonDominatedArchive)
end

function isEmpty(archive::CrowdingDistanceArchive)::Bool
  return length(archive) == 0
end

function isFull(archive::CrowdingDistanceArchive)
  return length(archive.internalNonDominatedArchive) == archive.capacity
end

function capacity(archive::CrowdingDistanceArchive)::Int
  return archive.capacity
end

function contain(archive::CrowdingDistanceArchive{T}, solution::T)::Bool where {T<:Solution}
  return contain(archive.internalNonDominatedArchive, solution)
end

function getSolutions(archive::CrowdingDistanceArchive{T})::Vector{T} where {T<:Solution}
  return getSolutions(archive.internalNonDominatedArchive)
end


#function computeCrowdingDistanceEstimator!(archive::CrowdingDistanceArchive{T}) where {T<:Solution}
#  return computeCrowdingDistanceEstimator!(archive.internalNonDominatedArchive.solutions)
#end

function add!(archive::CrowdingDistanceArchive{T}, solution::T)::Bool where {T<:Solution}
  archiveIsFull = isFull(archive)
  solutionIsAdded = add!(archive.internalNonDominatedArchive, solution)

  if solutionIsAdded && archiveIsFull
      compute!(archive.densityEstimator, getSolutions(archive))
      crowdingDistanceComparator = archive.crowdingDistanceComparator
      sort!(getSolutions(archive), lt=((x, y) -> compare(crowdingDistanceComparator, x, y) < 0))

      deletedSolution = pop!(getSolutions(archive))
      if deletedSolution == solution
          solutionIsAdded = false
      end
  end

  return solutionIsAdded
end



