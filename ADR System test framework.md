# System test framework

The objective of this document is to conduct a thorough evaluation of various system test frameworks while taking into account our specific use cases. Our aim is to gain insight into the advantages and disadvantages of the frameworks under consideration, thereby facilitating a fair comparison.

## Contributors

- Sourabh Mehta

## Reviewer

- Daniel Brondani
- Jonatan Antony
- Samuel Pelegrinello Caipers
- Evgueni Driouk
- Thorsten de Buhr

## Context

The end-to-end (E2E) tests developed using decided framework aim to validate the fully integrated applications, assessing the interactions among different utilities within the entire system. The overarching goal is to simulate user interactions and ensure that the desired build output is achieved through comprehensive system testing.

## Basic expectation from framework

- Access to system env variables
- Flexibility to run EXEs, capture return code, stdout, stderr
- Golden file comparison
- Generates HTML report

## Comparison

| Sr. No |  key points  |GoogleTest | PyTest | RobotTest |
| :----- |:-- |:--------- | :----- | :-------- |
|1|Language Support|C++|python|keyword/macro based (backed by python)|
|2|Debug|yes|yes|debug with prints or logs|
|3|Dependencies|external dep (need to maintain as submodule in repo)| external dep need to be installed|external dep need to be installed|
|4|HTML Report|Generates XML, 3rd party lib is needed to generate HTML|HTML reports with pytest-html plugin|Inbuilt [HTML report](https://robotframework.org/RobotDemo/report.html) generation|
|5|Ease of use|yes|yes|yes (Needs learning)|
|6|Flexibility and Customization|yes|yes|yes|
|7|Integration with CI/CD|yes|yes|yes|
|8|Feedback Mechanisms & diagnosis|easy to diagnose|easy to diagnose|use [debug logs](https://robotframework.org/RobotDemo/log.html) for diagnosis|

## Considerations

- cbuildgen has toochain related tests (AC6, GCC, IAR) 
  - Are we running all toolchains tests on cmsis-toolbox?
- cpackget test should be migrated

## Design Decision

It was determined that the `robot test` would be the optimal choice. This option requires no language-specific learning and offers a more user-friendly reporting mechanism. Additionally, the robot library boasts extensive support and numerous prebuilt keywords.
