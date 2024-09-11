abstract type Neighborhood{S} end

# ChatGPT code
function minFastSort(x::Vector{Float64}, idx::Vector{Int}, numberOfWeightVectors::Int, neighborhoodSize::Int)
    for i in 1:neighborhoodSize
        for j in (i+1):numberOfWeightVectors
            if x[i] > x[j]
                temp = x[i]
                x[i] = x[j]
                x[j] = temp

                id = idx[i]
                idx[i] = idx[j]
                idx[j] = id
            end
        end
    end
end


#= Gemini and Claude code
function minFastSort!(x::Vector{Float64}, idx::Vector{Int}, n::Int, m::Int)
    for i in 1:m
        for j in i+1:n
            if x[i] > x[j]
                x[i], x[j] = x[j], x[i]
                idx[i], idx[j] = idx[j], idx[i]
            end
        end
    end
end
=#

struct WeightVectorNeighborhood{S <: Solution} <: Neighborhood{S}
    numberOfWeightVectors::Int
    weightVectorSize::Int
    neighborhood::Array{Int,2}
    weightVector::Array{Float64,2}
    neighborhoodSize::Int

    function WeightVectorNeighborhood(numberOfWeightVectors::Int, neighborhoodSize::Int)
        weightVectorSize = 2

        neighborhood = Array{Int,2}(undef, numberOfWeightVectors, neighborhoodSize)
        weightVector = Array{Float64,2}(undef, numberOfWeightVectors, weightVectorSize)

        for n in 1:numberOfWeightVectors
            a = 1.0 * (n - 1) / (numberOfWeightVectors - 1)
            weightVector[n, 1] = a
            weightVector[n, 2] = 1 - a
        end

        weightVectorNeighborhood = new{S}(numberOfWeightVectors, weightVectorSize, neighborhood, weightVector, neighborhoodSize)
        initializeNeighborhood(weightVectorNeighborhood)
        return obj
    end
end

function initializeNeighborhood(weightVectorNeighborhood::WeightVectorNeighborhood)
    numberOfWeightVectors = weightVectorNeighborhood.numberOfWeightVectors
    neighborhoodSize = weightVectorNeighborhood.neighborhoodSize
    weightVector = weightVectorNeighborhood.weightVector
    neighborhood = weightVectorNeighborhood.neighborhood

    x = Vector{Float64}(undef, numberOfWeightVectors)
    idx = Vector{Int}(undef, numberOfWeightVectors)

    for i in 1:numberOfWeightVectors
        # calculate the distances based on weight vectors
        for j in 1:numberOfWeightVectors
            x[j] = norm(weightVector[i, :] - weightVector[j, :])
            idx[j] = j
        end

        # find 'niche' nearest neighboring sub problems
        minFastSort!(x, idx, numberOfWeightVectors, neighborhoodSize)

        neighborhood[i, :] .= idx[1:neighborhoodSize]
    end
end

function getNeighbors(weightVectorNeighborhood::WeightVectorNeighborhood, solutionList::Vector{S}, solutionIndex::Int)
    neighbourSolutions = Vector{S}()
    for neighborIndex in weightVectorNeighborhood.neighborhood[solutionIndex, :]
        push!(neighbourSolutions, solutionList[neighborIndex])
    end
    return neighbourSolutions
end
