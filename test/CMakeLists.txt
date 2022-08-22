# to-do: changed ToolboxTests to ToolboxTest due to name conflict
# needs to revert it back
add_executable(ToolboxTest src/InstallerTests.cpp src/ToolboxTestEnv.cpp
  src/ToolboxTestEnv.h)

set_property(TARGET ToolboxTest PROPERTY
  MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

target_link_libraries(ToolboxTest PUBLIC CrossPlatform RteFsUtils gtest_main)
target_include_directories(ToolboxTest PUBLIC ./src)

add_definitions(-DEXTN="")
if(WIN32)
  add_definitions(-DEXTN=".exe")
endif()

add_definitions(-DTEST_FOLDER="${CMAKE_CURRENT_SOURCE_DIR}/")

add_test(NAME ToolboxTest
         COMMAND ToolboxTest --gtest_output=xml:test_reports/toolboxtest-${SYSTEM}${ARCH}.xml
         WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
