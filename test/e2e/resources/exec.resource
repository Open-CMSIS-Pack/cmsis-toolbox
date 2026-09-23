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
    ${contexts}=                   Get Contexts From Project      ${input_file}    ${0}    ${args}
    ${filecontexts}=               Convert And Filter Contexts    ${contexts}

    @{args_ex}                     Create List    @{args}    @{filecontexts}
    Append To List                 ${args_ex}    -p    -r    --update-rte
    Log                            cbuild args: ${args_ex}


    ${is_command_empty}=           Evaluate    '${command}' == '${EMPTY}'
    ${ret_code}=                   Run Keyword If    ${is_command_empty}
    ...    Run Program    cbuild    ${input_file}    @{args_ex}
    ...    ELSE
    ...    Run Program    cbuild    ${input_file}    @{args_ex}    ${command}
    RETURN                         ${ret_code}

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

    ${result}    Run Process    csolution     list    contexts    --yml-order    ${input_file}
    ...                     -q    shell=True    stdout=${CURDIR}/stdout.txt

    ${ret_code}=        Set Variable If    ${result.rc} == ${0}    ${result.rc}    ${1}
    Log Many            StdOut: ${result.stdout}
    Log Many            StdErr: ${result.stderr}
    ${contexts}=        Set Variable    ${result.stdout}

    Should Be Equal As Integers
    ...    ${ret_code}
    ...    ${expect}
    ...    msg=Unexpected status returned by list context command.

    RETURN              ${contexts}

Build CSolution Example
    [Arguments]                        ${input_file}    ${cbuild2cmake_expect}    ${args}=@{EMPTY}
    Build Example With cbuild2cmake    ${input_file}    ${cbuild2cmake_expect}     ${args}

Checkout GitHub Repository
    [Documentation]                 Checkout github repository
    [Arguments]                     ${github_repo_url}    ${dest_path}
    ${result}=    Run Process       git    clone          ${github_repo_url}    ${dest_path}
    Log                             ${result.stdout}
    Log                             ${result.stderr}
    Should Be Equal As Integers     ${result.rc}          ${0}

Run Csolution Project
    [Arguments]                     ${input_file}    ${expect}     ${args}=@{EMPTY}
    ${file_name}=        Evaluate    os.path.basename(r'''${input_file}''')    modules=os
    ${is_tz_example}=    Evaluate    $file_name == "SimpleTZ.csolution.yml"

    @{args_ex}                  Create List    @{args}

    ${res_cbuild2cmake}=    Run Keyword And Ignore Error
    ...    Build Example with cbuild2cmake
    ...    ${input_file}
    ...    ${expect}
    ...    ${args_ex}

    # Check the result of the second run
    ${success}=    Set Variable    ${res_cbuild2cmake[0]}
    ${message}=    Set Variable    ${res_cbuild2cmake[1]}
    Run Keyword If    '${success}' == 'PASS'
    ...    Log    cbuild2cmake ran successfully
    ...    ELSE
    ...    Log    cbuild2cmake failed with message: ${message}

    ${build_success}=    Evaluate    '${res_cbuild2cmake[0]}' == 'PASS'
    IF    '${build_success}' == 'False'
        Return From Keyword    False
    END

    Return From Keyword    True

Convert And Filter Contexts
    [Documentation]    Example test to convert a string to an array, filter it, and join it
    [Arguments]        ${all_contexts}

    @{contexts}=       Split String    ${all_contexts}    \n
    Log    All contexts before filtering:\n${all_contexts}

    ${is_arm64}=        Is ARM64 Architecture

    # Prefix remaining items with '-c ' and join them
    @{context_list_args}=    Create List
    FOR    ${context}    IN    @{contexts}
        ${context_lower}=    Convert To Lower Case    ${context}
        ${is_iar_context}=    Run Keyword And Return Status    Should Contain    ${context_lower}    iar
        ${is_xc_context}=     Run Keyword And Return Status    Should Contain    ${context_lower}    xc
        ${skip_context}=      Evaluate    $is_arm64 and ($is_iar_context or $is_xc_context)
        IF    not ${skip_context}
            Append To List    ${context_list_args}    -c    ${context}
        END
    END

    Log    Context arguments after filtering: ${context_list_args}

    RETURN    ${context_list_args}
