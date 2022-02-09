public class Glue implements Glueable, Glued {
    public enum Step {INIT, GIVEN, THN}
        
  	Map<Id, sObject> newMap;
	Map<Id, sObject> oldMap;
  
  	public Map<String, Select.Filter> givenSteps;
  	public Map<String, Actionable> thenSteps;

    Step lastStep;
  	List<sObject> scope;
    
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
    	this.scope = newMap.values();
        this.lastStep = Step.INIT;
  	}
  	public Glued given(String f) {
        System.debug('Given: ' + f);
        // if the last stage wasn't a given refresh the scope
        if (this.lastStep != Step.GIVEN) {
            scope = this.newMap.values();
        }
        // get the filter
        Select.Filter scopeFilter = givenSteps.get(f);
        // update the scope
        this.scope = scopeFilter.filter(scope, oldMap);
        System.debug(this.scope);
        // update the last step
        this.lastStep = Step.GIVEN;
        // return the glue object
        return this;
    }
	public Glued then(String a) {
        System.debug('Then: ' + a);
		System.debug('For Accounts: ' + this.scope);
        // get the action to perform
        Actionable action = thenSteps.get(a);
        // execute over the current scope
        List<sObject> actioned = action.execute(scope);
        // update oldMap with the changed values 
        for (sObject obj : actioned) {
            this.newMap.put(obj.Id, obj);
        }
        // update the last step
        this.lastStep = Step.THN;
        return this;
   	}
}
