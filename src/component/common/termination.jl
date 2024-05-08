struct TerminationByEvaluations <: Termination
    numberOfEvaluationsToStop::Int
end


function isMet(algorithmAttributes::Dict, termination::TerminationByEvaluations)::Bool
    return get(algorithmAttributes, "EVALUATIONS", 0) >= termination.numberOfEvaluationsToStop
end

struct TerminationByComputingTime <: Termination
    computingTimeLimit::Int
end


function isMet(algorithmAttributes::Dict, termination::TerminationByComputingTime)::Bool
    return get(algorithmAttributes, "COMPUTING_TIME", 0) >= termination.computingTimeLimit
end

