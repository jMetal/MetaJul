function multiObjectiveTSP(fileNames::Vector{String})
  distanceMatrices = Vector{Matrix{Float64}}()

  for fileName in fileNames
    distanceMatrix = readTSPLibFile(fileName)
    push!(distanceMatrices, distanceMatrix)
  end

  problem = PermutationProblem()
  problem.name = "MTSP"
  problem.permutationLength = numberOfCities(length(distanceMatrices[0]))
  problem.constraints = []
  
end

function computeTourDistance(distanceMatrix, permutation::PermutationSolution)
  numberOfCities = length(permutation.variables)

  totalDistance = 0 
  cities = permutation.variables

  for i in 1:numberOfCities-1
    x = cities[i]
    y = cities[i+1]

    totalDistance += distanceMatrix[x, y]
  end

  firstCity = cities[1]
  lastCity = cities[numberOfCities]
  totalDistance += distanceMatrix[firstCity, lastCity]

  return totalDistance
end

function readTSPLibFile(fileName)
  lines = readlines(fileName)
  numberOfCities = length(lines) - 7
  nodes = lines[7:length(lines)-1]

  positions  = Vector{Int}(undef, 2*numberOfCities);
  for i in 1:numberOfCities
      numbers = split(nodes[i])
      index = parse(Int, numbers[1])
      position1 = parse(Int, numbers[2])
      position2 = parse(Int, numbers[3])
      positions[2*(index-1)+1] = position1
      positions[2*(index-1)+2] = position2
  end

  matrix = Array{Float64}(undef, numberOfCities, numberOfCities)
  c = positions
  for k in 1:numberOfCities
      matrix[k, k] = 0
      for j in k+1:numberOfCities
          dist = sqrt((c[(k-1)*2+1] - c[(j-1)*2+1])^2 + (c[(k-1)*2+2] - c[(j-1)*2+2])^2)
          dist = round(Int, dist)
          matrix[k, j] = dist
          matrix[j, k] = dist
      end
  end

  return matrix
end