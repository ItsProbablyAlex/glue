// Define a set of Given Steps
// It is reccomended you define a set of common steps and a set of object specific steps
public class GivenAccount implements StepDirectory {
    public Map<String, BaseStep> getSteps() {
        return new Map<String, BaseStep> {
            '(field) has changed' => new PersonEmailChanged()
        };
    }
    
    class PersonEmailChanged implements BaseStep {
    	public Boolean call(sObject o, sObject n, List<Object> args) {
            String field = (String) args[0];
      		return o.get(field) != n.get(field);
    	}
  	}
}
