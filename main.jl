
include("src/solution.jl")
include("src/bounds.jl")

function main()
    bounds1 = Bounds{Float64}(1.0, 2.0)
    bounds2 = Bounds{Int}(2, 3)
    println(bounds1)
    println(bounds2)


    #solution1 = Solution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], Dict("s" => 5.0, "b" => "hola"))
    solution1 = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], Dict("s" => 5.0, "b" => "hola"), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])
    println("Solution1: ", solution1)

    solution2 = deepcopy(solution1)
    solution2.variables = [2.5, 5.6, 1.5]
    println("Solution2: ", solution2)
    println("Solution1: ", solution1)

    println("Solution1.variables.length: ", length(solution1.variables))

    println(restrict(4, Bounds{Int}(2, 7)))
    println(restrict(4, Bounds{Int}(7, 9)))
    println(restrict(4, Bounds{Int}(1, 3)))
    
end

main()
