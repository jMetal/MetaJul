include("../src/solution.jl")

using Test

continuousSolution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [0.1], Dict("ranking" => 5.0, "name" => "bestSolution"), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

copiedSolution = copySolution(continuousSolution)
copiedSolution.variables =  [2.5, 5.6, 1.5]

@testset "ContinuousSolution tests" begin
    @test continuousSolution.variables == [1.0, 2.0, 3.0]
    @test continuousSolution.objectives == [1.5, 2.5]
    @test continuousSolution.constraints == [0.1]
    @test continuousSolution.attributes == Dict("ranking" => 5.0, "name" => "bestSolution")

    @test copiedSolution.variables == [2.5, 5.6, 1.5]
    @test copiedSolution.objectives == [1.5, 2.5]
    @test copiedSolution.constraints == [0.1]
    @test copiedSolution.attributes == Dict()

    @test isequal(continuousSolution, copiedSolution) == false
    @test isequal(continuousSolution, continuousSolution) == true
end

binarySolution = BinarySolution(initBitVector("1010"), [1.0, 2.0, 3.0], [-1], Dict("fitness" => 1.24))

copiedBinarySolution = copySolution(binarySolution)
copiedBinarySolution.variables = bitFlip(copiedBinarySolution.variables, 1)
duplicatedSolution = BinarySolution(initBitVector("1010"), [1.0, 2.0, 3.0], [-1], Dict("fitness" => 1.24))

@testset "BitVector tests" begin
    @test binarySolution.variables.bits == initBitVector("1010").bits
    @test binarySolution.objectives == [1.0, 2.0, 3.0]
    @test binarySolution.constraints == [-1]
    @test binarySolution.attributes == Dict("fitness" => 1.24)

    @test copiedBinarySolution.variables.bits == initBitVector("0010").bits
    @test copiedBinarySolution.objectives == [1.0, 2.0, 3.0]
    @test copiedBinarySolution.constraints == [-1]
    @test copiedBinarySolution.attributes == Dict()

    @test isequal(binarySolution, copiedBinarySolution) == false
    @test isequal(binarySolution, binarySolution) == true

    @test isequal(binarySolution, duplicatedSolution)
end

#################################################
# Constraing handling functions tests
#################################################

function numberOfViolatedConstraintsReturnsZeroIfTheSolutionHasNoConstraints()
    solution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    return numberOfViolatedConstraints(solution) == 0
end

function numberOfViolatedConstraintsReturnsZeroIfTheSolutionHasANonViolatedConstraint()
    solution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [1], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    return numberOfViolatedConstraints(solution) == 0
end

function numberOfViolatedConstraintsReturnsTheRightNumberOfViolatedContraints()
    solution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [-1.0, 2.1, 0.0, -2.1, 3.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    return numberOfViolatedConstraints(solution) == 2
end

function overallConstraintViolationDegreeReturnsZeroIfTheProblemHasNoConstraints() 
    solution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    return overallConstraintViolationDegree(solution) == 0
end

function overallConstraintViolationDegreeReturnsTheRightViolationDegree() 
    solution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [-1.0, -2.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    return overallConstraintViolationDegree(solution) == -3.0
end

function overallConstraintViolationDegreeReturnsZeroIfTheProblemHasNoViolatedConstraints() 
    solution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [0.0, 2.0, 3.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    return overallConstraintViolationDegree(solution) == 0
end

function isFeasibleReturnTrueIfAHasConstraintsButNoneOfThemAreViolated()
    solution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [2.0, 0.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    return isFeasible(solution)
end

function isFeasibleReturnTrueIfAContinuousSolutionHasNoConstraints()
    solution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    return isFeasible(solution)
end

function isFeasibleReturnTrueIfABinarySolutionHasNoConstraints()
    solution = BinarySolution(initBitVector("1010"), [1.0, 2.0, 3.0], [], Dict())

    return isFeasible(solution)
end

function isFeasibleReturnTrueIfAHasConstraintsButNoneOfThemAreViolated()
    solution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [2.0, 1.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    return isFeasible(solution)
end

function isFeasibleReturnFalseIfAHasViolatedConstraint()
    solution = ContinuousSolution{Float64}([1.0, 2.0, 3.0], [1.5, 2.5], [-2.0, 1.0], Dict(), [Bounds{Float64}(1.0, 2.0), Bounds{Float64}(2, 3)])

    return !isFeasible(solution)
end


@testset "Constraint handling functions tests" begin
    @test numberOfViolatedConstraintsReturnsZeroIfTheSolutionHasNoConstraints()
    @test numberOfViolatedConstraintsReturnsZeroIfTheSolutionHasANonViolatedConstraint()
    @test numberOfViolatedConstraintsReturnsTheRightNumberOfViolatedContraints()

    @test overallConstraintViolationDegreeReturnsZeroIfTheProblemHasNoConstraints()
    @test overallConstraintViolationDegreeReturnsZeroIfTheProblemHasNoViolatedConstraints()
    @test overallConstraintViolationDegreeReturnsTheRightViolationDegree()
    
    @test isFeasibleReturnTrueIfAContinuousSolutionHasNoConstraints()
    @test isFeasibleReturnTrueIfABinarySolutionHasNoConstraints()
    @test isFeasibleReturnTrueIfAHasConstraintsButNoneOfThemAreViolated()
    @test isFeasibleReturnFalseIfAHasViolatedConstraint()
end



