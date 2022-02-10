// Defines methods required for a given step
// evaluates a single sObject of the given type
public interface GivenStep {
  Boolean evaluate(sObject o, sObject n);
}
