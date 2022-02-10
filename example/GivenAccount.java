// Step directory of GIVEN steps for the account object
public class GivenAccount implements GivenStepDirectory {

  // Register your steps here with natural language expressions
  public Map<String, Select.Filter> getSteps() {
    return new Map<String, Select.Filter>{
      'PersonEmail has changed' => PersonEmailChanged  
    };
  }

  // Define steps as inner classes implementing the GivenStep interface
  class PersonEmailChanged implements GivenStep {
    public Boolean evaluate(Account o, Account n) {
      return o.get('PersonEmail') == n.get('PersonEmail');
    }
  }
}
