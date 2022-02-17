trigger TriggerAccount on Account (before update) {
  	// Configure a glue object taking:
 	//  - Before state
 	//  - After state
  	//  - Step directory for given steps
  	//  - Step directory for then step
  	//  - Additional parameter types
  	Glue glue = new Glue(
    	Trigger.new,
    	Trigger.oldMap,
    	new GivenAccount(),
    	new ThenAccount(),
        ExampleParameterTypes.GLOBAL_TYPES
  	);
    
  	// Write behaviour driven steps here
  	glue.given('Phone has changed')
    	.then('Append "(unverified)" to Phone');
}
