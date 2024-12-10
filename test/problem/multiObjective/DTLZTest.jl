dtlz1Default = DTLZ1()
solutionDTLZ1 = createSolution(dtlz1Default)

solutionDTLZ1.variables = [1.0 for _ in 1:7]
evaluate(solutionDTLZ1, dtlz1Default)

print(solutionDTLZ1)

const DTLZ1DefaultNumberOfVariables::Int = 7 
const DTLZ1DefaultObjectives::Int = 3

dtlz12D10Vars = DTLZ1(numberOfVariables = 12, numberOfObjectives = 2)
@testset "ZDT1 problem tests" begin    
    @test numberOfVariables(dtlz1Default) == DTLZ1DefaultNumberOfVariables
    @test numberOfObjectives(dtlz1Default) == DTLZ1DefaultObjectives
    @test numberOfConstraints(dtlz1Default) == 0
    @test bounds(dtlz1Default)[1].lowerBound == 0.0
    @test bounds(dtlz1Default)[1].upperBound == 1.0
    @test name(dtlz1Default) == "DTLZ1"

    @test length(solutionDTLZ1.variables) == numberOfVariables(dtlz1Default)
    @test length(solutionDTLZ1.objectives) == numberOfObjectives(dtlz1Default)
    @test length(solutionDTLZ1.constraints) == numberOfConstraints(dtlz1Default)

    @test solutionDTLZ1.bounds == dtlz1Default.bounds
    @test solutionDTLZ1.variables[1] <= dtlz1Default.bounds[1].upperBound
    @test solutionDTLZ1.variables[1] >= dtlz1Default.bounds[1].lowerBound

    @test numberOfVariables(dtlz12D10Vars) == 12
    @test numberOfObjectives(dtlz12D10Vars) == 2
end
