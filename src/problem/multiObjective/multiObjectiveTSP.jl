struct MultiObjectiveTSP <: AbstractPermutationProblem
  name::String
  tourLength::Int
  distanceMatrices::Vector{Matrix{Float64}}
end

function multiObjectiveTSP(name, fileNames::Vector{String})
  distanceMatrices = Vector{Matrix{Float64}}()
  sizehint!(distanceMatrices, length(fileNames))

  for fileName in fileNames
    distanceMatrix = readTSPLibFile(fileName)
    push!(distanceMatrices, distanceMatrix)
  end

  tourLength = size(distanceMatrices[1], 1)

  return MultiObjectiveTSP(name, tourLength, distanceMatrices)
end

function numberOfVariables(problem::MultiObjectiveTSP)
  return problem.tourLength
end

function numberOfObjectives(problem::MultiObjectiveTSP)
  return length(problem.distanceMatrices)
end

function numberOfConstraints(problem::MultiObjectiveTSP)
  return 0 ;
end

function name(problem::MultiObjectiveTSP)
  return problem.name
end

function evaluate(solution::PermutationSolution, problem::MultiObjectiveTSP)::PermutationSolution
  objectives = []

  for distanceMatrix in problem.distanceMatrices
    push!(objectives, computeTourDistance(distanceMatrix, solution.variables))
  end

  solution.objectives = objectives

  return solution
end

function createSolution(problem::MultiObjectiveTSP)::PermutationSolution 
  solution = PermutationSolution(problem.tourLength)
  solution.objectives = zeros(numberOfObjectives(problem))
  solution.constraints = zeros(numberOfConstraints(problem))
  solution.attributes = Dict()

  return solution
end
