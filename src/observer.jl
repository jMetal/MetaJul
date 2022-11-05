
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

"""
ejemploObservable = Observable("Ejemplo de observable")
evalObserver = EvaluationObserver(5)

register!(ejemploObservable, evalObserver)

println("Observable: ", ejemploObservable)
println("Observador: ", evalObserver)

for i in 1:20
  data = Dict("EVALUATIONS" => i)
  #update(evalObserver, data)
  notify(ejemploObservable, data)
end
"""

"""
private Integer frequency ;

public void update(Observable<Map<String, Object>> observable, Map<String, Object> data) {
  Integer evaluations = (Integer)data.get("EVALUATIONS") ;

  if (evaluations!=null) {
    if (evaluations % frequency == 0) {
      System.out.println("Evaluations: " + evaluations);
    }
  } else {
    JMetalLogger.logger.warning(getClass().getName()+
        ": The algorithm has not registered yet any info related to the EVALUATIONS key");
  }
}

"""
#   public void update(Observable<Map<String, Object>> observable, Map<String, Object> data) {


"""
public interface Observable<D> {
	void register(Observer<D> observer) ;
	void unregister(Observer<D> observer) ;

	void notifyObservers(D data);
	int numberOfRegisteredObservers() ;
	void setChanged() ;
	boolean hasChanged() ;
	void clearChanged() ;

	Collection<Observer<D>> getObservers() ;
}

public interface Observer<D> {
	void update(Observable<D> observable, D data) ;
}

public interface ObservableEntity<T> {
  Observable<T> getObservable();
}

public class DefaultObservable<D> implements Observable<D> {
  private Set<Observer<D>> observers;
  private boolean dataHasChanged;
  private String name;

  public DefaultObservable(String name) {
    observers = new HashSet<>();
    dataHasChanged = false;
    this.name = name;
  }

  @Override
  public synchronized void register(Observer<D> observer) {
    observers.add(observer);
    JMetalLogger.logger.info("DefaultObservable " + name + ": " + observer + " registered");
  }

  @Override
  public synchronized void unregister(Observer<D> observer) {
    observers.remove(observer);
  }

  @Override
  public synchronized void notifyObservers(D data) {
    if (dataHasChanged) {
      observers.forEach(observer -> observer.update(this, data));
    }
    clearChanged();
  }

  @Override
  public synchronized int numberOfRegisteredObservers() {
    return observers.size();
  }

  @Override
  public synchronized void setChanged() {
    dataHasChanged = true;
  }

  @Override
  public synchronized boolean hasChanged() {
    return dataHasChanged;
  }

  @Override
  public synchronized void clearChanged() {
    dataHasChanged = false;
  }

  public synchronized String getName() {
    return name;
  }

  public synchronized void setName(String name) {
    this.name = name;
  }

  @Override
  public Collection<Observer<D>> getObservers() {
    return observers;
  }
}

"""