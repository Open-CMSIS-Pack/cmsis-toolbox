*** Settings ***
Documentation           Tests to compile & execute remote csolution examples
Suite Setup             Global Setup
Suite Teardown          Global Teardown
Library                 lib${/}utils.py 
Library                 String
Library                 Collections
Library                 lib${/}elf_compare.py 
Resource                resources${/}global.resource
Resource                resources${/}utils.resource
Test Template           Test github examples


*** Variables ***
${csolution-examples}       https://github.com/Open-CMSIS-Pack/csolution-examples
${Hello_B-U585I-IOT02A}     https://github.com/Arm-Examples/Hello_B-U585I-IOT02A
${Hello_FRDM-K32L3A6}       https://github.com/Arm-Examples/Hello_FRDM-K32L3A6


*** Test Cases ***
# Test Csolution example
#     ${csolution-examples}    ${Pass}

# Test Hello_1 example
#     ${Hello_B-U585I-IOT02A}    ${Pass}

# Test Hello_2 example
#     ${Hello_FRDM-K32L3A6}    ${Pass}

*** Keywords ***
Test github examples
    [Arguments]    ${github_url}        ${expect}
    ${dest_dir}=    Evaluate    "${github_url}".split('/')[-1]
    ${dest_dir}=    Set Variable    ${TEST_DATA_DIR}${/}${Remote_Example_Dir}${/}${dest_dir}
    Checkout GitHub Repository    ${github_url}    ${dest_dir}       
    ${files}    Glob Files In Directory    ${dest_dir}    *.csolution.*    ${True}
    FOR    ${file}    IN    @{files}
        ${example_name}=    Get Parent Directory Name    ${file}
        Run Keyword If    '${example_name}' != 'CubeMX'    
        ...    Run Csolution Project    ${file}    ${expect}
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
