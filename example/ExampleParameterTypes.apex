public class ExampleParameterTypes {
    public static List<ParameterType> GLOBAL_TYPES = new List<ParameterType> {
        new ParameterType('field', '[a-zA-Z0-9_]+'),
        new StringParameter('string', '".+"')
    };

    class StringParameter extends ParameterType {
        public StringParameter(String identifier, String pattern) {
            super(identifier, pattern);
        }
        public override Object transform(String s) {
            System.debug(s.substring(1, s.length() - 1));
           	return s.substring(1, s.length() - 1);
        }
    }
}
