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
Resource         utils.resource

*** Keywords ***
Run Program
    [Documentation]             Run specified executable with arguments
    [Arguments]                 ${exe_path}    ${input_file}    @{args}    ${command}=${EMPTY}
    ${is_command_empty}=        Evaluate    '${command}' == '${EMPTY}'
    ${result}=                  Run Keyword If    ${is_command_empty}    Run Process    ${exe_path}    ${input_file}    @{args}    shell=True    stdout=${CURDIR}/stdout.txt
    ...    ELSE    Run Process    ${exe_path}     ${command}    ${input_file}    @{args}    shell=True    stdout=${CURDIR}/stdout.txt
    ${ret_code}=                Set Variable If    ${result.rc} == 0    ${result.rc}    ${1}
    Log Many                    StdOut: ${result.stdout}
    RETURN                      ${ret_code}

Run cbuild
    [Documentation]                Execute cbuild command with specified arguments
    [Arguments]                    ${input_file}    ${command}    ${args}=@{EMPTY}
    Append To List                 ${args}    -p    -r    --update-rte
    ${is_command_empty}=           Evaluate    '${command}' == '${EMPTY}'
    ${ret_code}=    Run Keyword If    ${is_command_empty}    Run Program    cbuild    ${input_file}    @{args}
    ...    ELSE    Run Program    cbuild    ${input_file}    @{args}    ${command}
    RETURN                         ${ret_code}

Build Example With cbuildgen
    [Documentation]     Build csolution example with cbuildgen
    [Arguments]         ${input_file}    ${expect}        ${args}=@{EMPTY}
    ${parent_path}=     Get Parent Directory Path         ${input_file}
    ${output_dir}=      Normalize Path    ${parent_path}${/}${Out_Dir}
    ${args_Ex}=         Copy List    ${args}
    Append To List      ${args_Ex}    --output    ${output_dir}    --cbuildgen
    ${ret_code}=        Run cbuild       ${input_file}    ${EMPTY}    ${args_Ex}
    Should Be Equal     ${ret_code}      ${expect}        msg=Unexpected status returned when building with cbuildgen

Build Example With cbuild2cmake
    [Documentation]     Build the csolution example with cbuild2cmake
    [Arguments]         ${input_file}     ${expect}        ${args}=@{EMPTY}
    ${args_Ex}=         Copy List         ${args}
    ${ret_code}=        Run cbuild        ${input_file}    ${EMPTY}    ${args_Ex}
    Should Be Equal     ${ret_code}       ${expect}        msg=Unexpected status returned when building with cbuild2cmake

Initialize Pack Root Directory
    [Documentation]     Initialize pack root directory
    [Arguments]         ${pack_root_dir}
    Run Program         cpackget    init    https://www.keil.com/pack/index.pidx    -R    ${pack_root_dir}

Install Pack 
    [Documentation]     Install pack to pack root directory
    [Arguments]         ${pack_id}    ${pack_root_dir}
    ${ret_code}=        Run Program         cpackget    add    ${pack_id}
    ...                    -R    ${pack_root_dir}
    ...                    --agree-embedded-license    --force-reinstall     --no-dependencies
    RETURN              ${ret_code}

Get Contexts From Project
    [Documentation]     Get list of contexts from the csolution project
    [Arguments]         ${input_file}    ${expect}        ${args}=@{EMPTY}
    ${parent_path}=     Get Parent Directory Path         ${input_file}

    ${result}    Run Process    csolution     list    contexts    --yml-order    ${input_File}
    ...                     -q    shell=True    stdout=${CURDIR}/stdout.txt
    ${ret_code}=        Set Variable If    ${result.rc} == ${0}    ${result.rc}    ${1}
    Should Be Equal     ${ret_code}      ${expect}        msg=Unexpected status returned by list context command
    RETURN              ${result.stdout}

Build CSolution Example
    [Arguments]                        ${input_file}    ${cbuildgen_expect}    ${cbuild2cmake_expect}    ${args}=@{EMPTY}
    Build Example With cbuild2cmake    ${input_file}    ${cbuild2cmake_expect}     ${args}
    Build Example With cbuildgen       ${input_file}    ${cbuildgen_expect}        ${args}

    # If any of the expectations is failure, there's no need to compare ELF information 
    IF    '${cbuildgen_expect}' == '1' or '${cbuild2cmake_expect}' == '1'
        RETURN    ${True}
    END

    ${parent_path}=    Get Parent Directory Path     ${input_file}
    ${result}=         Run Keyword And Return
    ...                    Compare Elf Information   ${input_file}
    ...                    ${parent_path}${/}${Out_Dir}${/}${Default_Out_Dir}
    ...                    ${parent_path}${/}${Default_Out_Dir}
    RETURN             ${result}

Checkout GitHub Repository
    [Documentation]                 Checkout github repository
    [Arguments]                     ${github_repo_url}    ${dest_path}
    ${result}=    Run Process       git    clone          ${github_repo_url}    ${dest_path}
    Log                             ${result.stdout}
    Log                             ${result.stderr}
    Should Be Equal As Integers     ${result.rc}          ${0}

Run Csolution Project
    [Arguments]         ${input_file}    ${expect}     ${args}=@{EMPTY}
    ${contexts}=        Get Contexts From Project      ${input_file}    ${expect}    ${args}
    ${filcontexts}=     Convert And Filter Contexts    ${contexts}
    @{args_ex}          Create List                    @{args}    @{filcontexts}
    
    ${res_cbuildgen}=       Run Keyword And Ignore Error
    ...                         Build Example With cbuildgen      ${input_file}    ${expect}    ${args_ex}
    ${res_cbuild2cmake}=    Run Keyword And Ignore Error
    ...                        Build Example with cbuild2cmake    ${input_file}    ${expect}    ${args_ex}

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
    ${parent_path}=    Get Parent Directory Path    ${input_file}
    ${result}=         Run Keyword And Return
    ...                    Compare Elf Information   ${input_file}
    ...                    ${parent_path}${/}${Out_Dir}${/}${Default_Out_Dir}  
    ...                    ${parent_path}${/}${Default_Out_Dir}
    Should Be True     ${result}

Convert And Filter Contexts
    [Documentation]    Example test to convert a string to an array, filter it, and join it
    [Arguments]        ${all_contexts}
    @{lines}=    Split String    ${all_contexts}    \n

    # Filter out items containing '+iar'
    @{filtered_lines}=    Create List
    FOR    ${line}    IN    @{lines}
        log    ${line}
        ${result}=    Run Keyword And Return Status    Should Contain    ${line}    iar
        Run Keyword If    ${result}==False    Append To List    ${filtered_lines}    ${line}
    END

    # Prefix remaining items with '-c ' and join them
    @{context_list_args}=    Create List
    FOR    ${line}    IN    @{filtered_lines}
        Append To List    ${context_list_args}    -c    ${line}
    END

    RETURN    ${context_list_args}
