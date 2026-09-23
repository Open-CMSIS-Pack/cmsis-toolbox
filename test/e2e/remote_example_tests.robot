*** Settings ***
Documentation           Tests to compile & execute remote csolution examples
Suite Setup             Create Test Data Directory
Suite Teardown          Global Teardown
Library                 DataDriver
Library                 Collections
Library                 String
Library                 lib${/}utils.py
Resource                resources${/}global.resource
Resource                resources${/}utils.resource
Resource                resources${/}exec.resource
Test Template           Test github examples


*** Test Cases ***
Test remote example ${github_url} and ${cbuild2cmake_expect}  Default    UserData

*** Keywords ***
Test github examples
    [Arguments]                             ${github_url}    ${cbuild2cmake_expect}
    ${dest_dir}=    Get Destination Path    ${github_url}
    Checkout GitHub Repository              ${github_url}    ${dest_dir}
    ${files}    Glob Files In Directory     ${dest_dir}    *.csolution.*    ${True}    Templates
    FOR    ${file}    IN    @{files}
        Build Remote CSolution Example    ${file}    ${cbuild2cmake_expect}
    END

Build Remote CSolution Example
    [Arguments]                              ${input_file}      ${cbuild2cmake_expect}    ${args}=@{EMPTY}
    ${result}=    Run Csolution Project      ${input_file}      ${cbuild2cmake_expect}    ${args}
    Should Be True                           ${result}
