*** Settings ***
Documentation           Tests to compile & execute remote csolution examples
Suite Setup             Global Setup
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
Test remote example ${github_url} and expect ${expect}    Default    UserData

*** Keywords ***
Test github examples
    [Arguments]                             ${github_url}    ${expect}
    ${dest_dir}=    Get Destination Path    ${github_url}
    Checkout GitHub Repository              ${github_url}    ${dest_dir}       
    ${files}    Glob Files In Directory     ${dest_dir}    *.csolution.*    ${True}
    FOR    ${file}    IN    @{files}
        Build Remote CSolution Example    ${file}    ${expect}
    END

Build Remote CSolution Example
    [Arguments]                              ${input_file}      ${expect}    ${args}=@{EMPTY}
    ${result}=    Build CSolution Example    ${input_file}      ${expect}    ${args}
    Should Be True                           ${result}
