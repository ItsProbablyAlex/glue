// Step directory of THEN steps for the account object
public class ThenAccount implements ThenStepDirectory {

  // Register your steps here with natural language expressions
  public Map<String, ThenStep> getSteps() {
    return new Map<String, ThenStep> {
      'Set FirstName To AHHHHH' => new UpdateName()
    };
    }

  // Define steps as inner classes implementing the ThenStep interface
  class UpdateName implements ThenStep {
    public List<sObject> execute(Account a) {
      a.FirstName = 'AHHHHH';
      return a;
    }
  }
}
