trigger TriggerGlueAccount on Account (before update) {
  // Configure a glue object taking:
  //  - Trigger globals
  //  - Step directory for given steps
  //  - Step directory for then step
  Glue glue = new Glue(
    Trigger.new,
    Trigger.oldMap,
    new GivenAccount(),
    new ThenAccount()
  );
    
  //  Write behaviour driven steps here
  glue.given('PersonEmail has changed')
      .then('Set FirstName To AHHHHH')
}
