using Random
using Base.Threads

struct SequentialEvaluation <: Evaluation
    problem::Problem
end

function evaluate(evaluation::SequentialEvaluation, solutions::Vector{S}) where {S<:Solution}
    return [evaluate(solution, evaluation.problem) for solution in solutions]
end

struct SequentialEvaluationWithArchive <: Evaluation
    problem::Problem
    archive::Archive
end

function evaluate(evaluation::SequentialEvaluationWithArchive, solutions::Vector{S}) where {S<:Solution}
    archive = evaluation.archive
    problem::Problem = evaluation.problem
    for solution in solutions
        evaluate(solution, problem)
        add!(archive, solution)
    end
    return solutions
end

struct MultithreadedEvaluation <: Evaluation
    problem::Problem
end

function evaluate(evaluation::MultithreadedEvaluation, solutions::Vector{S}) where {S<:Solution}
    
    @threads for solution in solutions
        evaluate(solution, evaluation.problem)
    end

    return solutions
end
