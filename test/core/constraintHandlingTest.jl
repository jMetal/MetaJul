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



