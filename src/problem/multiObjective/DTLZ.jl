
# Function to define the DTLZ1 problem
function DTLZ1(;numberOfVariables::Int=7, numberOfObjectives::Int=3)
  problem = ContinuousProblem{Float64}("DTLZ1")

  # Define the variable bounds
  for _ in 1:numberOfVariables
      addVariable(problem, Bounds{Float64}(0.0, 1.0))
  end

  k = numberOfVariables - numberOfObjectives + 1

  # Define the first objective function
  f1 = x -> begin
      g = 0.0
      for i in numberOfVariables - k + 1:numberOfVariables
          g += (x[i] - 0.5)^2 - cos(20.0 * π * (x[i] - 0.5))
      end
      g = 100 * (k + g)
      
      result = (1.0 + g) * 0.5
      for j in 1:numberOfObjectives-1
          result *= x[j]
      end
      result
  end

  # Define the remaining objective functions
  objectives::Vector{Function} = [f1]
  for i in 2:numberOfObjectives
      f = x -> begin
          g = 0.0
          for j in numberOfVariables - k + 1:numberOfVariables
              g += (x[j] - 0.5)^2 - cos(20.0 * π * (x[j] - 0.5))
          end
          g = 100 * (k + g)

          result = (1.0 + g) * 0.5
          for j in 1:numberOfObjectives-i
              result *= x[j]
          end
          result *= 1 - x[numberOfObjectives-i+1]
          result
      end
      push!(objectives, f)
  end

  # Add all objective functions to the problem
  for objective in objectives
      addObjective(problem, objective)
  end

  return problem
end
 