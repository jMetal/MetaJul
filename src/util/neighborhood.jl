abstract type Neighborhood end

function minFastSort(x::Vector{Float64}, idx::Vector{Int}, n::Int, m::Int)
    for i in 1:m
        for j in (i+1):n
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