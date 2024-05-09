module metajul

export Bounds
export restrict, createBounds, valueIsWithinBounds
include("util/bounds.jl")

export Solution, Problem, Algorithm, ContinuousSolution, Component, Archive
include("core/coreTypes.jl")

export ContinuousSolution, BinarySolution
export initBitVector, copySolution, bitFlip
include("core/solution.jl")

export numberOfViolatedConstraints, overallConstraintViolationDegree, isFeasible
include("core/constraintHandling.jl")

export compareElementAt, compareForDominance, compareIthObjective, compareForOverallConstraintViolationDegree, compareRankingAndCrowdingDistance
export compareForConstraintsAndDominance
include("util/comparator.jl")

export NonDominatedArchive
export add!, isEmpty, contain, getSolutions
include("util/archive.jl")

export Ranking
export numberOfRanks, getSubFront, appendRank!, computeRanking!, getRank, setRank
export compareRanking, computeCrowdingDistanceEstimator!, getCrowdingDistance
export maxCrowdingDistanceValue, setCrowdingDistance, compareCrowdingDistance
export capacity, isFull
include("util/ranking.jl")

export CrowdingDistanceArchive
include("util/densityEstimator.jl")

export PolynomialMutation, BitFlipMutation, UniformMutation
export mutate
include("operator/mutation.jl")

export BinaryTournamentSelectionOperator, RandomSelectionOperator
include("operator/selection.jl")

export BLXAlphaCrossover, SBXCrossover, SinglePointCrossover
export recombine, numberOfDescendants, numberOfRequiredParents
include("operator/crossover.jl")

export SequentialEvaluation, SequentialEvaluationWithArchive
include("component/common/evaluation.jl")

export DefaultSolutionsCreation
export create
include("component/common/solutionsCreation.jl")

export TerminationByComputingTime, TerminationByEvaluations
export isMet
include("component/common/termination.jl")

export RandomSelection, BinaryTournamentSelection
export select
include("component/evolutionaryAlgorithm/selection.jl")

export CrossoverAndMutationVariation
export variate
include("component/evolutionaryAlgorithm/variation.jl")

export MuCommaLambdaReplacement, MuPlusLambdaReplacement, RankingAndDensityEstimatorReplacement
export replace_ 
include("component/evolutionaryAlgorithm/replacement.jl")

export normalizeObjectives, distanceBasedSubsetSelection
include("util/utils.jl")

export Observable, EvaluationObserver
include("util/observer.jl")

export BinaryProblem, ContinuousProblem, constrainedProblem
export addObjective, addVariable, addConstraint, createSolution, evaluate, setName, name
export bounds
export numberOfVariables, numberOfObjectives, numberOfConstraints
include("problem/binaryProblem.jl")
include("problem/constrainedProblem.jl")
include("problem/continuousProblem.jl")

export oneMax, sphere
include("problem/singleObjective/oneMax.jl")
include("problem/singleObjective/sphere.jl")

export fonseca, kursawe, ZDT1, ZDT2, ZDT3, ZDT4, ZDT6, oneZeroMax, schaffer
include("problem/multiObjective/schaffer.jl")
include("problem/multiObjective/fonseca.jl")
include("problem/multiObjective/kursawe.jl")
include("problem/multiObjective/ZDT.jl")
include("problem/multiObjective/oneZeroMax.jl")

export LocalSearch
export optimize
include("algorithm/localSearch.jl")

end # module metajul
