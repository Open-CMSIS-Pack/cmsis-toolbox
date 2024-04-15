*** Settings ***
Documentation    A resource file with reusable keywords
Library          Process
Library          OperatingSystem


*** Keywords ***
Get Test Data directory
    ${parent_dir}=         Join Path           ${CURDIR}        ..
    ${test_data_dir}=      Join Path           ${parent_dir}    run
    Return From Keyword    ${test_data_dir}

Run Program
    [Documentation]             Run specified executable with arguments
    [Arguments]                 ${exe_path}      ${input_File}    @{args}    ${expected_ret_code}=0
    ${result}    Run Process    ${exe_path}      ${input_File}    @{args}    shell=True    stdout=${CURDIR}/stdout.txt	 stderr=STDOUT
    Log Many                    StdOut: ${result.stdout}    Return Code: ${result.rc}    StdErr: ${result.stderr}
    Should Be Equal             '${result.rc}'   '${expected_ret_code}'

Run cbuild
    [Documentation]    Run cbuild with specified arguments
    [Arguments]        ${input_file}    @{args}
    Run Program        cbuild           ${input_file}    @{args}    -p    -r    --update-rte

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

Global Setup
    ${parent_dir}=                  Join Path           ${CURDIR}        ..
    ${src_dir}=                     Join Path           ${parent_dir}    data
    ${dest_dir}=                    Get Test Data directory
    Set Global Variable             ${TEST_DATA_DIR}    ${dest_dir}
    Copy Directory                  ${src_dir}          ${dest_dir}

Global Teardown
    Remove Directory with Content    ${TEST_DATA_DIR}
