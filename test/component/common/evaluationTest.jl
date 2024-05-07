#######################################################
# Evaluation unit tests
#######################################################

function sequentialEvaluationIsCorrectlyInitialized()
    problem = ContinuousProblem{Real}([],[],[],"")

    evaluation = SequentialEvaluation(problem)

    return problem == evaluation.problem
end


function sequentialEvaluationEvaluatesTheSolutions()
    problem = ContinuousProblem{Real}([],[],[],"")
    addObjective(problem, x -> 2)
    addVariable(problem, Bounds{Real}(1, 3))

    numberOfSolutions = 3
    solutions = [createSolution(problem)]
    push!(solutions, createSolution(problem))
    push!(solutions, createSolution(problem))

    evaluation = SequentialEvaluation(problem)
    evaluatedSolutions = evaluate(solutions, evaluation)

    return length(evaluatedSolutions) == numberOfSolutions && 
    evaluatedSolutions[1].objectives[1] == 2 && 
    evaluatedSolutions[2].objectives[1] == 2
end


function sequentialEvaluationWithArchiveIsCorrectlyInitialized()
    problem = ContinuousProblem{Real}([],[],[],"")
    externalArchive = CrowdingDistanceArchive(10, ContinuousSolution{Float64})

    evaluation = SequentialEvaluationWithArchive(problem, externalArchive)

    return problem == evaluation.problem && externalArchive == evaluation.archive 
end


function sequentialEvaluationWithArchiveEvaluatesTheSolutions()
    problem = ContinuousProblem{Float64}([],[],[],"")
    addObjective(problem, x -> 2)
    addVariable(problem, Bounds{Float64}(1, 3))

    numberOfSolutions = 3
    solutions = [createSolution(problem)]
    push!(solutions, createSolution(problem))
    push!(solutions, createSolution(problem))

    externalArchive = CrowdingDistanceArchive(10, ContinuousSolution{Float64})
    evaluation = SequentialEvaluationWithArchive(problem, externalArchive)
    evaluatedSolutions = evaluate(solutions, evaluation)

    return length(evaluatedSolutions) == numberOfSolutions && 
    evaluatedSolutions[1].objectives[1] == 2 && 
    evaluatedSolutions[2].objectives[1] == 2
end

function sequentialEvaluationWithArchiveAddsTheSolutionsToTheArchiveEvaluatesTheSolutions()
    problem = ContinuousProblem{Float64}([],[],[],"")
    addObjective(problem, x -> x[1] * 0.5)
    addVariable(problem, Bounds{Float64}(1, 3))

    solutions = [createSolution(problem)]
    push!(solutions, createSolution(problem))
    push!(solutions, createSolution(problem))

    externalArchive = CrowdingDistanceArchive(10, ContinuousSolution{Float64})
    evaluation = SequentialEvaluationWithArchive(problem, externalArchive)
    evaluate(solutions, evaluation)

    return length(externalArchive) >= 1
end

@testset "Sequential evaluation tests" begin    
    @test sequentialEvaluationIsCorrectlyInitialized()
    @test sequentialEvaluationEvaluatesTheSolutions()

    @test sequentialEvaluationWithArchiveIsCorrectlyInitialized() 
    @test sequentialEvaluationWithArchiveEvaluatesTheSolutions() 
    @test sequentialEvaluationWithArchiveAddsTheSolutionsToTheArchiveEvaluatesTheSolutions() 
end
