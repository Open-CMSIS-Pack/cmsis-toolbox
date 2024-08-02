*** Settings ***
Documentation           Tests to build pack csolution examples
Suite Setup             Create Test Data Directory
Suite Teardown          Global Teardown
Library                 BuiltIn
Library                 Collections
Library                 DataDriver
Library                 OperatingSystem
Library                 String
Library                 lib${/}elf_compare.py
Library                 lib${/}utils.py 
Resource                resources${/}global.resource
Resource                resources${/}utils.resource
Resource                resources${/}exec.resource
Test Template           Test packs examples


*** Variables ***
${context_string}  ${EMPTY}

*** Test Cases ***
Test pack example ${pack_id} and expect ${expect}    Default    UserData

*** Keywords ***
Test packs examples
    [Arguments]     ${pack_id}    ${expect}
    ${pack_root_dir}=    Join Paths    ${TEST_DATA_DIR}    ${Local_Pack_Root_Dir}
    Create Directory                   ${pack_root_dir}
    Initialize Pack Root Directory     ${pack_root_dir}
    Install Pack         ${pack_id}    ${pack_root_dir}
    Change Directory Permissions       ${pack_root_dir}
    ${files}    Glob Files In Directory    ${pack_root_dir}    *.csolution.*    ${True}
    FOR    ${file}    IN    @{files}
        ${file}=    Normalize Path    ${file}
        Run Csolution Project    ${file}    ${expect}
    END

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
