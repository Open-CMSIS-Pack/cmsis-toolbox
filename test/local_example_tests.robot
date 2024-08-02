*** Settings ***
Documentation           Tests to compile & execute local csolution examples
Suite Setup             Copy Test Data
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
${build-set}                build-set
${executes}                 executes
${include-define}           include-define
${language-scope}           language-scope
${library-rtos}             library-rtos
${linker-pre-processing}    linker-pre-processing
${pre-include}              pre-include
${whitespace}               whitespace
${trustzone}                trustzone
${Hello}                    Hello

*** Test Cases ***
# <Name of the Test>
#    <Path to the input *.csolution.yml file>       <Expected cbuildgen build status>    <Expected cbuild2cmake build status>

Validate build-asm Example
    ${TEST_DATA_DIR}${/}${build-asm}${/}solution.csolution.yml                 ${Fail}    ${Pass}

Validate build-c Example
    ${TEST_DATA_DIR}${/}${build-c}${/}solution.csolution.yml                   ${Pass}    ${Pass}

Validate build-cpp Example
    ${TEST_DATA_DIR}${/}${build-cpp}${/}solution.csolution.yml                 ${Pass}    ${Pass}

Validate build-set Example
    ${TEST_DATA_DIR}${/}${build-set}${/}solution.csolution.yml                 ${Pass}    ${Pass}

Validate executes Example
    ${TEST_DATA_DIR}${/}${executes}${/}solution.csolution.yml                  ${Pass}    ${Pass}

Validate include-define Example
    ${TEST_DATA_DIR}${/}${include-define}${/}solution.csolution.yml            ${Fail}    ${Pass}

Validate language-scope Example
    ${TEST_DATA_DIR}${/}${language-scope}${/}solution.csolution.yml            ${Fail}    ${Pass}

Validate library-rtos Example
    ${TEST_DATA_DIR}${/}${library-rtos}${/}solution.csolution.yml              ${Pass}    ${Pass}

Validate linker-pre-processing Example
    ${TEST_DATA_DIR}${/}${linker-pre-processing}${/}solution.csolution.yml     ${Pass}    ${Pass}

Validate pre-include Example
    ${TEST_DATA_DIR}${/}${pre-include}${/}solution.csolution.yml               ${Pass}    ${Pass}

Validate whitespace Example
    ${TEST_DATA_DIR}${/}${whitespace}${/}solution.csolution.yml                ${Pass}    ${Pass}

Validate trustzone Example
     ${TEST_DATA_DIR}${/}${trustzone}${/}solution.csolution.yml                ${Pass}    ${Pass}

*** Keywords ***
Build Local CSolution Example
    [Arguments]                              ${input_file}      ${cbuildgen_expect}    ${cbuild2cmake_expect}    ${args}=@{EMPTY}
    ${result}=    Build CSolution Example    ${input_file}      ${cbuildgen_expect}    ${cbuild2cmake_expect}    ${args}
    Should Be True                           ${result}
