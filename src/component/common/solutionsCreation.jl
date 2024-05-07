using Random

## Solution creation components
struct DefaultSolutionsCreation <: SolutionsCreation
    problem::Problem
    numberOfSolutionsToCreate::Int16
end

function create(solutionsCreation::DefaultSolutionsCreation)
    problem = solutionsCreation.problem
    numberOfSolutionsToCreate = solutionsCreation.numberOfSolutionsToCreate
    [createSolution(problem) for _ in range(1, numberOfSolutionsToCreate)]
end

