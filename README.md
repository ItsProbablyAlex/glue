# Glue [WIP]

## Build Salesforce Apex Triggers Using A Behaviour Driven Syntax
Inspired by gherkin syntax - define behaviour for Salesforce triggers using natural language.

See the example folder for a demo...

## TODOs:
- Parameter Types for step definitions:
    I want to be able to write a step like:
        "Account.PersonEmail is changed"
    With the underlying step definition:
        "{field} is changed"
    Which dynamically shifts behaviour based on the provided field
