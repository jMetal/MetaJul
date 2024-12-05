#using MetaJul: values

function constructorInitializesTheStructCorrectlyWithDefaultValues()
    aggFunction = WeightedSum()

    return aggFunction.epsilon == 0.0 && !aggFunction.normalizeObjectives 
end

function constructorInitializesTheStructCorrectlyWithSpecificValues()
    epsilon = 0.000000001 
    normalize = false 
    aggFunction = WeightedSum(normalize, epsilon)

    return aggFunction.epsilon == epsilon && !aggFunction.normalizeObjectives
end

function givenAnAggFunctionWhenNormalizeThenTheResultIsCorrect()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.5, 0.5]
    weightVector = [1.0, 1.0]

    aggFunction = WeightedSum()
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)
    return isapprox(1.0, result) 
end

function givenAnAggFunctionWhenNotNormalizeThenTheResultIsCorrect()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.5, 0.5]
    weightVector = [1.0, 1.0]

    aggFunction = WeightedSum(false, 0.0000000000001)
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)
    return isapprox(1.0, result) 
end


function givenAnAggFunctionWhenTheWeightsAreDifferentThenTheResultIsCorrect()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.5, 0.5]
    weightVector = [0.2, 0.8]

    aggFunction = WeightedSum()
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)
    return isapprox(0.5, result)     
end

function givenAnAggFunctionWhenTheVectorsAreDifferentThenTheResultIsCorrect()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.2, 0.8]
    weightVector = [1.0, 1.0]

    aggFunction = WeightedSum()
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)
    return isapprox(1.0, result)     
end


@testset "WeightedSum tests" begin
    @test constructorInitializesTheStructCorrectlyWithDefaultValues()
    @test constructorInitializesTheStructCorrectlyWithSpecificValues()
    @test givenAnAggFunctionWhenNormalizeThenTheResultIsCorrect()
    @test givenAnAggFunctionWhenNotNormalizeThenTheResultIsCorrect()
    @test givenAnAggFunctionWhenTheWeightsAreDifferentThenTheResultIsCorrect()
    @test givenAnAggFunctionWhenTheVectorsAreDifferentThenTheResultIsCorrect()
end


# Unit test functions for PenaltyBoundaryIntersection

function constructorInitializesTheStructCorrectlyWithDefaultValues_PBI()
    aggFunction = PenaltyBoundaryIntersection()

    return aggFunction.epsilon == 1e-6 && aggFunction.normalizeObjectives == false && aggFunction.theta == 5.0
end

function constructorInitializesTheStructCorrectlyWithSpecificValues_PBI()
    epsilon = 0.000001
    theta = 2.0
    normalize = true
    aggFunction = PenaltyBoundaryIntersection(theta, normalize)

    return aggFunction.epsilon == epsilon && aggFunction.normalizeObjectives && aggFunction.theta == theta
end

function givenAnAggFunctionWhenNormalizeThenTheResultIsCorrect_PBI()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.5, 0.5]
    weightVector = [1.0, 1.0]

    aggFunction = PenaltyBoundaryIntersection(5.0, true)
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)
    
    return isapprox(result, 0.707109609610844)  # Expected value based on normalization and theta
end

function givenAnAggFunctionWhenNotNormalizeThenTheResultIsCorrect_PBI()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.5, 0.5]
    weightVector = [1.0, 1.0]

    aggFunction = PenaltyBoundaryIntersection(5.0, false)
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)

    return isapprox(result, 0.7071067811865482)  # Expected value without normalization
end

function givenAnAggFunctionWhenTheWeightsAreDifferentThenTheResultIsCorrect_PBI()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.5, 0.5]
    weightVector = [0.2, 0.8]

    aggFunction = PenaltyBoundaryIntersection(5.0, true)
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)

    return isapprox(result, 2.4253556440274)  # Expected result with different weights
end

function givenAnAggFunctionWhenTheVectorsAreDifferentThenTheResultIsCorrect_PBI()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.2, 0.8]
    weightVector = [1.0, 1.0]

    aggFunction = PenaltyBoundaryIntersection(5.0, true)
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)

    return isapprox(result, 2.8284264176430627)  # Expected result based on vector variation
end

# Define the test set for PenaltyBoundaryIntersection
@testset "PenaltyBoundaryIntersection tests" begin
    @test constructorInitializesTheStructCorrectlyWithDefaultValues_PBI()
    @test constructorInitializesTheStructCorrectlyWithSpecificValues_PBI()
    @test givenAnAggFunctionWhenNormalizeThenTheResultIsCorrect_PBI()
    @test givenAnAggFunctionWhenNotNormalizeThenTheResultIsCorrect_PBI()
    @test givenAnAggFunctionWhenTheWeightsAreDifferentThenTheResultIsCorrect_PBI()
    @test givenAnAggFunctionWhenTheVectorsAreDifferentThenTheResultIsCorrect_PBI()
end

using Test

# Unit tests for Tschebyscheff

function constructorInitializesTheStructCorrectlyWithDefaultValues_Tschebyscheff()
    aggFunction = Tschebyscheff()

    return aggFunction.epsilon == 0.0 && !aggFunction.normalizeObjectives
end

function constructorInitializesTheStructCorrectlyWithSpecificValues_Tschebyscheff()
    epsilon = 1e-8
    normalize = true
    aggFunction = Tschebyscheff(normalize, epsilon)

    return aggFunction.epsilon == epsilon && aggFunction.normalizeObjectives
end

"""
function givenAnAggFunctionWhenNormalizeThenTheResultIsCorrect_Tschebyscheff()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.5, 0.5]
    weightVector = [1.0, 1.0]

    aggFunction = Tschebyscheff(true, 0.1e-6)
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)
    return isapprox(0.5, result)
end
"""

function givenAnAggFunctionWhenNotNormalizeThenTheResultIsCorrect_Tschebyscheff()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.5, 0.5]
    weightVector = [1.0, 1.0]

    aggFunction = Tschebyscheff()
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)
    return isapprox(0.5, result)
end

function givenAnAggFunctionWhenTheWeightsAreDifferentThenTheResultIsCorrect_Tschebyscheff()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.5, 0.5]
    weightVector = [0.2, 0.8]

    aggFunction = Tschebyscheff()
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)
    return isapprox(0.4, result)
end

function givenAnAggFunctionWhenTheVectorsAreDifferentThenTheResultIsCorrect_Tschebyscheff()
    idealPoint = IdealPoint([0.0, 0.0])
    nadirPoint = NadirPoint([1.0, 1.0])

    vector = [0.2, 0.8]
    weightVector = [1.0, 1.0]

    aggFunction = Tschebyscheff()
    result = compute(aggFunction, vector, weightVector, idealPoint, nadirPoint)
    return isapprox(0.8, result)
end

@testset "Tschebyscheff tests" begin
    @test constructorInitializesTheStructCorrectlyWithDefaultValues_Tschebyscheff()
    @test constructorInitializesTheStructCorrectlyWithSpecificValues_Tschebyscheff()
    #@test givenAnAggFunctionWhenNormalizeThenTheResultIsCorrect_Tschebyscheff()
    @test givenAnAggFunctionWhenNotNormalizeThenTheResultIsCorrect_Tschebyscheff()
    @test givenAnAggFunctionWhenTheWeightsAreDifferentThenTheResultIsCorrect_Tschebyscheff()
    @test givenAnAggFunctionWhenTheVectorsAreDifferentThenTheResultIsCorrect_Tschebyscheff()
end