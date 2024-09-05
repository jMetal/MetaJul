# Unit tests for Point

using MetaJul: values

function constructorCreatesAPointWithAGivenDimension()
    dimension = 4
    point = ArrayPoint(dimension)

    return values(point) == zeros(dimension)
end

function constructorCreatesAPointFromAnotherPoint()
    point = ArrayPoint([1.0, -2.0, 45.4])
    newPoint = ArrayPoint(point)

    return values(point) == values(newPoint)
end


function constructorCreatesAPointFromAVector()
    vector = [2.0, -21, 26.0, 4e12]
    point = ArrayPoint(vector)

    return values(point) == vector
end

function dimensionOfAnArrayPointReturnsTheCorrectValue()
    vector = [2.0, -21, 26.0, 4e12]
    point = ArrayPoint(vector)

    return length(vector) == dimension(point)
end

function equalsReturnsTrueIfTwoPointsHaveTheSameValues()
    point1 = ArrayPoint([1.0, -2.0, 45.4])
    point2 = ArrayPoint([1.0, -2.0, 45.4])

    return values(point1) == values(point2)
end

function equalsReturnsTrueIfTwoPointsAreTheSame()
    point1 = ArrayPoint([1.0, -2.0, 45.4])
    point2 = point1

    return point1 == point2
end

function setAssignsTheRightValues()
    originalValues = [2.0, 4.1, -1.5]
    point = ArrayPoint(originalValues)

    newValues = [-2.6, 6.2, 14.23]
    set!(point, newValues)

    return newValues == values(point)
end

function updateAssignsTheRightValues()
    originalValues = [2.0, 4.1, -1.5]
    point = ArrayPoint(originalValues)

    newValues = [-2.6, 6.2, 14.23]
    update!(point, newValues)

    return newValues == values(point)
end

function valueReturnsTheValueInTheIndicatedPosition()
    values = [2.0, 4.1, -1.5]
    point = ArrayPoint(values)

    return values[1] == value(point, 1) && values[2] == value(point, 2) && values[3] == value(point,3)
end

function valueUpdatesTheValueInTheIndicatedPosition()
    originalValues = [2.0, 4.1, -1.5]
    point = ArrayPoint(originalValues)

    value!(point, 2, -25.5)

    return [2.0, -25.5, -1.5] == values(point)
end


@testset "ArrayPoint tests" begin
    @test constructorCreatesAPointWithAGivenDimension()
    @test constructorCreatesAPointFromAnotherPoint()
    @test constructorCreatesAPointFromAVector()
    @test dimensionOfAnArrayPointReturnsTheCorrectValue()
    @test equalsReturnsTrueIfTwoPointsHaveTheSameValues()
    @test equalsReturnsTrueIfTwoPointsAreTheSame()
    @test setAssignsTheRightValues()
    @test updateAssignsTheRightValues()
    @test valueReturnsTheValueInTheIndicatedPosition()
    @test valueUpdatesTheValueInTheIndicatedPosition()
end

