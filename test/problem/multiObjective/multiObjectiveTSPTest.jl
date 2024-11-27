
println(joinpath(tsp_data_dir, "kroA100.tsp"))

problem100Cities = multiObjectiveTSP("kroAB100", [joinpath(tsp_data_dir, "kroA100.tsp"), joinpath(tsp_data_dir, "kroB100.tsp")])

function createSolutionReturnsAValidSolutionForKroAB100Problem() 
    solution = createSolution(problem100Cities)

    return 100 == length(solution.variables) && 2 == length(solution.objectives)
end

@testset "MultiObjectiveTSP for problem kroAB100 tests" begin    
    @test numberOfVariables(problem100Cities) == 100
    @test numberOfObjectives(problem100Cities) == 2
    @test numberOfConstraints(problem100Cities) == 0
    @test name(problem100Cities) == "kroAB100"

    @test createSolutionReturnsAValidSolutionForKroAB100Problem()
end

problem4Cities = multiObjectiveTSP("simpleProblem", [joinpath(tsp_data_dir, "fourCitiesTSP.tsp")])

function evaluatingASolutionReturnsTheRightDistance()
    solution = createSolution(problem4Cities)
    solution.variables = [1,2,3,4]

    evaluate(solution, problem4Cities)

    return 4 == solution.objectives[1]
end

@testset "MultiObjectiveTSP for problem with four cities tests" begin    
    @test numberOfVariables(problem4Cities) == 4
    @test numberOfObjectives(problem4Cities) == 1
    @test numberOfConstraints(problem4Cities) == 0
    @test name(problem4Cities) == "simpleProblem"

    @test evaluatingASolutionReturnsTheRightDistance()
end

