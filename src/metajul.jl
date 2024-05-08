module metajul

export Solution, Problem, Algorithm, ContinuousSolution, Component, Archive
include("core/coreTypes.jl")

export ContinuousSolution, BinarySolution
export initBitVector, copySolution
include("core/solution.jl")

export ContinuousProblem
export schafferProblem, sphereProblem
export addObjective, addVariable, addConstraint, createSolution, evaluate, setName, name
export bounds
export numberOfVariables, numberOfObjectives, numberOfConstraints
include("problem/continuousProblem.jl")

export Bounds
export restrict, createBounds, valueIsWithinBounds
include("util/bounds.jl")

export compareElementAt, compareForDominance, compareForOverallConstraintViolationDegree
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

export SequentialEvaluation, SequentialEvaluationWithArchive
include("component/common/evaluation.jl")

export DefaultSolutionsCreation
export create
include("component/common/solutionsCreation.jl")

export PolynomialMutation, BitFlipMutation, UniformMutation
export mutate
include("operator/mutation.jl")

end # module metajul
