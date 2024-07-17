*** Settings ***
Documentation           Tests to compile & execute remote csolution examples
Suite Setup             Global Setup
Suite Teardown          Global Teardown
Library                 lib${/}utils.py 
Library                 String
Library                 Collections
Library                 lib${/}elf_compare.py
Library                 DataDriver
Resource                resources${/}global.resource
Resource                resources${/}utils.resource
Test Template           Test github examples


*** Test Cases ***
Test remote example ${github_url} and expect ${expect}    Default    UserData

*** Keywords ***
Test github examples
    [Arguments]     ${github_url}        ${expect}
    ${dest_dir}=    Get Destination Path    ${github_url}
    Checkout GitHub Repository           ${github_url}    ${dest_dir}       
    ${files}    Glob Files In Directory    ${dest_dir}    *.csolution.*    ${True}
    FOR    ${file}    IN    @{files}
        Run Csolution Project    ${file}    ${expect}
    END

Run Csolution Project
    [Arguments]                      ${input_file}    ${expect}    ${args}=@{EMPTY}
    Run Project With cbuildgen       ${input_file}    ${expect}    ${args}
    Run Project with cbuild2cmake    ${input_file}    ${expect}    ${args}
    ${parent_path}=                  Get Parent Directory Path    ${input_file}
    ${result}=                       Run Keyword And Return
    ...    Compare Elf Information   ${input_file}
    ...    ${parent_path}${/}${Out_Dir}${/}${Default_Out_Dir}
    ...    ${parent_path}${/}${Default_Out_Dir}
    Should Be True    ${result}
