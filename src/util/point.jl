abstract type Point end

function dimension(p::Point)::Int
    throw(MethodError(dimension, (p,)))
end

function values(p::Point)::Vector{Float64}
    throw(MethodError(values, (p,)))
end

function value(p::Point, index::Int)::Float64
    throw(MethodError(value, (p, index)))
end

function value!(p::Point, index::Int, val::Float64)
    throw(MethodError(value!, (p, index, val)))
end

function update!(p::Point, point::Vector{Float64})
    throw(MethodError(update!, (p, point)))
end

function set!(p::Point, point::Vector{Float64})
    throw(MethodError(set!, (p, point)))
end

##################
struct ArrayPoint <: Point
    point::Vector{Float64}

    ArrayPoint() = new()
    ArrayPoint(dimension::Int) = new(zeros(dimension))
    ArrayPoint(p::Point) = begin
        new([value(p, i) for i in 1:dimension(p)])
    end
    
    ArrayPoint(point::Vector{Float64}) = begin
        new(copy(point))
    end
end

function dimension(p::ArrayPoint)::Int
    return length(p.point)
end

function values(p::ArrayPoint)::Vector{Float64}
    return p.point
end

function value(p::ArrayPoint, index::Int)::Float64
    return p.point[index]  
end

function value!(p::ArrayPoint, index::Int, val::Float64)
    p.point[index] = val 
end

function update!(p::ArrayPoint, point::Vector{Float64})
    set!(p, point)
end

function set!(p::ArrayPoint, point::Vector{Float64})
    copyto!(p.point, point)
end

##################
struct IdealPoint <: Point
    point::Vector{Float64}

    IdealPoint() = new()
    
    IdealPoint(dimension::Int) = begin
        values = zeros(dimension)
        fill!(values, Inf)
        new(values)
    end

    IdealPoint(p::Point) = begin
        new([value(p, i) for i in 1:dimension(p)])
    end
    
    IdealPoint(point::Vector{Float64}) = begin
        new(copy(point))
    end

end

function dimension(p::IdealPoint)::Int
    return length(p.point)
end

function values(p::IdealPoint)::Vector{Float64}
    return p.point
end

function value(p::IdealPoint, index::Int)::Float64
    return p.point[index]  
end

function value!(p::IdealPoint, index::Int, val::Float64)
    p.point[index] = val 
end

function update!(p::IdealPoint, point::Vector{Float64})
    for i in 1:length(point)
        if p.point[i] > point[i]
            p.point[i] = point[i]
        end
    end
end

function set!(p::IdealPoint, point::Vector{Float64})
    copyto!(p.point, point)
end


##################
struct NadirPoint <: Point
    point::Vector{Float64}

    NadirPoint() = new()
    
    NadirPoint(dimension::Int) = begin
        values = zeros(dimension)
        fill!(values, -Inf)
        new(values)
    end
    
    NadirPoint(p::Point) = begin
        new([value(p, i) for i in 1:dimension(p)])
    end
    
    NadirPoint(point::Vector{Float64}) = begin
        new(copy(point))
    end

end

function dimension(p::NadirPoint)::Int
    return length(p.point)
end

function values(p::NadirPoint)::Vector{Float64}
    return p.point
end

function value(p::NadirPoint, index::Int)::Float64
    return p.point[index]  
end

function value!(p::NadirPoint, index::Int, val::Float64)
    p.point[index] = val 
end

function update!(p::NadirPoint, point::Vector{Float64})
    for i in 1:length(point)
        if p.point[i] < point[i]
            p.point[i] = point[i]
        end
    end
end

function set!(p::NadirPoint, point::Vector{Float64})
    copyto!(p.point, point)
end

