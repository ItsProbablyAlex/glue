public class GivenAccount implements GivenStepDirectory {
    Select.Filter PERSON_EMAIL_CHANGED = Select.Field.hasChanged(Account.PersonEmail);
    
	public Map<String, Select.Filter> getSteps() {
        return new Map<String, Select.Filter>{
          'emailChanged' => PERSON_EMAIL_CHANGED  
        };
    }
}
