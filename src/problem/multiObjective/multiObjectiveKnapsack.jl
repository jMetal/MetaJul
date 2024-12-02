"""
    multiObjectiveKnapsack(profits::Matrix{Int}, weights::Matrix{Int}, capacities::Vector{Int}) -> BinaryProblem

Create a multi-objective knapsack problem instance.

# Arguments
- `profits::Matrix{Int}`: A matrix where each row represents the profits for each item in a different objective.
- `weights::Matrix{Int}`: A matrix where each row represents the weights of each item for a different constraint.
- `capacities::Vector{Int}`: A vector representing the capacity constraints.

# Returns
- `BinaryProblem`: A problem instance for the multi-objective knapsack problem.
"""

function multiObjectiveKnapsack(profits::Matrix{Int}, weights::Matrix{Int}, capacities::Vector{Int}) 
  numberOfBits = size(profits,2)

  problem = BinaryProblem(numberOfBits, "MultiObjectiveKnapsack")

  # Add objectives to the problem
  for i in 1:size(profits, 1)
    f = x -> begin
      totalProfit = 0;
      for bitIndex in 1:numberOfBits
        if x.bits[bitIndex]
          totalProfit += profits[i, bitIndex]
        end
      end 
      return -totalProfit
    end
    addObjective(problem, f)
  end

  # Add constraints to the problem
  for i in 1:size(weights, 1)
    c = x -> begin
      totalWeight = 0;
      for bitIndex in 1:numberOfBits
        if x.bits[bitIndex]
          totalWeight += weights[i, bitIndex]
        end
      end 
      constraintValue = capacities[i] - totalWeight
      return constraintValue < 0 ? constraintValue : 0 
    end
    addConstraint(problem, c)
  end

  return problem
end

