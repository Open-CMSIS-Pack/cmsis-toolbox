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
