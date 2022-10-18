
function printObjectivesToCSVFile(fileName::String, solutions::Vector{T}) where {T <: Solution}
    open(fileName, "w") do outputFile
        for solution in solutions
            line = join(solution.objectives, ",")
            println(outputFile, line)
        end
    end
end

function printVariablesToCSVFile(fileName::String, solutions::Vector{T}) where {T <: ContinuousSolution}
    open(fileName, "w") do outputFile
        for solution in solutions
            line = join(solution.variables, ",")
            println(outputFile, line)
        end
    end
end

function printVariablesToCSVFile(fileName::String, solutions::Vector{BinarySolution}) 
    open(fileName, "w") do outputFile
        for solution in solutions
            line = toString(solution.variables)
            println(outputFile, line)
        end
    end
end