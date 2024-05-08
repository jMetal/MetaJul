struct DTLZ1 <: AbstractContinuousProblem{Float64}
  bounds::Vector{Bounds{Float64}}
  numberOfObjectives::Int
  name::String
end

function dtlz1Problem(numberOfVariables::Int=7, numberOfObjectives::Int=3)
  bounds = [Bounds{Float64}(0.0, 1.0) for _ in range(1, numberOfVariables)]

  return DTLZ1(bounds,numberOfObjectives,"DTLZ1")
end

function numberOfVariables(problem::DTLZ1)
  return length(problem.bounds)
end

function numberOfObjectives(problem::DTLZ1)
  return problem.numberOfObjectives
end

function numberOfConstraints(problem::DTLZ1)
  return 0
end

function evaluate(solution::ContinuousSolution{Float64}, problem::DTLZ1)::ContinuousSolution{Float64}
  x = solution.variables
  @assert length(x) == numberOfVariables(problem) "The number of variables of the solution to be evaluated is not correct"

  k = numberOfVariables(problem) - numberOfObjectives(problem) + 1
  #println("x: " , solution.variables)

  g = 0.0
  for i in (numberOfVariables(problem) - k + 1):numberOfVariables(problem)
      g += (x[i] - 0.5) * (x[i] - 0.5) - cos(20.0 * π * (x[i] - 0.5))
  end
  
  #println("G: ",g)
  g = 100 * (k + g)
  #println("G: ",g)

  f = [(1.0 + g) * 0.5 for _ in 1:numberOfObjectives(problem)]
 
  #f = [0.5*x[1]*x[2]*(1 + g), 0.5*(1 -x[1])*(1 + g)]

  #println("G: ", g)
  #println("F: ", f)



  for i in 1:numberOfObjectives(problem)
    #println("i: ",i)
    for j in 1:(numberOfObjectives(problem) - i)
      #println("  j: ",j)
      f[i] *= x[j]
      #println("F[",i,"] = ", f[i])
    end
    if i != 1
      #println("I: ", i)
      #println("Objs: ", numberOfObjectives(problem))
      aux = numberOfObjectives(problem) + 1 - i
      """
      2 : 2
      3 : 1
      """
      #println("AUX: ", aux)
      f[i] *= 1 - x[aux]
      #println("F[",i,"] = ", f[i])
    end
  end
  
  solution.objectives = f

  return solution
end

"""
function dtlz1Problem(numberOfVariables::Int=7, numberOfObjectives::Int=3)
  dtlz1 = ContinuousProblem{Float64}("DTLZ1")

  # Add variables
  for _ in 1:numberOfVariables
      addVariable(dtlz1, Bounds{Float64}(0.0, 1.0))
  end

  # Function to evaluate g
  function evalG(x::Vector{Float64})
      return 100 * (length(x) - numberOfObjectives + 1 + sum((xi - 0.5)^2 - cos(20 * π * (xi - 0.5)) for xi in x[numberOfObjectives:end]))
  end

  # Objective functions
  for m in 1:numberOfObjectives
      addObjective(dtlz1, x -> begin
          g = evalG(x)
          f = 0.5 * (1 + g)
          for i in 1:(numberOfObjectives - m)
              f *= x[i]
          end
          if m > 1
              f *= (1 - x[numberOfObjectives - m])
          end
          return f
      end)
  end

  return dtlz1
end
"""
