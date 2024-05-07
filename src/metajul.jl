module metajul

export Solution, Problem, Algorithm, ContinuousSolution, Component, Archive
include("core/coreTypes.jl")

include("solution.jl")

export ContinuousProblem
export addObjective, addVariable, createSolution, evaluate
include("continuousProblem.jl")

export SequentialEvaluation, SequentialEvaluationWithArchive
include("component/common/evaluation.jl")

export DefaultSolutionsCreation
export create
include("component/common/solutionsCreation.jl")

export Bounds
export restrict, createBounds, valueIsWithinBounds
include("util/bounds.jl")

export NonDominatedArchive
include("archive.jl")

export CrowdingDistanceArchive
include("densityEstimator.jl")

end # module metajul
