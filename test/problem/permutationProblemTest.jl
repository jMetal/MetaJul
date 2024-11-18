# Test cases for permutation problem
permutationLength = 10 
permutationTestProblem = PermutationProblem(permutationLength,[],[],"")
addObjective(permutationTestProblem, x -> x[1] + x[2])
addObjective(permutationTestProblem, x -> x[2] * x[2])
addConstraint(permutationTestProblem, x -> x[1] < 2)
setName(permutationTestProblem, "TestProblem")

@testset "PermutationProblem tests" begin    
    @test numberOfVariables(permutationTestProblem) == permutationLength
    @test numberOfObjectives(permutationTestProblem) == 2
    @test numberOfConstraints(permutationTestProblem) == 1
    @test name(permutationTestProblem) == "TestProblem"
end
