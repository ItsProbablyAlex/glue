public class Glue implements Glueable, Glued {
    public static final Pattern PARAM_PATTERN = Pattern.compile('(\\([a-zA-Z0-9]+\\))');

    public enum Step {INIT, GIVEN, THN}
  
    Map<Id, sObject> newMap;
    Map<Id, sObject> oldMap;
  
    public Map<Pattern, StepDefinition> givenSteps;
    public Map<Pattern, StepDefinition> thenSteps;
  
    Step lastStep;
    Set<Id> scope;
  
    Map<String, ParameterType> paramTypes;
  
  	public Glue(
        List<sObject> newMap,
        Map<Id, sObject> oldMap,
        StepDirectory givenSteps,
        StepDirectory thenSteps,
        List<ParameterType> paramTypes
  	) {
		// Create a map of new objects
    	this.newMap = new Map<Id, sObject>();
    	for (sObject obj : newMap) this.newMap.put(obj.Id, obj);
        // Get the map of old objects
        this.oldMap = oldMap;
		// Index param types
		this.paramTypes = new Map<String, ParameterType>();
		for (ParameterType t : paramTypes) this.paramTypes.put(t.identifier, t);
        // Parse step definitions
        this.givenSteps = parseStepDirectory(givenSteps, this.paramTypes);
        this.thenSteps = parseStepDirectory(thenSteps, this.paramTypes);
        // Build Scope
        this.scope = this.newMap.keySet();
        // Set as init
        this.lastStep = Step.INIT;
    }
	
    public static StepDefinition parseStep(String p, BaseStep step, Map<String, ParameterType> types) {
        // Setup variables
        String rePattern = p;
        List<ParameterType> paramTransformers = new List<ParameterType>();
        // Extract variables
        Matcher m = PARAM_PATTERN.matcher(p);
		Integer numVarGroups = m.groupCount();
        while (m.find()) {
            // Get the type of the param
            String grp = m.group();
            String typeId = grp.substring(1, grp.length() - 1);
            ParameterType t = types.get(typeId);
			// Replace in pattern
            rePattern = rePattern.replaceFirst(grp, t.pattern);
            paramTransformers.add(t);
        }
        Pattern compiledPattern = Pattern.compile(rePattern);
        // Get the base step name
        return new StepDefinition(step, compiledPattern, paramTransformers);
    }
    
    public static Map<Pattern, StepDefinition> parseStepDirectory(StepDirectory d, Map<String, ParameterType> types) {
        // Get Steps
		Map<String, BaseStep> steps = d.getSteps();
        // Replace variables
    	Map<Pattern, StepDefinition> reSteps = new Map<Pattern, StepDefinition>();
    	for (String s : steps.keySet()) {
			StepDefinition p = parseStep(s, steps.get(s), types);
            reSteps.put(p.pattern, p);
    	}
        // Return steps
		return reSteps;
    }
	
  	public Glue given(String f) {
        System.debug('Given: ' + f);
        // if the last stage wasn't a given refresh the scope
        if (this.lastStep != Step.GIVEN) {
        	scope = this.newMap.keySet();
        }
        // get the matching step
        StepMatch matched;
        try {
            matched = getMatchingStep(this.givenSteps.keySet(), f);
        } catch(GluePatternException e) {
            for(Id id : scope) this.newMap.get(id).addError(e);
            throw e;
        }
        StepDefinition assertion = this.givenSteps.get(matched.p);
        // call the step definition and update the scope
        Set<Id> newScope = new Set<Id>();
        for (Id i : this.scope) {
        	sObject o = oldMap.get(i); 
          	sObject n = newMap.get(i);
            List<Object> params = assertion.transformParams(matched.a);
          	if ((Boolean) assertion.step.call(o, n, params)) {
            	newScope.add(i);
          	}
        }
        this.scope = newScope;
        // update the last step
        this.lastStep = Step.GIVEN;
        // return the glue object
        return this;
  	}
  
  	public Glue then(String a) {
        System.debug('Then: ' + a);
        // Get the action to perform
        StepMatch matched;
        try {
            matched = getMatchingStep(this.thenSteps.keySet(), a);
        } catch(GluePatternException e) {
            for(Id id : scope) this.newMap.get(id).addError(e);
            throw e;
        }
        StepDefinition action = this.thenSteps.get(matched.p);
        // Execute over the current scope
        for (Id i : this.scope) {
          sObject o = oldMap.get(i); 
          sObject n = newMap.get(i);
          List<Object> params = action.transformParams(matched.a);
          sObject updated = (sObject) action.step.call(o, n, params);
          this.newMap.put(i, n);
          
        }
    	// Update the last step
    	this.lastStep = Step.THN;
    	return this;
    }
    
    public static StepMatch isMatch(Pattern stepPattern, String stepImplementation) {
        // Match against pattern implementation
        Matcher m = stepPattern.matcher(stepImplementation);
        Boolean isMatch = m.matches();
        // Create response object
        StepMatch b = new StepMatch(stepPattern, isMatch);
        if (isMatch) {
            // Append variable values 
            Integer numVarGroups = m.groupCount();		
            for (Integer i=1; i<numVarGroups+1; i++) {
                b.withA(m.group(i));
            }
        }
        return b;
    }
    
    public static StepMatch getMatchingStep(Set<Pattern> stepPatterns, String stepImplementation) {
		// Initialise step object
        StepMatch match = null;
        for (Pattern stepPattern : stepPatterns) {
            StepMatch b = isMatch(stepPattern, stepImplementation);
            if (b.f) {
                match = b;
                break;
            }
        }
        // Raise an error if no matches found
        if (match == null) {
            throw new GluePatternException('No matching step definition for : "' + stepImplementation + '"');
        }
        return match;
    }
    
    class StepDefinition {
        BaseStep step;
        Pattern pattern;
        List<ParameterType> paramTransformers;
        
        public StepDefinition(BaseStep step, Pattern pattern, List<ParameterType> paramTransformers) {
            this.step = step;
            this.pattern = pattern;
            this.paramTransformers = paramTransformers;
        }
        
        public List<Object> transformParams(List<String> params) {
            List<Object> out = new List<Object>();
            for(Integer i = 0; i < params.size(); i++){
			  out.add(this.paramTransformers[i].transform(params[i]));
			}
            System.debug('Transformed params: ' + out);
            return out;
        }
    }
    
    class StepMatch {
        Pattern p;
        List<String> a;
        Boolean f;
        
        public StepMatch(Pattern p, Boolean f) {
            this.p = p;
            this.f = f;
            this.a = new List<String>();
        }
        
        public void withA(String o) {
            a.add(o);
        }
    }
}
