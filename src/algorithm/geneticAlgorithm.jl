using Dates

mutable struct GeneticAlgorithm <: Algorithm
  problem::Problem
  populationSize::Int

  termination::Termination
  mutation::MutationOperator
  crossover::CrossoverOperator

  solver::EvolutionaryAlgorithm

  function GeneticAlgorithm(
    problem :: ContinuousProblem; 
    populationSize = 100, 
    termination = TerminationByEvaluations(100000),
    crossover = SBXCrossover(probability = 1.0, distributionIndex = 20.0, bounds = problem.bounds),
    mutation = PolynomialMutation(probability = 1.0/numberOfVariables(problem), distributionIndex = 20.0, bounds = problem.bounds))
    algorithm = new()
    algorithm.solver = EvolutionaryAlgorithm()
    algorithm.solver.name = "GeneticAlgorithm"
    algorithm.problem = problem
    algorithm.populationSize = populationSize
    algorithm.crossover = crossover
    algorithm.mutation = mutation
    algorithm.termination = termination

    return algorithm
  end

  function GeneticAlgorithm(
    problem :: BinaryProblem; 
    populationSize = 100, 
    termination = TerminationByEvaluations(25000),
    crossover = SinglePointCrossover(probability = 1.0),
    mutation = BitFlipMutation(probability = 1.0/problem.numberOfBits))
    algorithm = new()
    algorithm.solver = EvolutionaryAlgorithm()
    algorithm.solver.name = "GeneticAlgorithm"
    algorithm.problem = problem
    algorithm.populationSize = populationSize
    algorithm.crossover = crossover
    algorithm.mutation = mutation
    algorithm.termination = termination
    return algorithm
  end

end

function foundSolution(ga::GeneticAlgorithm) 
  return ga.solver.foundSolutions[1]
end

function optimize!(ga::GeneticAlgorithm)
  solver = ga.solver
  problem = ga.problem

  populationSize = ga.populationSize
  offspringPopulationSize = ga.populationSize

  solver.solutionsCreation = DefaultSolutionsCreation(problem, populationSize)

  solver.evaluation = SequentialEvaluation(problem)

  solver.termination = ga.termination
  solver.variation = CrossoverAndMutationVariation(offspringPopulationSize, ga.crossover, ga.mutation)

  solver.replacement = MuPlusLambdaReplacement(IthObjectiveComparator(1))

  solver.selection = BinaryTournamentSelection(solver.variation.matingPoolSize, IthObjectiveComparator(1))

  return evolutionaryAlgorithm(solver)
end

function name(ga::GeneticAlgorithm)
  return name(ga.solver)
end

function status(ga::GeneticAlgorithm)
  return status(ga.solver)
end

function computingTime(ga::GeneticAlgorithm)
  return status(ga)["COMPUTING_TIME"]
end

function observable(ga::GeneticAlgorithm)
  return observable(ga.solver)
end
