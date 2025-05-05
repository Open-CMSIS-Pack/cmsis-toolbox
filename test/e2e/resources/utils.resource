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
Create Test Data Directory
    [Documentation]      Create test data directory
    # Set the global variable for test data directory
    ${dest_dir}=                    Get Test Data Directory
    Set Global Variable             ${TEST_DATA_DIR}    ${dest_dir}
    # Remove previous test data
    Run Keyword And Ignore Error    Remove Directory with Content    ${TEST_DATA_DIR}

Copy Test Data
    Create Test Data Directory
    # Copy test data under build tree
    ${parent_dir}=                    Join Paths    ${CURDIR}        ..
    ${src_dir}=                       Join Paths    ${parent_dir}    ${Data}
    Copy Directory                    ${src_dir}                 ${TEST_DATA_DIR}
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

Change Directory Permissions
    [Documentation]                 Change directory permissions
    [Arguments]                     ${target_dir}
    ${result}                       Run Process    chmod    -R    755    ${target_dir}
    Should Be Equal                 ${result.rc}    ${0}

Remove Directory with Content
    [Documentation]                 Remove directory and its content from target directory
    [Arguments]                         ${target_dir}
    ${target_dir}=    Normalize Path    ${target_dir}
    Change Directory Permissions        ${target_dir}
    Run Keyword And Ignore Error    Remove Directory
    ...                                ${target_dir}      recursive=${True}
    Wait Until Removed              ${target_dir}

Append Additional Arguments
    [Documentation]              Append values to the list
    [Arguments]                  ${list}    @{values}
    ${args}=    Combine Lists    ${list}    ${values}
    RETURN                       ${args}

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
