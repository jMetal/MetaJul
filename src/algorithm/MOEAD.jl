using Dates

mutable struct MOEAD <: Algorithm
    problem::Problem
    populationSize::Int
    neighborhoodSize::Int
    maxReplacedSolutions::Int
    neighborhoodSelectionProbability::Float64
    aggregationFunction::AggregationFunction
    crossover::CrossoverOperator
    mutation::MutationOperator
    sequenceGenerator::SequenceGenerator
    termination::Termination
    normalize::Bool

    solver::EvolutionaryAlgorithm

    function MOEAD(
        problem::ContinuousProblem;
        populationSize = 100,
        neighborhoodSize = 20,
        maxReplacedSolutions = 2,
        neighborhoodSelectionProbability = 0.9,
        aggregationFunction = PenaltyBoundaryIntersection(5.0, true),
        crossover = SBXCrossover(probability = 1.0, distributionIndex = 20.0, bounds = problem.bounds),
        mutation = PolynomialMutation(probability = 1.0 / numberOfVariables(problem), distributionIndex = 20.0, bounds = problem.bounds),
        sequenceGenerator = IntegerPermutationGenerator(populationSize),
        termination = TerminationByEvaluations(25000),
        normalize = true
    )
        algorithm = new()
        algorithm.solver = EvolutionaryAlgorithm()
        algorithm.solver.name = "MOEA/D"
        algorithm.problem = problem
        algorithm.populationSize = populationSize
        algorithm.neighborhoodSize = neighborhoodSize
        algorithm.maxReplacedSolutions = maxReplacedSolutions
        algorithm.neighborhoodSelectionProbability = neighborhoodSelectionProbability
        algorithm.aggregationFunction = aggregationFunction
        algorithm.crossover = crossover
        algorithm.mutation = mutation
        algorithm.sequenceGenerator = sequenceGenerator
        algorithm.termination = termination
        algorithm.normalize = normalize

        return algorithm
    end

    function optimise!(moead::MOEAD)
        solver = moead.solver
        problem = moead.problem

        solver.solutionsCreation = DefaultSolutionsCreation(problem, moead.populationSize)
        solver.evaluation = SequentialEvaluation(problem)
        solver.termination = moead.termination

        variation = CrossoverAndMutationVariation(1, moead.crossover, moead.mutation)
        solver.variation = variation

        if problem.numberOfObjectives == 2
            neighborhood = WeightVectorNeighborhood(moead.populationSize, moead.neighborhoodSize)
        else
            throw(DomainError("Number of objectives > 2 is not currently supported."))
            # neighborhood = WeightVectorNeighborhood(moead.populationSize, problem.numberOfObjectives, moead.neighborhoodSize, "path/to/weight-vectors.dat")
        end

        selection = PopulationAndNeighborhoodSelection(
            variation.matingPoolSize,
            moead.sequenceGenerator,
            neighborhood,
            moead.neighborhoodSelectionProbability,
            true
        )
        solver.selection = selection

        replacement = MOEADReplacement(
            selection,
            neighborhood,
            moead.aggregationFunction,
            moead.sequenceGenerator,
            moead.maxReplacedSolutions,
            moead.normalize
        )
        solver.replacement = replacement

        return evolutionaryAlgorithm(solver)
    end

    function foundSolutions(moead::MOEAD)
        return moead.solver.foundSolutions
    end

    function name(moead::MOEAD)
        return name(moead.solver)
    end

    function status(moead::MOEAD)
        return status(moead.solver)
    end

    function computingTime(moead::MOEAD)
        return status(moead)["COMPUTING_TIME"]
    end

    function observable(moead::MOEAD)
        return observable(moead.solver)
    end
end