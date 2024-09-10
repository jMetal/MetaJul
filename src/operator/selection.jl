## Selection operators

struct RandomSelectionOperator <: SelectionOperator
end

function select(x::Vector, selectionOperator::RandomSelectionOperator)
  return x[rand(1:length(x))]
end

struct BinaryTournamentSelectionOperator <: SelectionOperator
  comparator::Comparator
end

function select(x::Vector, selectionOperator::BinaryTournamentSelectionOperator)
  comparator = selectionOperator.comparator
  index1 = rand(1:length(x))
  index2 = rand(1:length(x))

  if compare(comparator, x[index1], x[index2]) < 0
    result = x[index1]
  else
    result = x[index2]
  end

  return result
end

struct NaryRandomSelectionOperator <: SelectionOperator
  numberOfSolutionsToBeReturned::Int
  # Constructor to handle default value
  NaryRandomSelectionOperator(n::Int = 1) = new(n)
end

function select(x::Vector, selectionOperator::NaryRandomSelectionOperator)
  @assert length(x) >= selectionOperator.numberOfSolutionsToBeReturned "Solution list size ($length(x)) is less than the number of requested solutions ($(selectionOperator.numberOfSolutionsToBeReturned))"

  return x[randperm(length(x))[1:selectionOperator.numberOfSolutionsToBeReturned]]
end
