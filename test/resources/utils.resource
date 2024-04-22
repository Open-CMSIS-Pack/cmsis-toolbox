*** Settings ***
Documentation    A collection of commonly used keywords across multiple test suites
Library          Collections
Library          Process
Library          OperatingSystem
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
    ...                         shell=True       stdout=${CURDIR}/stdout.txt
    Log Many                    StdOut: ${result.stdout}    Return Code: ${result.rc}
    RETURN                      ${result.rc}

Run cbuild
    [Documentation]                Run cbuild with specified arguments
    [Arguments]                    ${input_file}    ${args}=@{EMPTY}
    Append To List                 ${args}    -p    -r    --update-rte
    Log Many                       cbuild    ${input_file}    @{args}
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

# Checkout GitHub Repository
#     [Documentation]                 Checkout github repository
#     [Arguments]                     ${github_repo_url}    ${dest_path}
#     ${result}=    Run Process       git    clone          ${github_repo_url}    ${dest_path}
#     Log                             ${result.stdout}
#     Log                             ${result.stderr}
#     Should Be Equal As Integers     ${result.rc}          ${0}

Run Project With cbuild2cmake
    [Arguments]     ${input_file}    ${args}=@{EMPTY}
    ${ex_args}=     Append Additional Arguments     ${args}    --cbuild2cmake
    ${result}=      Run cbuild        ${input_file}      ${ex_args}
    RETURN          ${result}

Run Project with cbuildgen
    [Arguments]    ${input_file}      ${example_name}    ${args}=@{EMPTY}
    ${ex_args}=     Append Additional Arguments     ${args}    --output    ${TEST_DATA_DIR}${/}${example_name}${/}out_dir
    ${result}=      Run cbuild        ${input_file}      ${ex_args}
    RETURN          ${result}

Validate Build Status
    [Arguments]         ${rc_cbuildgen}        ${rc_cbuild2cmake}    ${rc_expected}
    Should Be Equal     ${rc_cbuildgen}        ${rc_expected}        msg=Unexpected status returned by cbuildgen execution
    Should Be Equal     ${rc_cbuild2cmake}     ${rc_expected}        msg=Unexpected status returned by cbuild2cmake execution
    ${status_match}=    Evaluate    ${rc_cbuildgen} == ${rc_cbuild2cmake} and ${rc_cbuildgen} == ${rc_expected}
    RETURN              ${status_match}

Append Additional Arguments
    [Arguments]                  ${list}    @{values}
    ${args}=    Combine Lists    ${list}    ${values}
    RETURN                       ${args}
