module metajul

export Solution, Problem, Algorithm, ContinuousSolution, Component, Archive
include("core/coreTypes.jl")

export ContinuousSolution
include("core/solution.jl")

export ContinuousProblem
export addObjective, addVariable, createSolution, evaluate
include("continuousProblem.jl")

export Bounds
export restrict, createBounds, valueIsWithinBounds
include("util/bounds.jl")

export compareElementAt, compareForDominance, compareForOverallConstraintViolationDegree
export compareForConstraintsAndDominance
include("util/comparator.jl")

export NonDominatedArchive
export add!, isEmpty, contain, getSolutions
include("util/archive.jl")

export CrowdingDistanceArchive
include("densityEstimator.jl")

export SequentialEvaluation, SequentialEvaluationWithArchive
include("component/common/evaluation.jl")

export DefaultSolutionsCreation
export create
include("component/common/solutionsCreation.jl")

end # module metajul
