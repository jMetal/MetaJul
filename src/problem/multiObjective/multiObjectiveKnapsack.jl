function multiObjectiveKnapsak(profits::Matrix{Int}, weights::Matrix{Int}, capacities::Vector{Int}) 
  numberOfBits = size(profits,2)

  problem = BinaryProblem(numberOfBits, "MultiObjectiveKnapsack")

  for i in 1:size(profits, 1)
    f = x -> begin
      totalProfit = 0;
      for bit in 1:numberOfBits
        if x.bits[bit]
          totalProfit += profits[i, bit]
        end
      end 
      return -totalProfit
    end
    addObjective(problem, f)
  end

  for i in 1:size(weights, 1)
    c = x -> begin
      totalWeight = 0;
      for bit in 1:numberOfBits
        if x.bits[bit]
          totalWeight += weights[i, bit]
        end
      end 
      constraintValue = capacities[i] - totalWeight
      return constraintValue < 0 ? constraintValue : 0 
    end
    addConstraint(problem, c)
  end

  return problem
end

