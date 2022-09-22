
include("bounds.jl")
include("solution.jl")

abstract type Problem{T} end

struct ContinuousProblem{T <: Number} <: Problem{T}
    bounds::Array{Bounds{T}}
    numberOfObjectives::Int
    numberOfConstraints::Int
    evaluation::Function
end

function numberOfVariables(problem:: ContinuousProblem) :: Int
  return length(problem.bounds)
end

function createSolution(problem::ContinuousProblem)
  x = [problem.bounds[i].lowerBound + rand()*(problem.bounds[i].upperBound-problem.bounds[i].lowerBound) for i in 1:length(problem.bounds)]

  return ContinuousSolution{Float64}(x, zeros(problem.numberOfObjectives), zeros(problem.numberOfConstraints), Dict(), problem.bounds)
end


function evaluate(solution::S, problem::Problem) where {S <: Solution}
  solution.variables = problem.evaluation(solution.variables)
  return solution
end
  

function evaluate(solution::S, evaluateFunction::Function) where {S <: Solution}
  solution.variables = evaluateFunction(solution.variables)
  return solution
end
  

######## Sphere
function sphere(x::Array{Float64}) :: Array{Float64} 
  f = sum([v * v for v in x])

  return [f]
end


function createSphereProblem(numberOfVariablesForSphere::Int)
  return ContinuousProblem{Float64}(createBounds([-5.12 for i in 1:numberOfVariablesForSphere],[5.12 for i in 1:numberOfVariablesForSphere]), 1, 0, sphere)
end

sphereProblem = createSphereProblem(10)

sphereSolution = createSolution(sphereProblem)
println("SPHERE: ", evaluate(sphereSolution, sphereProblem))
#sphereSolution.variables = sphere(sphereSolution.variables)


########
function schaffer(x::Array{Float64}) :: Array{Float64} 
  f0 = x[1] * x[1];
  f1 = (x[1] - 2.0) * (x[1] - 2.0);

  return [f0, f1]
end

function createSchafferProblem()
  return ContinuousProblem{Float64}(createBounds([-10000.0],[10000.0]), 1, 0, schaffer)
end

schafferProblem = createSchafferProblem()

schafferSolution = createSolution(schafferProblem)
#schafferSolution.variables = schaffer(schafferSolution.variables)

println("SCHAFFER: ", evaluate(schafferSolution, schafferProblem))

########
