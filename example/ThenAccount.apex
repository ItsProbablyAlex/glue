public class ThenAccount implements StepDirectory {
    public Map<String, BaseStep> getSteps() {
        return new Map<String, BaseStep> {
            'Append (string) to (field)' => new AppendString()
        };
    }
    
    class AppendString implements BaseStep {
    	public sObject call(sObject o, sObject n, List<Object> args) {
            String toAppend = (String) args[0];
            String field = (String) args[1];
            System.debug(args);
            n.put(field, n.get(field) + ' ' + toAppend);
            return n;
    	}
  	}
}
