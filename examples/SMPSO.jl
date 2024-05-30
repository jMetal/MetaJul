using MetaJul
using Dates

# SMPSO algorithm configured from the ParticleSwarmOptimization template

function main()

    solver = ParticleSwarmOptimization()
    solver.name = "SMPSO"

    problem = ZDT4()
    swarmSize = 100

    solver.solutionsCreation = DefaultSolutionsCreation(problem, swarmSize)
    solver.evaluation = SequentialEvaluation(problem)
    solver.termination = TerminationByEvaluations(25000)

    solver.globalBest = CrowdingDistanceArchive(swarmSize, ContinuousSolution{Float64})

    solver.velocityInitialization = DefaultVelocityInitialization()
    solver.localBestInitialization = DefaultLocalBestInitialization()
    solver.globalBestInitialization = DefaultGlobalBestInitialization()
    
    solver.globalBestSelection = BinaryTournamentGlobalBestSelection(DefaultDominanceComparator())

    solver.inertiaWeightComputingStrategy = ConstantValueStrategy(0.1)
    
    mutationOperarator = PolynomialMutation(1.0/numberOfVariables(problem), 20.0, bounds(problem))
    
    mutationFrequency = 6
    solver.perturbation = FrequencySelectionMutationBasedPerturbation(mutationFrequency, mutationOperarator)    

    solver.globalBestUpdate = DefaultGlobalBestUpdate()
    solver.localBestUpdate = DefaultLocalBestUpdate(DefaultDominanceComparator())
    solver.positionUpdate = DefaultPositionUpdate(-1.0, -1.0, bounds(problem))

    c1Min = 1.5
    c1Max = 2.5
    c2Min = 1.5
    c2Max = 2.5

    solver.velocityUpdate = ConstrainedVelocityUpdate(c1Min, c1Max, c2Min, c2Max, problem)
    #solver.velocityUpdate = DefaultVelocityUpdate(c1Min, c1Max, c2Min, c2Max)

    startingTime = Dates.now()
    optimize(solver)
    endTime = Dates.now()

    foundSolutions = solver.foundSolutions

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, foundSolutions)

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, foundSolutions)
    println("Computing time: ", (endTime - startingTime))
end