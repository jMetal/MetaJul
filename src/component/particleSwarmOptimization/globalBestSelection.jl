struct BinaryTournamentGlobalBestSelection <: GlobalBestSelection
    dominanceComparator::Comparator
end

function select(globalBestSelection::BinaryTournamentGlobalBestSelection, globalBestSolutions::Vector{ContinuousSolution{Float64}}, )
    position1 = rand(1:length(globalBestSolutions))
    position2 = rand(1:length(globalBestSolutions))

    solution1 = globalBestSolutions[position1]
    solution2 = globalBestSolutions[position2]

    globalBest = solution2

    if compare(globalBestSelection.dominanceComparator, solution1, solution2) < 1
        globalBest = copySolution(solution1)
    else
        globalBest = copySolution(solution2)
    end

    return globalBest
end
