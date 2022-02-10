public class Glue implements Glueable, Glued {
  public enum Step {INIT, GIVEN, THN}
  
  Map<Id, sObject> newMap;
  Map<Id, sObject> oldMap;
  
  public Map<String, GivenStep> givenSteps;
  public Map<String, ThenStep> thenSteps;
  
  Step lastStep;
  List<Id> scope;
  
  List<ParameterType> paramTypes;
  
  public Glue(
  List<sObject> newRecords,
  Map<Id, sObject> oldMap,
  GivenStepDirectory givenSteps,
  ThenStepDirectory thenSteps
  ) {
    this.newMap = new Map<Id, sObject>();
    for (sObject obj : newRecords) newMap.put(obj.Id, obj);
    this.oldMap = oldMap;
    this.givenSteps = givenSteps.getSteps();
    this.thenSteps = thenSteps.getSteps();
    this.scope = newMap.keySet();
    this.lastStep = Step.INIT;
  }
  
  public Glued given(String f) {
    System.debug('Given: ' + f);
    // if the last stage wasn't a given refresh the scope
    if (this.lastStep != Step.GIVEN) {
      scope = this.newMap.keySet();
    }
    // get the filter
    GivenStep assertion = givenSteps.get(f);
    // update the scope
    List<Id> newScope = new List<sObject>();
    for (Id i in this.scope) {
      sObject o = oldMap.get(i); 
      sObject n = newMap.get(i);
      if (assertion.evaluate(o, n)) {
        newScope.add(i)
      }
    }
    this.scope = newScope;
    // update the last step
    this.lastStep = Step.GIVEN;
    // return the glue object
    return this;
  }
  
  public Glued then(String a) {
    System.debug('Then: ' + a);
    // get the action to perform
    ThenStep action = thenSteps.get(a);
    // TODO: action not registered
    // execute over the current scope
    // TODO: execution with args
    for (Id i : scope) {
      sObject o = oldMap.get(i); 
      sObject n = newMap.get(i);
      sObject updated = action.execute(o, n);
      this.newMap.put(i, n);
      
    }
    // update the last step
    this.lastStep = Step.THN;
    return this;
  }
}
