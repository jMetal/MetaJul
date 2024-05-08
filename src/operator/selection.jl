## Selection operators

struct RandomSelectionOperator <: SelectionOperator
end

function select(x::Vector, selectionOperator::RandomSelectionOperator)
  return x[rand(1:length(x))]
end

struct BinaryTournamentSelectionOperator <: SelectionOperator
  comparator::Function
end

function select(x::Vector, selectionOperator::BinaryTournamentSelectionOperator)
  comparator = selectionOperator.comparator
  index1 = rand(1:length(x))
  index2 = rand(1:length(x))

  if comparator(x[index1], x[index2]) < 0
    result = x[index1]
  else
    result = x[index2]
  end

  return result
end


