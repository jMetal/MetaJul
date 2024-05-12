struct BinaryTournamentGlobalBestSelection <: GlobalBestSelection
    dominanceComparator::Function
end

function select(globalBestSolutions::Vector{ContinuousSolution{Float64}}, globalBestSelection::BinaryTournamentGlobalBestSelection)
    position1 = rand(1:length(globalBestSolutions))
    position2 = rand(1:length(globalBestSolutions))

    solution1 = globalBestSolutions[position1]
    solution2 = globalBestSolutions[position2]

    globalBest = solution2

    if globalBestSelection.dominanceComparator(solution1, solution2) < 1
        globalBest = copySolution(solution1)
    else
        globalBest = copySolution(solution2)
    end

    return globalBest
end
