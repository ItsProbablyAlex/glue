public class ThenAccount implements ThenStepDirectory {
    public Map<String, ThenStep> getSteps() {
        return new Map<String, ThenStep> {
            'Set FirstName To AHHHHH' => new UpdateName()
        };
    }
    
    class UpdateName implements ThenStep {
        public List<sObject> execute(Account a) {
            a.FirstName = 'AHHHHH';
        	return a;
        }
    }
}
