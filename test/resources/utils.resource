*** Settings ***
Documentation    A collection of commonly used keywords across multiple test suites
Library          BuiltIn
Library          Collections
Library          OperatingSystem
Library          Process
Library          String
Library          ..${/}lib${/}elf_compare.py
Library          ..${/}lib${/}utils.py
Resource         global.resource

*** Variables ***
${TEST_ENV_FILE}    test_env.md

*** Keywords ***
Global Setup
    # Set the global variable for test data directory
    ${parent_dir}=                    Join Paths    ${CURDIR}        ..
    ${src_dir}=                       Join Paths    ${parent_dir}    ${Data}
    ${dest_dir}=                      Get Test Data Directory
    Set Global Variable               ${TEST_DATA_DIR}           ${dest_dir}
    # Copy test data under build tree
    Copy Directory                    ${src_dir}                 ${dest_dir}
    # Generate test_env.md file under output directory
    ${output_file_path}=              Get Output File Path
    ${parent_path}=                   Get Parent Directory Path    ${output_file_path}
    ${test_env_file}=    Join Paths    ${parent_path}    ${TEST_ENV_FILE}
    Write Test Environment            ${test_env_file} 

Global Teardown
    # Remove test data after test execution
    Remove Directory with Content    ${TEST_DATA_DIR}

Get Test Data Directory
    [Documentation]      Retrieve the directory path for test input data
    ${parent_dir}=       Join Paths    ${CURDIR}        ..
    ${test_data_dir}=    Join Paths    ${parent_dir}    ${Build}
    RETURN               ${test_data_dir}

Run Program
    [Documentation]             Run specified executable with arguments
    [Arguments]                 ${exe_path}    ${input_file}    @{args}    ${command}=${EMPTY}
    ${is_command_empty}=        Evaluate    '${command}' == '${EMPTY}'
    ${result}=                  Run Keyword If    ${is_command_empty}    Run Process    ${exe_path}    ${input_file}    @{args}    shell=True    stdout=${CURDIR}/stdout.txt
    ...    ELSE    Run Process    ${exe_path}     ${command}    ${input_file}    @{args}    shell=True    stdout=${CURDIR}/stdout.txt
    ${ret_code}=                Set Variable If    ${result.rc} == 0    ${result.rc}    ${1}
    Log Output String           ${result.stdout}
    RETURN                      ${ret_code}

Run cbuild
    [Documentation]                Execute cbuild command with specified arguments
    [Arguments]                    ${input_file}    ${command}    ${args}=@{EMPTY}
    Append To List                 ${args}    -p    -r    --update-rte
    ${is_command_empty}=           Evaluate    '${command}' == '${EMPTY}'
    ${ret_code}=    Run Keyword If    ${is_command_empty}    Run Program    cbuild    ${input_file}    @{args}
    ...    ELSE    Run Program    cbuild    ${input_file}    @{args}    ${command}
    RETURN          ${ret_code}

Change Directory Permissions
    [Documentation]                 Change directory permissions
    [Arguments]                     ${target_dir}
    ${result}                       Run Process    chmod    -R    755    ${target_dir}
    Should Be Equal                 ${result.rc}    ${0}

Remove Directory with Content
    [Documentation]                 Remove directory and its content from target directory
    [Arguments]                     ${target_dir}
    ${target_dir}=    Normalize Path    ${target_dir}
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

Build Example With cbuildgen
    [Documentation]     Build csolution example with cbuildgen
    [Arguments]         ${input_file}    ${expect}        ${args}=@{EMPTY}
    ${parent_path}=     Get Parent Directory Path         ${input_file}
    ${output_dir}=      Normalize Path    ${parent_path}${/}${Out_Dir}
    ${args_Ex}=         Copy List    ${args}
    Append To List      ${args_Ex}    --output    ${output_dir}    --cbuildgen
    ${ret_code}=        Run cbuild       ${input_file}    ${EMPTY}    ${args_Ex}
    Should Be Equal     ${ret_code}      ${expect}        msg=Unexpected status returned by cbuildgen execution

Build Example With cbuild2cmake
    [Documentation]     Build the csolution example with cbuild2cmake
    [Arguments]         ${input_file}     ${expect}        ${args}=@{EMPTY}
    Append To List        ${args}    --cbuild2cmake
    # ${args}=    Insert At Front     ${args}    ${input_file}
    ${ret_code}=        Run cbuild        ${input_file}    ${EMPTY}    ${args}
    Should Be Equal     ${ret_code}       ${expect}        msg=Unexpected status returned by cbuild2cmake execution

