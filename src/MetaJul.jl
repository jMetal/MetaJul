module MetaJul

export Bounds
export restrict, createBounds, valueIsWithinBounds
include("util/bounds.jl")

export Solution, Problem, Algorithm, ContinuousSolution, Component, Archive, Selection
include("core/coreTypes.jl")

export numberOfViolatedConstraints, overallConstraintViolationDegree, isFeasible
include("core/constraintHandling.jl")

export ContinuousSolution
export copySolution
include("solution/binarySolution.jl")

export BinarySolution
export initBitVector, copySolution, bitFlip
include("solution/continuousSolution.jl")

export PermutationSolution
export checkIfPermutationIsValid
include("solution/permutationSolution.jl")

export DominanceRanking, DominanceRankingComparator
export numberOfRanks, getSubFront, appendRank!, compute!, getRank, setRank
export compare, computeCrowdingDistanceEstimator!, getCrowdingDistance
export maxCrowdingDistanceValue, setCrowdingDistance, compareCrowdingDistance
export capacity, isFull
include("util/ranking.jl")

export CrowdingDistanceDensityEstimator
include("util/densityEstimator.jl")

export Comparator, ElementAtComparator, DefaultDominanceComparator, IthObjectiveComparator, IthObjectiveComparator, RankingAndCrowdingDistanceComparator
export OverallConstraintViolationDegreeComparator, ConstraintsAndDominanceComparator
export CrowdingDistanceComparator
export compare
include("util/comparator.jl")

export Neighborhood
export minFastSort!
export WeightVectorNeighborhood, getNeighbors
include("util/neighborhood.jl")

export NonDominatedArchive, CrowdingDistanceArchive
export add!, isEmpty, contain, getSolutions
include("util/archive.jl")

export PolynomialMutation, BitFlipMutation, UniformMutation, PermutationSwapMutation
export mutate!
include("operator/mutation.jl")

export BinaryTournamentSelectionOperator, RandomSelectionOperator, NaryRandomSelectionOperator
include("operator/selection.jl")

export BLXAlphaCrossover, SBXCrossover, SinglePointCrossover, IntegerSBXCrossover, PMXCrossover
export recombine, numberOfDescendants, numberOfRequiredParents
include("operator/crossover.jl")

export SequentialEvaluation, SequentialEvaluationWithArchive, MultithreadedEvaluation
include("component/common/evaluation.jl")

export DefaultSolutionsCreation
export create
include("component/common/solutionsCreation.jl")

export TerminationByComputingTime, TerminationByEvaluations, TerminationByIterations
export isMet
include("component/common/termination.jl")

export SequenceGenerator, IntegerBoundedSequenceGenerator, IntegerPermutationGenerator
export getValue, generateNext!, getSequenceLength
include("util/sequenceGenerator.jl")

export RandomSelection, BinaryTournamentSelection, PopulationAndNeighborhoodSelection
export select
include("component/evolutionaryAlgorithm/selection.jl")

export CrossoverAndMutationVariation
export variate
include("component/evolutionaryAlgorithm/variation.jl")

export Point, ArrayPoint, IdealPoint, NadirPoint
export dimension, values, value, value!, update!, set!
include("util/point.jl")

export AggregationFunction, WeightedSum, PenaltyBoundaryIntersection
export compute
include("util/aggregationFunction.jl")

export MuCommaLambdaReplacement, MuPlusLambdaReplacement, RankingAndDensityEstimatorReplacement, MOEADReplacement
export replace_, replace_!, update_ideal_point!, update_nadir_point!
include("component/evolutionaryAlgorithm/replacement.jl")

export ConstantValueStrategy
export compute
include("component/particleSwarmOptimization/inertiaWeightComputingStrategy.jl")

export DefaultVelocityInitialization
export initialize
include("component/particleSwarmOptimization/velocityInitialization.jl")

export DefaultGlobalBestInitialization
export initialize
include("component/particleSwarmOptimization/globalBestInitialization.jl")

export BinaryTournamentGlobalBestSelection
export select
include("component/particleSwarmOptimization/globalBestSelection.jl")

export DefaultGlobalBestUpdate
export update
include("component/particleSwarmOptimization/globalBestUpdate.jl")

export DefaultLocalBestInitialization
export initialize
include("component/particleSwarmOptimization/localBestInitialization.jl")

export DefaultLocalBestUpdate
export update
include("component/particleSwarmOptimization/localBestUpdate.jl")

export FrequencySelectionMutationBasedPerturbation
export perturbate!
include("component/particleSwarmOptimization/perturbation.jl")

export DefaultPositionUpdate
export update
include("component/particleSwarmOptimization/positionUpdate.jl")

export DefaultVelocityUpdate, ConstrainedVelocityUpdate
export update
include("component/particleSwarmOptimization/velocityUpdate.jl")

export normalizeObjectives, distanceBasedSubsetSelection, printObjectivesToCSVFile, printVariablesToCSVFile, readFrontFromCSVFile
include("util/utils.jl")

export Observable, EvaluationObserver, FitnessObserver, getObservable, FrontPlotObserver, register!
include("util/observer.jl")

export BinaryProblem, ContinuousProblem, constrainedProblem, PermutationProblem
export addObjective, addVariable, addConstraint, createSolution, evaluate, setName, name
export bounds
export numberOfVariables, numberOfObjectives, numberOfConstraints
include("problem/binaryProblem.jl")
include("problem/continuousProblem.jl")
include("problem/permutationProblem.jl")

export tanaka, osyczka2, srinivas, binh2, constrEx, golinski
include("problem/multiObjective/constrainedProblems.jl")

export oneMax, sphere
include("problem/singleObjective/oneMax.jl")
include("problem/singleObjective/sphere.jl")

export fonseca, kursawe, ZDT1, ZDT2, ZDT3, ZDT4, ZDT6, oneZeroMax, schaffer
include("problem/multiObjective/schaffer.jl")
include("problem/multiObjective/fonseca.jl")
include("problem/multiObjective/kursawe.jl")
include("problem/multiObjective/ZDT.jl")
include("problem/multiObjective/oneZeroMax.jl")

export multiObjectiveTSP
include("problem/multiObjective/multiObjectiveTSP.jl")

export multiObjectiveKnapsack
include("problem/multiObjective/multiObjectiveKnapsack.jl")

export subasi2016
include("problem/multiObjective/rwa.jl")

export LocalSearch
export optimize!, computingTime
include("algorithm/localSearch.jl")

export EvolutionaryAlgorithm
export optimize!, status, computingTime, foundSolutions
include("algorithm/evolutionaryAlgorithm.jl")

export ParticleSwarmOptimization
export optimize!, computingTime
include("algorithm/particleSwarmOptimization.jl")

export GeneticAlgorithm
export optimize!, computingTime, foundSolution
include("algorithm/geneticAlgorithm.jl")

export NSGAII
export optimize!, foundSolutions, observable
include("algorithm/NSGAII.jl")

export toString
include("util/toString.jl")

export readTSPLibFile, computeTourDistance
include("util/tspUtils.jl")

export integerProblem
include("problem/multiObjective/integerProblem.jl")

export distance_to_closest_vector, distance_to_closest_vector_dominance, dominance_distance, weakly_dominates, dominates
export inverted_generational_distance
export inverted_generational_distance_plus
export additive_epsilon
export multiplicative_epsilon
include("util/qualityIndicator.jl")

end 
# module metajul
