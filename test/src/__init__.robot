*** Settings ***
Library            OperatingSystem
Resource           ./global.robot
Resource           ${RESOURCES}/utils.resource
# Suite Setup        Global Setup
# Suite Teardown     Global Teardown


*** Keywords ***
Global Setup
    ${parent_dir}=         Join Path           ${CURDIR}        ..
    ${src_dir}=            Join Path           ${parent_dir}    data
    ${dest_dir}=           Get Test Data directory
    Set Global Variable    ${TEST_DATA_DIR}    ${dest_dir}
    Copy Directory         ${src_dir}          ${dest_dir}

Global Teardown
    Remove Directory with Content    ${TEST_DATA_DIR}
