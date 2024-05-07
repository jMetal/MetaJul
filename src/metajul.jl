module metajul

export Solution, Problem, Algorithm, ContinuousSolution, Component, Archive
include("core/coreTypes.jl")

export ContinuousSolution
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
include("util/ranking.jl")

export CrowdingDistanceArchive
include("densityEstimator.jl")

export SequentialEvaluation, SequentialEvaluationWithArchive
include("component/common/evaluation.jl")

export DefaultSolutionsCreation
export create
include("component/common/solutionsCreation.jl")

end # module metajul
