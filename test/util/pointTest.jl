# Unit tests for Point

using MetaJul: values

function constructorCreatesAnArrayPointFillOfZeroes()
    dimension = 4
    point = ArrayPoint(dimension)

    return values(point) == zeros(dimension)
end

function constructorCreatesAnArrayPointWithAGivenDimension()
    dimension = 4
    point = ArrayPoint(dimension)

    return dimension == length(values(point))
end

function constructorCreatesAnArrayPointFromAnotherPoint()
    point = ArrayPoint([1.0, -2.0, 45.4])
    newPoint = ArrayPoint(point)

    return values(point) == values(newPoint)
end


function constructorCreatesAnArrayPointFromAVector()
    vector = [2.0, -21, 26.0, 4e12]
    point = ArrayPoint(vector)

    return values(point) == vector
end

function dimensionOfAnArrayPointReturnsTheCorrectValue()
    vector = [2.0, -21, 26.0, 4e12]
    point = ArrayPoint(vector)

    return length(vector) == dimension(point)
end

function equalsReturnsTrueIfTwoArrayPointsHaveTheSameValues()
    point1 = ArrayPoint([1.0, -2.0, 45.4])
    point2 = ArrayPoint([1.0, -2.0, 45.4])

    return values(point1) == values(point2)
end

function equalsReturnsTrueIfTwoArrayPointsAreTheSame()
    point1 = ArrayPoint([1.0, -2.0, 45.4])
    point2 = point1

    return point1 == point2
end

function setAssignsTheRightValuesToAnArrayPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = ArrayPoint(originalValues)

    newValues = [-2.6, 6.2, 14.23]
    set!(point, newValues)

    return newValues == values(point)
end

function updateAssignsTheRightValuesToAnArrayPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = ArrayPoint(originalValues)

    newValues = [-2.6, 6.2, 14.23]
    update!(point, newValues)

    return newValues == values(point)
end

function valueReturnsTheValueInTheIndicatedPositionInAnArrayPoint()
    values = [2.0, 4.1, -1.5]
    point = ArrayPoint(values)

    return values[1] == value(point, 1) && values[2] == value(point, 2) && values[3] == value(point,3)
end

function valueUpdatesTheValueInTheIndicatedPositionInAnArrayPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = ArrayPoint(originalValues)

    value!(point, 2, -25.5)

    return [2.0, -25.5, -1.5] == values(point)
end

@testset "ArrayPoint tests" begin
    @test constructorCreatesAnArrayPointFillOfZeroes()
    @test constructorCreatesAnArrayPointWithAGivenDimension()
    @test constructorCreatesAnArrayPointFromAnotherPoint()
    @test constructorCreatesAnArrayPointFromAVector()
    @test dimensionOfAnArrayPointReturnsTheCorrectValue()
    @test equalsReturnsTrueIfTwoArrayPointsHaveTheSameValues()
    @test equalsReturnsTrueIfTwoArrayPointsAreTheSame()
    @test setAssignsTheRightValuesToAnArrayPoint()
    @test updateAssignsTheRightValuesToAnArrayPoint()
    @test valueReturnsTheValueInTheIndicatedPositionInAnArrayPoint()
    @test valueUpdatesTheValueInTheIndicatedPositionInAnArrayPoint()
end


function constructorCreatesAnIdealPointWithAGivenDimension()
    dimension = 4
    point = IdealPoint(dimension)

    return dimension == length(values(point))
end


function constructorCreatesAnIdealPointFillOfIntValues()
    dimension = 4
    point = IdealPoint(dimension)

    return [Inf, Inf, Inf, Inf] == (values(point))
end

function constructorCreatesAnIdealPointFromAnotherPoint()
    point = IdealPoint([1.0, -2.0, 45.4])
    newPoint = IdealPoint(point)

    return values(point) == values(newPoint)
end

function constructorCreatesAnIdealPointFromAVector()
    vector = [2.0, -21, 26.0, 4e12]
    point = IdealPoint(vector)

    return values(point) == vector
end

function dimensionOfAnIdealPointReturnsTheCorrectValue()
    vector = [2.0, -21, 26.0, 4e12]
    point = IdealPoint(vector)

    return length(vector) == dimension(point)
end

function equalsReturnsTrueIfTwoIdealPointsHaveTheSameValues()
    point1 = IdealPoint([1.0, -2.0, 45.4])
    point2 = IdealPoint([1.0, -2.0, 45.4])

    return values(point1) == values(point2)
end

function equalsReturnsTrueIfTwoIdealPointsAreTheSame()
    point1 = IdealPoint([1.0, -2.0, 45.4])
    point2 = point1

    return point1 == point2
end

function setAssignsTheRightValuesToAnIdealPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = IdealPoint(originalValues)

    newValues = [-2.6, 6.2, 14.23]
    set!(point, newValues)

    return newValues == values(point)
end

function valueReturnsTheValueInTheIndicatedPositionInAnIdealPoint()
    values = [2.0, 4.1, -1.5]
    point = IdealPoint(values)

    return values[1] == value(point, 1) && values[2] == value(point, 2) && values[3] == value(point,3)
end

function valueUpdatesTheValueInTheIndicatedPositionInAnIdealPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = IdealPoint(originalValues)

    value!(point, 2, -25.5)

    return [2.0, -25.5, -1.5] == values(point)
end

function updateKeepsAnIdealPointUnchangedIfTheNewValuesAreAllHigher()
    originalValues = [2.0, 4.1, -1.5]
    point = IdealPoint(originalValues)

    newValues = [2.1, 6.2, 14.23]
    update!(point, newValues)

    return originalValues == values(point)
end

function updateModifiesTheFirstValueOfAnIdealPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = IdealPoint(originalValues)

    newValues = [1.999, 6.2, 14.23]
    update!(point, newValues)

    return [1.999, 4.1, -1.5] == values(point)
