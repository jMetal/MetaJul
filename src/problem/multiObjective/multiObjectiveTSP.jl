# Function to create a multi-objective TSP problem from given distance matrices
# name: The name of the problem
# distanceMatrices: A vector of matrices where each matrix represents the distance between cities for one objective
function multiObjectiveTSP(name, distanceMatrices::Vector{Matrix{Float64}})
  # Create a permutation problem instance with the given name
  problem = PermutationProblem(name)

  # Determine the number of cities (length of the tour) from the first distance matrix
  tourLength = size(distanceMatrices[1], 1)
  problem.permutationLength = tourLength

  # Loop through each distance matrix and create an objective function
  for distanceMatrix in distanceMatrices
      # Define the objective function to compute the tour distance for the given distance matrix
      f = tour -> computeTourDistance(distanceMatrix, tour)
      # Add the objective function to the problem
      addObjective(problem, f)
  end

  # Initialize an empty list of constraints (no constraints in this example)
  problem.constraints = []

  # Return the configured multi-objective TSP problem
  return problem
end

# Function to create a multi-objective TSP problem from given file names containing distance matrices
# name: The name of the problem
# fileNames: A vector of strings where each string is a file name containing a distance matrix
function multiObjectiveTSP(name, fileNames::Vector{String})
  # Initialize an empty vector to hold the distance matrices
  distanceMatrices = Vector{Matrix{Float64}}()
  # Provide a size hint for the vector based on the number of file names
  sizehint!(distanceMatrices, length(fileNames))

  # Loop through each file name and read the corresponding distance matrix
  for fileName in fileNames
      # Read the distance matrix from the file
      distanceMatrix = readTSPLibFile(fileName)
      # Add the distance matrix to the vector
      push!(distanceMatrices, distanceMatrix)
  end

  # Create and return the multi-objective TSP problem using the distance matrices
  return multiObjectiveTSP(name, distanceMatrices)
end