
function aSingleObjectiveKnapsackProblemIsCorrectlyCreated()
    profits = Matrix{Int}(undef, 1, 4)
    profits[1, :] = [10, 5, 15, 7]

    weights = Matrix{Int}(undef, 1, 4)
    profits[1, :] = [2, 3, 5, 7]

    capacities = [12]

    knapsack = multiObjectiveKnapsack(profits, weights, capacities)

    return numberOfObjectives(knapsack) == 1 && numberOfVariables(knapsack) == 4 && numberOfConstraints(knapsack) == 1
end

function aMultiObjectiveKnapsackProblemIsCorrectlyCreated()
    profits = [10 5 15 7 ; 2 6 3 4]
    weights = [2 3 5 7 ; 1 5 6 3 ; 3 1 2 4]
    capacities = [12, 9, 5]

    knapsack = multiObjectiveKnapsack(profits, weights, capacities)

    return numberOfObjectives(knapsack) == 2 && numberOfVariables(knapsack) == 4 && numberOfConstraints(knapsack) == 3
end



function whenEvaluatingAFeasibleSolutionThenTheObjectiveValueIsCorrect()
    profits = Matrix{Int}(undef, 1, 4)
    profits = [10 5 15 7 ; 2 6 3 4]
    weights = [2 3 5 7 ; 1 5 6 3 ; 3 1 2 4]
    capacities = [12, 9, 5]

    knapsack = multiObjectiveKnapsack(profits, weights, capacities)

    solution = createSolution(knapsack)
    solution.variables = initBitVector("1010")

    evaluate(solution, knapsack)

    return solution.objectives[1] == -25 && solution.objectives[2] == -5 && isFeasible(solution)
end

function whenEvaluatingAnUFeasibleSolutionForViolatingTwoConstraintsThenTheConstraintValueIsCorrect()
    profits = [10 5 15 7 ; 2 6 3 4]
    weights = [2 3 5 7 ; 1 5 6 3 ; 3 1 2 4]
    capacities = [12, 9, 5]

    knapsack = multiObjectiveKnapsack(profits, weights, capacities)

    solution = createSolution(knapsack)
    solution.variables = initBitVector("1110")

    evaluate(solution, knapsack)

    return solution.constraints[1] == 0 && solution.constraints[2] == -3 && solution.constraints[3] == -1 && !isFeasible(solution) && overallConstraintViolationDegree(solution) == -4 && numberOfViolatedConstraints(solution) == 2
end

function whenEvaluatingAnUFeasibleSolutionForViolatingAllTheConstraintsThenTheConstraintValueIsCorrect()
    profits = [10 5 15 7 ; 2 6 3 4]
    weights = [2 3 5 7 ; 1 5 6 3 ; 3 1 2 4]
    capacities = [12, 9, 5]

    knapsack = multiObjectiveKnapsack(profits, weights, capacities)

    solution = createSolution(knapsack)
    solution.variables = initBitVector("1111")

    evaluate(solution, knapsack)

    return solution.constraints[1] == -5 && solution.constraints[2] == -6 && solution.constraints[3] == -5 && !isFeasible(solution) && overallConstraintViolationDegree(solution) == -16 && numberOfViolatedConstraints(solution) == 3
end


@testset "MultiObjectiveKnapsack tests" begin    
    @test aSingleObjectiveKnapsackProblemIsCorrectlyCreated() == true
    @test aMultiObjectiveKnapsackProblemIsCorrectlyCreated() == true
    @test whenEvaluatingAFeasibleSolutionThenTheObjectiveValueIsCorrect() == true
    @test whenEvaluatingAnUFeasibleSolutionForViolatingTwoConstraintsThenTheConstraintValueIsCorrect() == true
    @test whenEvaluatingAnUFeasibleSolutionForViolatingAllTheConstraintsThenTheConstraintValueIsCorrect() == true

end

