using MetaJul

# SMPSO algorithm configured from the ParticleSwarmOptimization template

function main()
    solver = ParticleSwarmOptimization()
    solver.name = "SMPSO"

    problem = ZDT6()
    swarmSize = 100

    solver.solutionsCreation = DefaultSolutionsCreation(problem, swarmSize)
    solver.evaluation = SequentialEvaluation(problem)
    solver.termination = TerminationByEvaluations(20000)

    solver.globalBest = CrowdingDistanceArchive(swarmSize, ContinuousSolution{Float64})

    solver.velocityInitialization = DefaultVelocityInitialization()
    solver.localBestInitialization = DefaultLocalBestInitialization()
    solver.globalBestInitialization = DefaultGlobalBestInitialization()
    
    solver.globalBestSelection = BinaryTournamentGlobalBestSelection(DefaultDominanceComparator())

    solver.inertiaWeightComputingStrategy = ConstantValueStrategy(0.1)
    
    mutationOperator = PolynomialMutation(probability = 1.0 / numberOfVariables(problem), distributionIndex = 20.0, bounds = problem.bounds)
    
    mutationFrequency = 6
    solver.perturbation = FrequencySelectionMutationBasedPerturbation(mutationFrequency, mutationOperator)    

    solver.globalBestUpdate = DefaultGlobalBestUpdate()
    solver.localBestUpdate = DefaultLocalBestUpdate(DefaultDominanceComparator())
    solver.positionUpdate = DefaultPositionUpdate(-1.0, -1.0, bounds(problem))

    c1Min = 1.5
    c1Max = 2.5
    c2Min = 1.5
    c2Max = 2.5

    solver.velocityUpdate = ConstrainedVelocityUpdate(c1Min, c1Max, c2Min, c2Max, problem)
    #solver.velocityUpdate = DefaultVelocityUpdate(c1Min, c1Max, c2Min, c2Max)

    observer = FrontPlotObserver(5000, name(problem), readFrontFromCSVFile("data/referenceFronts/ZDT6.csv"))
    register!(getObservable(solver), observer)

    optimize!(solver)

    foundSolutions = solver.foundSolutions

    objectivesFileName = "FUN.csv"
    variablesFileName = "VAR.csv"

    println("Algorithm: ", name(solver))

    println("Objectives stored in file ", objectivesFileName)
    printObjectivesToCSVFile(objectivesFileName, foundSolutions)

    println("Variables stored in file ", variablesFileName)
    printVariablesToCSVFile(variablesFileName, foundSolutions)
    println("Computing time: ", computingTime(solver))
end