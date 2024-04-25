*** Settings ***
Documentation    A collection of commonly used keywords across multiple test suites
Library          Collections
Library          Process
Library          OperatingSystem
Library          ..${/}lib${/}utils.py
Resource         global.resource


*** Keywords ***
Global Setup
    ${parent_dir}=                  Join Path           ${CURDIR}        ..
    ${src_dir}=                     Join Path           ${parent_dir}    ${Data}
    ${dest_dir}=                    Get Test Data Directory
    Set Global Variable             ${TEST_DATA_DIR}    ${dest_dir}
    Copy Directory                  ${src_dir}          ${dest_dir}

Global Teardown
    Remove Directory with Content    ${TEST_DATA_DIR}

Get Test Data Directory
    [Documentation]      Retrieve the directory path for test input data
    ${parent_dir}=       Join Path           ${CURDIR}        ..
    ${test_data_dir}=    Join Path           ${parent_dir}    ${Build}
    RETURN               ${test_data_dir}

Run Program
    [Documentation]             Run specified executable with arguments
    [Arguments]                 ${exe_path}      ${input_File}    @{args}
    ${result}    Run Process    ${exe_path}      ${input_File}    @{args}
    ...    shell=True    stdout=${CURDIR}/stdout.txt
    ${ret_code}=                Set Variable If    ${result.rc} == ${0}    ${result.rc}    ${1}
    Log Many                    StdOut: ${result.stdout}
    RETURN                      ${ret_code}

Run cbuild
    [Documentation]                Run cbuild with specified arguments
    [Arguments]                    ${input_file}    ${args}=@{EMPTY}
    Append To List                 ${args}    -p    -r    --update-rte
    ${ret_code}=    Run Program    cbuild    ${input_file}    @{args}
    RETURN                         ${ret_code}

Change Directory Permissions
    [Documentation]                 Change directory permissions
    [Arguments]                     ${target_dir}
    ${result}                       Run Process    chmod    -R    755    ${target_dir}
    Should Be Equal                 ${result.rc}    ${0}

Remove Directory with Content
    [Documentation]                 Remove directory and its content from target directory
    [Arguments]                     ${target_dir}
    Change Directory Permissions    ${target_dir}
    Remove Directory                ${target_dir}      recursive=${True}
    Wait Until Removed              ${target_dir}      timeout=5 seconds

Checkout GitHub Repository
    [Documentation]                 Checkout github repository
    [Arguments]                     ${github_repo_url}    ${dest_path}
    ${result}=    Run Process       git    clone          ${github_repo_url}    ${dest_path}
    Log                             ${result.stdout}
    Log                             ${result.stderr}
    Should Be Equal As Integers     ${result.rc}          ${0}

Run Project with cbuildgen
    [Documentation]     Run the csolution project with cbuildgen
    [Arguments]         ${input_file}    ${expect}        ${args}=@{EMPTY}
    ${parent_path}=     Get Parent Directory Path         ${input_file}
    ${ex_args}=         Append Additional Arguments       ${args}    --output    ${parent_path}${/}${Out_Dir}
    ${ret_code}=        Run cbuild       ${input_file}    ${ex_args}
    Should Be Equal     ${ret_code}      ${expect}        msg=Unexpected status returned by cbuildgen execution

Run Project With cbuild2cmake
    [Documentation]     Run the csolution project with cbuild2cmake
    [Arguments]         ${input_file}     ${expect}        ${args}=@{EMPTY}
    ${ex_args}=         Append Additional Arguments        ${args}    --cbuild2cmake
    ${ret_code}=        Run cbuild        ${input_file}    ${ex_args}
    Should Be Equal     ${ret_code}       ${expect}        msg=Unexpected status returned by cbuild2cmake execution

Append Additional Arguments
    [Documentation]     Append values to the list
    [Arguments]                  ${list}    @{values}
    ${args}=    Combine Lists    ${list}    ${values}
    RETURN                       ${args}
