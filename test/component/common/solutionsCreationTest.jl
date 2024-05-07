#######################################################
# Solutions creation unit tests
#######################################################

function defaultSolutionsCreationIsCorrectlyInitialized()
    problem = ContinuousProblem{Real}([],[],[],"")

    numberOfSolutionsToCreate = 25
    solutionsCreation = DefaultSolutionsCreation(problem, numberOfSolutionsToCreate)

    return solutionsCreation.problem == problem && solutionsCreation.numberOfSolutionsToCreate == 25 
end

function defaultSolutionsCreationCreatesTheNumberOfIndicatedSolutions()
    problem::ContinuousProblem = ContinuousProblem{Real}([],[],[],"")

    numberOfSolutionsToCreate = 25
    solutionsCreation = DefaultSolutionsCreation(problem, numberOfSolutionsToCreate)
    solutions = create(solutionsCreation)

    return length(solutions) == 25
end


@testset "Solutions creation tests" begin    
    @test defaultSolutionsCreationIsCorrectlyInitialized()
    @test defaultSolutionsCreationCreatesTheNumberOfIndicatedSolutions()
end
