
include("src/solution.jl")
include("src/bounds.jl")

function main()
    floatSolution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], Dict("ranking" => 5.0, "name" => "bestSolution"), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
    println("floatSolution: ", floatSolution)

    floatSolution2 = deepcopy(floatSolution)
    floatSolution2.variables = [2.5, 5.6, 1.5]
    println("Solution2: ", floatSolution2)
    println("floatSolution: ", floatSolution)

    println("floatSolution.variables.length: ", length(floatSolution.variables))

    intSolution = ContinuousSolution{Int32}([1, 2, 3], [1.5, 2.5], Dict("densityEstimator" => 4.25), [Bounds{Int32}(1, 2), Bounds{Int32}(2, 3)])
    println("intSolution: ", intSolution)
    
end

main()
