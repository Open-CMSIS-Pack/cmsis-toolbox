*** Settings ***
Documentation           Tests to execute solution examples
Resource                ./global.robot
Resource                ${RESOURCES}/utils.resource
Library                 Collections
Library                 String
Library                 ../lib/elf_compare.py 
# Variables               TestExamples.yml
Suite Setup             Global Setup
Suite Teardown          Global Teardown
Test Template           Run CSolution Project

*** Variables ***
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
Validate build-asm Example
    ${TEST_DATA_DIR}${/}${build-asm}${/}solution.csolution.yml    ${0}    ${build-asm}

Validate build-c Example
    ${TEST_DATA_DIR}${/}${build-c}${/}solution.csolution.yml      ${0}    ${build-c}

Validate build-cpp Example
    ${TEST_DATA_DIR}${/}${build-cpp}${/}solution.csolution.yml    ${0}    ${build-cpp}

Validate include-define Example
    ${TEST_DATA_DIR}${/}${include-define}${/}solution.csolution.yml    ${0}    ${include-define}

Validate language-scope Example
    ${TEST_DATA_DIR}${/}${language-scope}${/}solution.csolution.yml    ${0}    ${language-scope}

Validate linker-pre-processing Example
    ${TEST_DATA_DIR}${/}${linker-pre-processing}${/}solution.csolution.yml    ${0}    ${linker-pre-processing}

Validate pre-include Example
    ${TEST_DATA_DIR}${/}${pre-include}${/}solution.csolution.yml    ${0}    ${pre-include}

Validate whitespace Example
    ${TEST_DATA_DIR}${/}${whitespace}${/}solution.csolution.yml    ${0}    ${whitespace}

Validate trustzone Example
     ${TEST_DATA_DIR}${/}${trustzone}${/}solution.csolution.yml    ${0}    ${trustzone}

*** Keywords ***
Run Csolution Project
    [Arguments]               ${input_file}      ${expect}    ${example_name}    ${args}=@{EMPTY}
    ${rc_cbuildgen}=          Run Project With cbuildgen       ${input_file}    ${args}
    ${rc_cbuild2cmake}=       Run Project with cbuild2cmake    ${input_file}    ${args}
    ${build_status}=          Validate Build Status     ${rc_cbuildgen}    ${rc_cbuild2cmake}    ${expect}
    Run Keyword If            ${build_status} == ${True}    Compare Elf Information   ${input_file}    ${TEST_DATA_DIR}${/}${example_name}${/}out_dir/out     ${TEST_DATA_DIR}${/}${example_name}${/}out






















# Build Examples with cbuildgen
#     FOR    ${test}    IN    @{Test_Examples}
#     ${ret_code}=    Run cbuild    ${TEST_DATA_DIR}${/}${test["example"]}${/}${test["target"]}.csolution.yml    ${test["args"]}
#     Should Be Equal      ${ret_code}    ${test.expect}
#     END

# Build Examples with cbuild2cmake
#     FOR    ${test}    IN    @{Test_Examples}
#     Append To List          ${test["args"]}    --cbuild2cmake
#     ${ret_code}=    Run cbuild    ${TEST_DATA_DIR}${/}${test["example"]}${/}${test["target"]}.csolution.yml    ${test["args"]}
#     Should Be Equal      ${ret_code}    ${test.expect}
#     END




# *** Variables ***
# @{build_examples}       build-asm    build-c     build-cpp    include-define    linker-pre-processing    pre-include
# @{build_files}          solution     solution    solution     solution          solution                 solution
# @{expected_ret_code}    ${0}         ${0}        ${0}         ${-1}             ${0}                     ${0}



# Build Examples with cbuildgen
#     FOR    ${example}    IN    @{build_examples}
#     ${index}=            Get Index From List    ${build_examples}    ${example}
#     ${ret_code}=         Run cbuild    ${TEST_DATA_DIR}${/}${example}${/}${build_files}[${index}].csolution.yml
#     Should Be Equal      ${ret_code}    ${expected_ret_code}[${index}]
#     END

# Build Examples with cbuild2cmake
#     FOR    ${example}    IN    @{build_examples}
#     ${index}=            Get Index From List    ${build_examples}    ${example}
#     Run cbuild           ${TEST_DATA_DIR}${/}${example}${/}${build_files}[${index}].csolution.yml    --cbuild2cmake
#     END


# Run build-asm                ${TEST_DATA_DIR}${/}build-asm${/}solution.csolution.yml
# Run build-c                  ${TEST_DATA_DIR}/build-c${/}solution.csolution.yml
# Run build-cpp                ${TEST_DATA_DIR}/build-cpp${/}solution.csolution.yml
# # Run include-define         ${TEST_DATA_DIR}/include-define${/}solution.csolution.yml
# Run linker-pre-processing    ${TEST_DATA_DIR}/linker-pre-processing${/}solution.csolution.yml
# Run pre-include              ${TEST_DATA_DIR}/pre-include${/}solution.csolution.yml


# Run build-asm cbuild2cmake                ${TEST_DATA_DIR}${/}build-asm${/}solution.csolution.yml             --cbuild2cmake
# Run build-c cbuild2cmake                  ${TEST_DATA_DIR}/build-c${/}solution.csolution.yml                  --cbuild2cmake
# Run build-cpp cbuild2cmake                ${TEST_DATA_DIR}/build-cpp${/}solution.csolution.yml                --cbuild2cmake
# Run linker-pre-processing cbuild2cmake    ${TEST_DATA_DIR}/linker-pre-processing${/}solution.csolution.yml    --cbuild2cmake
# Run pre-include cbuild2cmake              ${TEST_DATA_DIR}/pre-include${/}solution.csolution.yml              --cbuild2cmake

