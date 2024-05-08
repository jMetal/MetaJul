# Test cases for binary problem
testProblem = BinaryProblem(15,[],[],"TestProblem")
addObjective(testProblem, x -> length([i for i in x.bits if i]))
addObjective(testProblem, y -> length([j for j in y.bits if !j]))

@testset "BinaryProblem tests" begin    
    @test numberOfObjectives(testProblem) == 2
    @test numberOfConstraints(testProblem) == 0
    @test name(testProblem) == "TestProblem"
    @test 15 == testProblem.numberOfBits
end