end

function updateModifiesTheLastValueOfAnIdealPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = IdealPoint(originalValues)

    newValues = [2.1, 6.2, -1.6]
    update!(point, newValues)

    return [2.0, 4.1, -1.6] == values(point)
end

function updateModifiesAllTheValuesOfAnIdealPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = IdealPoint(originalValues)

    newValues = [1.9, 4.0, -1.6]
    update!(point, newValues)

    return newValues == values(point)
end


@testset "IdealPoint tests" begin
    @test constructorCreatesAnIdealPointWithAGivenDimension()
    @test constructorCreatesAnIdealPointFillOfIntValues()
    @test constructorCreatesAnIdealPointFromAnotherPoint()
    @test constructorCreatesAnIdealPointFromAVector()
    @test dimensionOfAnIdealPointReturnsTheCorrectValue()
    @test equalsReturnsTrueIfTwoIdealPointsHaveTheSameValues()
    @test equalsReturnsTrueIfTwoIdealPointsAreTheSame()
    @test setAssignsTheRightValuesToAnIdealPoint()
    @test valueReturnsTheValueInTheIndicatedPositionInAnIdealPoint()
    @test valueUpdatesTheValueInTheIndicatedPositionInAnIdealPoint()
    @test updateKeepsAnIdealPointUnchangedIfTheNewValuesAreAllHigher()
    @test updateModifiesTheFirstValueOfAnIdealPoint()
    @test updateModifiesTheLastValueOfAnIdealPoint()
    @test updateModifiesAllTheValuesOfAnIdealPoint()
end

function constructorCreatesANadirPointWithAGivenDimension()
    dimension = 4
    point = NadirPoint(dimension)

    return dimension == length(values(point))
end


function constructorCreatesANadirPointFillOfIntValues()
    dimension = 4
    point = NadirPoint(dimension)

    return [-Inf, -Inf, -Inf, -Inf] == (values(point))
end

function constructorCreatesANadirPointFromAnotherPoint()
    point = NadirPoint([1.0, -2.0, 45.4])
    newPoint = NadirPoint(point)

    return values(point) == values(newPoint)
end

function constructorCreatesANadirPointFromAVector()
    vector = [2.0, -21, 26.0, 4e12]
    point = NadirPoint(vector)

    return values(point) == vector
end

function dimensionOfANadirPointReturnsTheCorrectValue()
    vector = [2.0, -21, 26.0, 4e12]
    point = NadirPoint(vector)

    return length(vector) == dimension(point)
end

function equalsReturnsTrueIfTwoNadirPointsHaveTheSameValues()
    point1 = NadirPoint([1.0, -2.0, 45.4])
    point2 = NadirPoint([1.0, -2.0, 45.4])

    return values(point1) == values(point2)
end

function equalsReturnsTrueIfTwoNadirPointsAreTheSame()
    point1 = NadirPoint([1.0, -2.0, 45.4])
    point2 = point1

    return point1 == point2
end

function setAssignsTheRightValuesToANadirPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = NadirPoint(originalValues)

    newValues = [-2.6, 6.2, 14.23]
    set!(point, newValues)

    return newValues == values(point)
end

function valueReturnsTheValueInTheIndicatedPositionInANadirPoint()
    values = [2.0, 4.1, -1.5]
    point = NadirPoint(values)

    return values[1] == value(point, 1) && values[2] == value(point, 2) && values[3] == value(point,3)
end

function valueUpdatesTheValueInTheIndicatedPositionInANadirPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = NadirPoint(originalValues)

    value!(point, 2, -25.5)

    return [2.0, -25.5, -1.5] == values(point)
end

function updateKeepsANadirPointUnchangedIfTheNewValuesAreAllLower()
    originalValues = [2.0, 4.1, -1.5]
    point = NadirPoint(originalValues)

    newValues = [1.9, 4.0, -2.0]
    update!(point, newValues)

    return originalValues == values(point)
end

function updateModifiesTheFirstValueOfANadirPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = NadirPoint(originalValues)

    newValues = [2.1, 4.0, -2.23]
    update!(point, newValues)

    return [2.1, 4.1, -1.5] == values(point)
end

function updateModifiesTheLastValueOfANadirPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = NadirPoint(originalValues)

    newValues = [2.1, 6.2, 1.5]
    update!(point, newValues)

    return [2.0, 4.1, 1.5] == values(point)
end

function updateModifiesAllTheValuesOfANadirPoint()
    originalValues = [2.0, 4.1, -1.5]
    point = NadirPoint(originalValues)

    newValues = [2.1, 4.2, -1.4]
    update!(point, newValues)

    return newValues == values(point)
end


@testset "NadirPoint tests" begin
    @test constructorCreatesANadirPointWithAGivenDimension()
    @test constructorCreatesANadirPointFillOfIntValues()
    @test constructorCreatesANadirPointFromAnotherPoint()
    @test constructorCreatesANadirPointFromAVector()
    @test dimensionOfANadirPointReturnsTheCorrectValue()
    @test equalsReturnsTrueIfTwoNadirPointsHaveTheSameValues()
    @test equalsReturnsTrueIfTwoNadirPointsAreTheSame()
    @test setAssignsTheRightValuesToANadirPoint()
    @test valueReturnsTheValueInTheIndicatedPositionInANadirPoint()
    @test valueUpdatesTheValueInTheIndicatedPositionInANadirPoint()
    @test updateKeepsANadirPointUnchangedIfTheNewValuesAreAllLower()
    @test updateModifiesTheFirstValueOfANadirPoint()
    @test updateModifiesTheLastValueOfANadirPoint()
    @test updateModifiesAllTheValuesOfANadirPoint()
end


