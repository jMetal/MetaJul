## Selection operators

function randomSelection(x::Vector, parameters=[])
  return x[rand(1:length(x))]
end

struct RandomSelectionOperator <: SelectionOperator
  parameters::NamedTuple
  compute::Function
  function RandomSelection(parameters)
    new(parameters, randomSelection)
  end
end


function binaryTournamentSelection(x::Vector{S}, parameters::NamedTuple{(:comparator,), Tuple{Function}}) where {S <: Solution}
  comparator = parameters.comparator
  index1 = rand(1:length(x))
  index2 = rand(1:length(x))

  if comparator(x[index1], x[index2]) < 0
    result = x[index1]
  else
    result = x[index2]
  end

  return result
end

struct BinaryTournamentSelectionOperator <: SelectionOperator
  parameters::NamedTuple{(:comparator,), Tuple{Function}}
  compute::Function
  function BinaryTournamentSelectionOperator(parameters)
    new(parameters, binaryTournamentSelection)
  end
end