Append Additional Arguments
    [Documentation]              Append values to the list
    [Arguments]                  ${list}    @{values}
    ${args}=    Combine Lists    ${list}    ${values}
    RETURN                       ${args}

Log Output String
    [Documentation]             Log STDOUT message
    [Arguments]                 ${message}
    Log Many                    StdOut: ${message}

Get Output File Path
    [Documentation]             Find path to output files
    ${output_path}=             Get Variable Value    ${OUTPUT_FILE}
    RETURN                      ${output_path}

Get Destination Path
    [Documentation]                 Get destination directory path from url
    [Arguments]                     ${github_url}
    ${dest_dir}=    Evaluate        "${github_url}".split('/')[-1]
    ${dest_dir}=    Set Variable    ${TEST_DATA_DIR}${/}${Remote_Example_Dir}${/}${dest_dir}
    RETURN                          ${dest_dir}

Cpackget Init
    [Documentation]     Initialize pack root directory
    [Arguments]         ${pack_root_dir}
    Run Program         cpackget    init    https://www.keil.com/pack/index.pidx    -R    ${pack_root_dir}

Cpackget Install Pack 
    [Documentation]     Install pack to pack root directory
    [Arguments]         ${pack_id}    ${pack_root_dir}
    ${ret_code}=        Run Program         cpackget    add    ${pack_id}
    ...                    -R    ${pack_root_dir}
    ...                    --agree-embedded-license    --force-reinstall
    RETURN              ${ret_code}

Get Contexts From Project
    [Documentation]     Get list of contexts from the csolution project
    [Arguments]         ${input_file}    ${expect}        ${args}=@{EMPTY}
    ${parent_path}=     Get Parent Directory Path         ${input_file}
    ${result}    Run Process    csolution     list    contexts    ${input_File}
    ...                     -q    shell=True    stdout=${CURDIR}/stdout.txt
    ${ret_code}=        Set Variable If    ${result.rc} == ${0}    ${result.rc}    ${1}
    Should Be Equal     ${ret_code}      ${expect}        msg=Unexpected status returned by list context command
    RETURN              ${result.stdout}

Join Paths
    [Documentation]    Join Paths
    [Arguments]        ${prefixPath}     ${suffixPath}
    ${resultPath}=     Join Path         ${prefixPath}    ${suffixPath}
    ${resultPath}=     Normalize Path    ${resultPath}
    RETURN             ${resultPath}

Normalize Path
    [Arguments]        ${Path}
    ${resultPath}=     Replace String    ${Path}    \\    /
    RETURN             ${resultPath}

Build CSolution Example
    [Arguments]                        ${input_file}    ${expect}    ${args}=@{EMPTY}
    ${res_cbuildgen}=       Run Keyword And Ignore Error    Build Example With cbuild2cmake    ${input_file}    ${expect}    ${args}
    ${res_cbuild2cmake}=    Run Keyword And Ignore Error    Build Example With cbuildgen       ${input_file}    ${expect}    ${args}

    # Check the result of the first run
    ${success}=    Set Variable    ${res_cbuildgen[0]}
    ${message}=    Set Variable    ${res_cbuildgen[1]}
    Run Keyword If    '${success}' == 'PASS'    Log    cbuildgen ran successfully
    ...    ELSE    Log    cbuildgen failed with message: ${message}

    # Check the result of the second run
    ${success}=    Set Variable    ${res_cbuild2cmake[0]}
    ${message}=    Set Variable    ${res_cbuild2cmake[1]}
    Run Keyword If    '${success}' == 'PASS'    Log    cbuild2cmake ran successfully
    ...    ELSE    Log    cbuild2cmake failed with message: ${message}

    Should Be Equal    ${res_cbuildgen[0]}    ${res_cbuild2cmake[0]}    build status doesn't match
    # Build Example With cbuild2cmake    ${input_file}    ${expect}    ${args}
    # Build Example With cbuildgen       ${input_file}    ${expect}    ${args}
    ${parent_path}=    Get Parent Directory Path     ${input_file}
    ${result}=         Run Keyword And Return
    ...                    Compare Elf Information   ${input_file}
    ...                    ${parent_path}${/}${Out_Dir}${/}${Default_Out_Dir}
    ...                    ${parent_path}${/}${Default_Out_Dir}
    RETURN                 ${result}
