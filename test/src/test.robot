*** Settings ***
Documentation           Tests to execute solution examples
Resource                ./global.robot
Resource                ${RESOURCES}/utils.resource
Suite Setup             Global Setup
Suite Teardown          Global Teardown
Library                 Collections 

*** Variables ***
@{build_examples}       build-asm    build-c     build-cpp    linker-pre-processing    pre-include
@{build_files}          solution     solution    solution     solution                 solution

*** Test Cases ***
Build Examples with cbuildgen
    FOR    ${example}    IN    @{build_examples}
    ${index}=            Get Index From List    ${build_examples}    ${example}
    Run cbuild           ${TEST_DATA_DIR}${/}${example}${/}${build_files}[${index}].csolution.yml
    END

Build Examples with cbuild2cmake
    FOR    ${example}    IN    @{build_examples}
    ${index}=            Get Index From List    ${build_examples}    ${example}
    Run cbuild           ${TEST_DATA_DIR}${/}${example}${/}${build_files}[${index}].csolution.yml    --cbuild2cmake
    END
