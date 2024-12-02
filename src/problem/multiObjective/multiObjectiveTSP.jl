struct MultiObjectiveTSP <: AbstractPermutationProblem
  name::String
  tourLength::Int
  distanceMatrices::Vector{Matrix{Float64}}
end

function multiObjectiveTSP(name, distanceMatrices::Vector{Matrix{Float64}})
  problem = PermutationProblem(name)

  tourLength = size(distanceMatrices[1], 1)
  problem.permutationLength = tourLength

  for distanceMatrix in distanceMatrices
    f = tour -> computeTourDistance(distanceMatrix, tour)
    addObjective(problem, f)
  end

  problem.constraints = []

  return problem
end

function multiObjectiveTSP(name, fileNames::Vector{String})
  distanceMatrices = Vector{Matrix{Float64}}()
  sizehint!(distanceMatrices, length(fileNames))

  for fileName in fileNames
    distanceMatrix = readTSPLibFile(fileName)
    push!(distanceMatrices, distanceMatrix)
  end

  return multiObjectiveTSP(name, distanceMatrices)
end
