#using MetaJul: values

function constructorInitializesTheStructCorrectlyWithDefaultValues()
    aggFunction = WeightedSum()

    return aggFunction.epsilon == 1e-15 && aggFunction.normalizeObjectives 
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


@testset "ArrayPoint tests" begin
    @test constructorInitializesTheStructCorrectlyWithDefaultValues()
    @test constructorInitializesTheStructCorrectlyWithSpecificValues()
    @test givenAnAggFunctionWhenNormalizeThenTheResultIsCorrect()
    @test givenAnAggFunctionWhenNotNormalizeThenTheResultIsCorrect()
    @test givenAnAggFunctionWhenTheWeightsAreDifferentThenTheResultIsCorrect()
    @test givenAnAggFunctionWhenTheVectorsAreDifferentThenTheResultIsCorrect()
end