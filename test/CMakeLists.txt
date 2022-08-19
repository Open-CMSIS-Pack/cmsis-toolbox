add_executable(ToolboxTests src/InstallerTests.cpp src/ToolboxTestEnv.cpp
  src/ToolboxTestEnv.h)

set_property(TARGET ToolboxTests PROPERTY
  MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

target_link_libraries(ToolboxTests PUBLIC CrossPlatform RteFsUtils gtest_main)
target_include_directories(ToolboxTests PUBLIC ./src)

add_definitions(-DEXTN="")
if(WIN32)
  add_definitions(-DEXTN=".exe")
endif()

add_definitions(-DTEST_FOLDER="${CMAKE_CURRENT_SOURCE_DIR}/")

add_test(NAME ToolboxTests
         COMMAND ToolboxTests --gtest_output=xml:test_reports/toolboxtests-${SYSTEM}${ARCH}.xml
         WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
