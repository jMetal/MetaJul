# Core structs

abstract type Solution end
abstract type Problem{T} end

abstract type Operator end
abstract type MutationOperator <: Operator end
abstract type CrossoverOperator <: Operator end
abstract type SelectionOperator <: Operator end

abstract type Component end
abstract type SolutionsCreation <: Component end
abstract type Evaluation <: Component end
abstract type Selection <: Component end
abstract type Variation <: Component end

abstract type Archive end
