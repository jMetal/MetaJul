# Core types

abstract type Solution end
abstract type Problem{T} end
abstract type Algorithm end

abstract type Operator end
abstract type MutationOperator <: Operator end
abstract type CrossoverOperator <: Operator end
abstract type SelectionOperator <: Operator end

abstract type Component end
abstract type SolutionsCreation <: Component end
abstract type Evaluation <: Component end
abstract type Termination <: Component end

abstract type Selection <: Component end
abstract type Variation <: Component end
abstract type Replacement <: Component end

abstract type InertiaWeightComputingStrategy <: Component end 
abstract type VelocityInitialization <: Component end 
abstract type GlobalBestInitialization <: Component end 
abstract type GlobalBestSelection <: Component end 
abstract type GlobalBestUpdate <: Component end 
abstract type LocalBestInitialization <: Component end 
abstract type LocalBestUpdate <: Component end 
abstract type Perturbation <: Component end 
abstract type PositionUpdate <: Component end 
abstract type VelocityUpdate <: Component end 

abstract type Ranking end
abstract type DensityEstimator end

abstract type Comparator end
abstract type Archive end

abstract type QualityIndicator end
