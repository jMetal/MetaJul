function terminationByEvaluationsIsMet()
    evaluationsLimit = 100 

    termination = TerminationByEvaluations(evaluationsLimit)
    algorithmStatus = Dict("EVALUATIONS" => 100)
    
    return isMet(termination, algorithmStatus)
end

function terminationByEvaluationsIsNotMet()
    evaluationsLimit = 100 

    termination = TerminationByEvaluations(evaluationsLimit)
    algorithmStatus = Dict("EVALUATIONS" => 99)
    
    return !isMet(termination, algorithmStatus)
end

@testset "Termination by evaluations tests" begin    
    @test terminationByEvaluationsIsMet()
    @test terminationByEvaluationsIsNotMet()
end


function terminationByComputingTimeIsMet()
    computingTimeLimit = 100 

    termination = TerminationByComputingTime(computingTimeLimit)
    algorithmStatus = Dict("COMPUTING_TIME" => 100)
    
    return isMet(termination, algorithmStatus)
end

function terminationByComputingTimeIsNotMet()
    computingTimeLimit = 100 

    termination = TerminationByComputingTime(computingTimeLimit)
    algorithmStatus = Dict("COMPUTING_TIME" => 99)
    
    return !isMet(termination, algorithmStatus)
end

@testset "Termination by computing time tests" begin    
    @test terminationByComputingTimeIsMet()
    @test terminationByComputingTimeIsNotMet()
end
