abstract type Observer end

struct Observable
  name::String
  observers::Set
  hasChanged::Bool
  function Observable(name)
    new(name, Set(), false)
  end
end

function register!(observable::Observable, observer::O) where {O <: Observer}
  push!(observable.observers, observer)
end

function observers(observable::Observable)
  return observable.observers
end

function notify(observable::Observable, data::Dict)
  for observer in observers(observable)
    update(observer, data)
  end
end

struct EvaluationObserver <: Observer
  frequency::Int
end

function update(observer::EvaluationObserver, data::Dict)
  evaluations = data["EVALUATIONS"]
  if mod(evaluations, observer.frequency) == 0
    println("Evaluations: ", evaluations)
  end
end

struct FitnessObserver <: Observer
  frequency::Int
end

function update(observer::FitnessObserver, data::Dict)
  evaluations = data["EVALUATIONS"]
  population = data["POPULATION"]
  if mod(evaluations, observer.frequency) == 0
    sort!(population, lt=((x,y) -> x.objectives[1] < y.objectives[1]))
    fitness = population[1].objectives[1]
    println("Evaluations: ", evaluations, ". Fitness: ", fitness)
  end
end

using Plots

struct FrontPlotObserver <: Observer
  frequency::Int

  function FrontPlotObserver(frequency)
    gr()
    return new(frequency)
  end
end

function update(observer::FrontPlotObserver, data::Dict)

  evaluations = data["EVALUATIONS"]
  population = data["POPULATION"]
  if mod(evaluations, observer.frequency) == 0
    sort!(population, lt=((x,y) -> x.objectives[1] < y.objectives[1]))

    x = [solution.objectives[1] for solution in population];
    y = [solution.objectives[2] for solution in population];

    scatter(x, y,  title = string("Pareto front approximation. Evaluations: ", evaluations), label = "Solutions", show = true)
    xlabel!("First objective")
    ylabel!("Second objective")
    sleep(0.5)
  end
end
