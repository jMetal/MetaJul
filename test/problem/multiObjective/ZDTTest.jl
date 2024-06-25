zdt1 = ZDT1()
solutionZDT1 = createSolution(zdt1)

const ZDT1DefaultNumberOfVariables::Int = 30 

zdt1_100 = ZDT1(numberOfVariables = 100)
@testset "ZDT1 problem tests" begin    
    @test numberOfVariables(zdt1) == ZDT1DefaultNumberOfVariables
    @test numberOfObjectives(zdt1) == 2
    @test numberOfConstraints(zdt1) == 0
    @test bounds(zdt1)[1].lowerBound == 0.0
    @test bounds(zdt1)[1].upperBound == 1.0
    @test name(zdt1) == "ZDT1"

    @test length(solutionZDT1.variables) == numberOfVariables(zdt1)
    @test length(solutionZDT1.objectives) == numberOfObjectives(zdt1)
    @test length(solutionZDT1.constraints) == numberOfConstraints(zdt1)

    @test solutionZDT1.bounds == zdt1.bounds
    @test solutionZDT1.variables[1] <= solutionZDT1.bounds[1].upperBound
    @test solutionZDT1.variables[1] >= solutionZDT1.bounds[1].lowerBound

    @test numberOfVariables(zdt1_100) == 100 
end

zdt2 = ZDT2()
solutionZDT2 = createSolution(zdt2)

const ZDT2DefaultNumberOfVariables::Int = 30 
zdt2_100 = ZDT2(numberOfVariables = 100)
@testset "ZDT2 problem tests" begin    
    @test numberOfVariables(zdt2) == ZDT2DefaultNumberOfVariables
    @test numberOfObjectives(zdt2) == 2
    @test numberOfConstraints(zdt2) == 0
    @test bounds(zdt2)[1].lowerBound == 0.0
    @test bounds(zdt2)[1].upperBound == 1.0
    @test name(zdt2) == "ZDT2"

    @test length(solutionZDT2.variables) == numberOfVariables(zdt2)
    @test length(solutionZDT2.objectives) == numberOfObjectives(zdt2)
    @test length(solutionZDT2.constraints) == numberOfConstraints(zdt2)

    @test solutionZDT2.bounds == zdt2.bounds
    @test solutionZDT2.variables[1] <= solutionZDT2.bounds[1].upperBound
    @test solutionZDT2.variables[1] >= solutionZDT2.bounds[1].lowerBound

    @test numberOfVariables(zdt2_100) == 100 
end

zdt3 = ZDT3()
solutionZDT3 = createSolution(zdt3)

const ZDT3DefaultNumberOfVariables::Int = 30 
zdt3_100 = ZDT3(numberOfVariables = 100)
@testset "ZDT2 problem tests" begin    
    @test numberOfVariables(zdt3) == ZDT2DefaultNumberOfVariables
    @test numberOfObjectives(zdt3) == 2
    @test numberOfConstraints(zdt3) == 0
    @test bounds(zdt3)[1].lowerBound == 0.0
    @test bounds(zdt3)[1].upperBound == 1.0
    @test name(zdt3) == "ZDT3"

    @test length(solutionZDT3.variables) == numberOfVariables(zdt3)
    @test length(solutionZDT3.objectives) == numberOfObjectives(zdt3)
    @test length(solutionZDT3.constraints) == numberOfConstraints(zdt3)

    @test solutionZDT3.bounds == zdt3.bounds
    @test solutionZDT3.variables[1] <= solutionZDT3.bounds[1].upperBound
    @test solutionZDT3.variables[1] >= solutionZDT3.bounds[1].lowerBound

    @test numberOfVariables(zdt3_100) == 100 
end

zdt4 = ZDT4()
solutionZDT4 = createSolution(zdt4)

const ZDT4DefaultNumberOfVariables::Int = 10 
zdt4_25 = ZDT4(numberOfVariables = 25)
@testset "ZDT4 problem tests" begin    
    @test numberOfVariables(zdt4) == ZDT4DefaultNumberOfVariables
    @test numberOfObjectives(zdt4) == 2
    @test numberOfConstraints(zdt4) == 0
    @test bounds(zdt4)[1].lowerBound == 0.0
    @test bounds(zdt4)[1].upperBound == 1.0
    @test name(zdt4) == "ZDT4"

    @test length(solutionZDT4.variables) == numberOfVariables(zdt4)
    @test length(solutionZDT4.objectives) == numberOfObjectives(zdt4)
    @test length(solutionZDT4.constraints) == numberOfConstraints(zdt4)

    @test solutionZDT4.bounds == zdt4.bounds
    @test solutionZDT4.variables[1] <= solutionZDT4.bounds[1].upperBound
    @test solutionZDT4.variables[1] >= solutionZDT4.bounds[1].lowerBound

    @test numberOfVariables(zdt4_25) == 25 
end


zdt6 = ZDT6()
solutionZDT6 = createSolution(zdt6)

const ZDT6DefaultNumberOfVariables::Int = 10 
zdt6_200 = ZDT6(numberOfVariables = 200)
@testset "ZDT6 problem tests" begin    
    @test numberOfVariables(zdt6) == ZDT6DefaultNumberOfVariables
    @test numberOfObjectives(zdt6) == 2
    @test numberOfConstraints(zdt6) == 0
    @test bounds(zdt6)[1].lowerBound == 0.0
    @test bounds(zdt6)[1].upperBound == 1.0
    @test name(zdt6) == "ZDT6"

    @test length(solutionZDT6.variables) == numberOfVariables(zdt6)
    @test length(solutionZDT6.objectives) == numberOfObjectives(zdt6)
    @test length(solutionZDT6.constraints) == numberOfConstraints(zdt6)

    @test solutionZDT6.bounds == zdt6.bounds
    @test solutionZDT6.variables[1] <= solutionZDT6.bounds[1].upperBound
    @test solutionZDT6.variables[1] >= solutionZDT6.bounds[1].lowerBound

    @test numberOfVariables(zdt6_200) == 200 
end
