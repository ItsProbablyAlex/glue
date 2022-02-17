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
