abstract type SequenceGenerator end

###########################################
# IntegerBoundedSequenceGenerator
###########################################

"""
This struct generates a bounded sequence of consecutive integer numbers. When the last number is generated, the sequence starts again.
"""
struct IntegerBoundedSequenceGenerator <: SequenceGenerator
    index::Int
    size::Int

    function IntegerBoundedSequenceGenerator(size::Int)
        @assert size > 0 "Size $size is not a positive number greater than zero"
        new(1, size)
    end
end

"""
Returns the current value in the sequence.
"""
function getValue(generator::IntegerBoundedSequenceGenerator)::Int
    return generator.index
end

"""
Generates the next value in the sequence. Wraps around to 0 when reaching the specified size.
"""
function generateNext!(generator::IntegerBoundedSequenceGenerator)
    generator.index += 1
    if generator.index == generator.size
        generator.index = 1
    end
end

"""
Returns the length of the sequence.
"""
function getSequenceLength(generator::IntegerBoundedSequenceGenerator)::Int
    return generator.size
end


###########################################
# IntegerPermutationGenerator
###########################################

"""
This struct generates a sequence of randomly permuted integers from 0 to size-1. When the sequence is exhausted,
a new random permutation is generated.
"""
mutable struct IntegerPermutationGenerator <: SequenceGenerator
    sequence::Vector{Int}
    index::Int
    size::Int

    function IntegerPermutationGenerator(size::Int)
        @assert size > 0 "Size $size is not a positive number greater than zero"
        new(randomPermutation(size), 1, size)
    end
end

"""
Returns the current value in the sequence.
"""
function getValue(generator::IntegerPermutationGenerator)::Int
    return generator.sequence[generator.index]
end

"""
Generates the next value in the sequence. If the sequence is exhausted, a new random permutation is generated.
"""
function generateNext!(generator::IntegerPermutationGenerator)
    generator.index += 1
    if generator.index == length(generator.sequence)
        generator.sequence = randomPermutation(generator.size)
        generator.index = 1
    end
end

"""
Generates a random permutation of integers from 1 to size.
"""
function randomPermutation(size::Int)::Vector{Int}
    permutation = collect(1:size)
    flag = fill(true, size)
    result = Vector{Int}(undef, size)

    num = 0
    while num < size
        # Julia starting index is 1, not 0
        start = rand(1:size)
        while true
            if flag[start]
                # Julia starting index is 1, not 0
                result[num + 1] = permutation[start]
                flag[start] = false
                num += 1
                break
            end
            start = (start == size) ? 1 : start + 1
        end
    end

    return result
end

"""
Returns the length of the sequence.
"""
function getSequenceLength(generator::IntegerPermutationGenerator)::Int
    return generator.size
end

function hasNext(generator::IntegerPermutationGenerator)::Bool
    return generator.index < generator.size - 1
end
