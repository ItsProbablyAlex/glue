public virtual class ParameterType {
    public String identifier;
    public String pattern;

    public ParameterType(String identifier, String pattern) {
        this.identifier = identifier;
        this.pattern = pattern;
    }
    public virtual Object transform(String v) {
    	return v;
    }
}
