using Random

## Evaluation components

struct SequentialEvaluation <: Evaluation
    problem::Problem
end

function evaluate(solutions::Vector{S}, evaluation::SequentialEvaluation) where {S<:Solution}
    return [evaluate(solution, evaluation.problem) for solution in solutions]
end

struct SequentialEvaluationWithArchive <: Evaluation
    problem::Problem
    archive::Archive
end

function evaluate(solutions::Vector{S}, evaluation::SequentialEvaluationWithArchive) where {S<:Solution}
    archive = evaluation.archive
    problem::Problem = evaluation.problem
    for solution in solutions
        evaluate(solution, problem)
        add!(archive, solution)
    end
    return solutions
end
