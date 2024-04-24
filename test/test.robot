*** Settings ***
Documentation           Tests to verify the csolution examples can be compiled and executed
Suite Setup             Global Setup
Suite Teardown          Global Teardown
Resource                resources${/}global.resource
Resource                resources${/}utils.resource
Library                 String
Library                 Collections
Library                 lib${/}elf_compare.py 
Test Template           Run CSolution Project

*** Variables ***
# The directory name of the example to be built
${build-asm}                build-asm
${build-c}                  build-c
${build-cpp}                build-cpp
${include-define}           include-define
${language-scope}           language-scope
${linker-pre-processing}    linker-pre-processing
${pre-include}              pre-include
${whitespace}               whitespace
${trustzone}                trustzone

*** Test Cases ***
# <Name of the Test>
#    <Path to the input *.csolution.yml file>    <Expected build status>    <Example root directory name>

Validate build-asm Example
    ${TEST_DATA_DIR}${/}${build-asm}${/}solution.csolution.yml    ${build-asm}    ${0}

Validate build-c Example
    ${TEST_DATA_DIR}${/}${build-c}${/}solution.csolution.yml      ${build-c}    ${0}

Validate build-cpp Example
    ${TEST_DATA_DIR}${/}${build-cpp}${/}solution.csolution.yml    ${build-cpp}    ${0}

Validate include-define Example
    ${TEST_DATA_DIR}${/}${include-define}${/}solution.csolution.yml    ${include-define}    ${0}

Validate language-scope Example
    ${TEST_DATA_DIR}${/}${language-scope}${/}solution.csolution.yml    ${language-scope}    ${0}

Validate linker-pre-processing Example
    ${TEST_DATA_DIR}${/}${linker-pre-processing}${/}solution.csolution.yml    ${linker-pre-processing}    ${0}

Validate pre-include Example
    ${TEST_DATA_DIR}${/}${pre-include}${/}solution.csolution.yml    ${pre-include}    ${0}

Validate whitespace Example
    ${TEST_DATA_DIR}${/}${whitespace}${/}solution.csolution.yml    ${whitespace}    ${0}

Validate trustzone Example
     ${TEST_DATA_DIR}${/}${trustzone}${/}solution.csolution.yml    ${trustzone}    ${0}

*** Keywords ***
Run Csolution Project
    [Arguments]               ${input_file}      ${example_name}    ${expect}    ${args}=@{EMPTY}
    ${rc_cbuildgen}=          Run Project With cbuildgen       ${input_file}    ${example_name}    ${expect}    ${args}
    ${rc_cbuild2cmake}=       Run Project with cbuild2cmake    ${input_file}    ${example_name}    ${expect}    ${args}
    ${result}=    Run Keyword If    ${rc_cbuild2cmake} == ${expect}
    ...    Run Keyword And Return
    ...    Compare Elf Information   ${input_file}
    ...    ${TEST_DATA_DIR}${/}${example_name}${/}out_dir/out
    ...    ${TEST_DATA_DIR}${/}${example_name}${/}out
    Should Be True    ${result}
