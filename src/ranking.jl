# Struct and methods to implement the non-dominated ranking sorting method

struct Ranking{T <: Solution}
    rank::Array{Array}
end

function computeRanking(solutions::Array{T}) where {T <: Solution}

end