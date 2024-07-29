*** Settings ***
Documentation           Tests to compile & execute local csolution examples
Suite Setup             Global Setup
Suite Teardown          Global Teardown
Resource                resources${/}global.resource
Resource                resources${/}utils.resource
Resource                resources${/}exec.resource
Library                 String
Library                 Collections
Library                 lib${/}utils.py
Library                 lib${/}elf_compare.py
Test Template           Build Local CSolution Example

*** Variables ***
# The directory name of the examples to be built
${build-asm}                build-asm
${build-c}                  build-c
${build-cpp}                build-cpp
${include-define}           include-define
${language-scope}           language-scope
${linker-pre-processing}    linker-pre-processing
${pre-include}              pre-include
${whitespace}               whitespace
${trustzone}                trustzone
${Hello}                    Hello

*** Test Cases ***
# <Name of the Test>
#    <Path to the input *.csolution.yml file>    <Expected build status>

Validate build-asm Example
    ${TEST_DATA_DIR}${/}${build-asm}${/}solution.csolution.yml    ${Pass}

Validate build-c Example
    ${TEST_DATA_DIR}${/}${build-c}${/}solution.csolution.yml    ${Pass}

Validate build-cpp Example
    ${TEST_DATA_DIR}${/}${build-cpp}${/}solution.csolution.yml    ${Pass}

Validate include-define Example
    ${TEST_DATA_DIR}${/}${include-define}${/}solution.csolution.yml    ${Pass}

Validate language-scope Example
    ${TEST_DATA_DIR}${/}${language-scope}${/}solution.csolution.yml    ${Pass}

Validate linker-pre-processing Example
    ${TEST_DATA_DIR}${/}${linker-pre-processing}${/}solution.csolution.yml    ${Pass}

Validate pre-include Example
    ${TEST_DATA_DIR}${/}${pre-include}${/}solution.csolution.yml    ${Pass}

Validate whitespace Example
    ${TEST_DATA_DIR}${/}${whitespace}${/}solution.csolution.yml    ${Pass}

Validate trustzone Example
     ${TEST_DATA_DIR}${/}${trustzone}${/}solution.csolution.yml    ${Pass}

*** Keywords ***
Build Local CSolution Example
    [Arguments]                              ${input_file}      ${expect}    ${args}=@{EMPTY}
    ${result}=    Build CSolution Example    ${input_file}      ${expect}    ${args}
    Should Be True                           ${result}
