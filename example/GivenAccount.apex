public class GivenAccount implements GivenStepDirectory {
  Select.Filter PERSON_EMAIL_CHANGED = Select.Field.hasChanged(Account.PersonEmail);
    
	public Map<String, Select.Filter> getSteps() {
        return new Map<String, Select.Filter>{
          'PersonEmail has changed' => PersonEmailChanged  
        };
  }

  class PersonEmailChanged implements GivenStep {
    public Boolean evaluate(Account o, Account n) {
        return o.get('PersonEmail') == n.get('PersonEmail');
    }
  }
}
