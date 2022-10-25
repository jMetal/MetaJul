# Core structs

abstract type Solution end
abstract type Problem{T} end

abstract type Operator end
abstract type MutationOperator <: Operator end
abstract type CrossoverOperator <: Operator end
