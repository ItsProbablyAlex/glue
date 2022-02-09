trigger TriggerGlueAccount on Account (before update) {
	Glue glue = new Glue(
    	Trigger.new,
        Trigger.oldMap,
        new GivenAccount(),
        new ThenAccount()
    );
    
   	glue.given('emailChanged')
        .then('updateName');
}
