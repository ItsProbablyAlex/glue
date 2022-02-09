public class ThenAccount implements ThenStepDirectory {
    public Map<String, Actionable> getSteps() {
        return new Map<String, Actionable> {
            'updateName' => new ThenUpdateName()
        };
    }
    
    class ThenUpdateName implements Actionable {
        public List<sObject> execute(List<Account> scope) {
            for (Account a : scope) {
                a.FirstName = 'AHHHH';
            }
        	return scope;
        }
    }
}
