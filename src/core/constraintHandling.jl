###########################################################
# Constraint handling functions
###########################################################

function overallConstraintViolationDegree(solution::S) where {S<:Solution}
    return sum(filter(x -> x < 0.0, solution.constraints))
end

function numberOfViolatedConstraints(solution::S) where {S<:Solution}
    return length(filter(x -> x < 0.0, solution.constraints))
end

function isFeasible(solution::S) where {S<:Solution}
    return numberOfViolatedConstraints(solution) == 0
end

function feasibilityRatio(solutions::Vector{S})::Real where {S <: Solution}
    @assert length(solutions) > 0 "The solution list is empty"

    result = sum(filter(solution -> isFeasible(solution), solutions))
    return result / length(solutions)
end