add_executable(ToolboxTest1 src/InstallerTests.cpp src/ToolboxTestEnv.cpp
  src/ToolboxTestEnv.h)

set_property(TARGET ToolboxTest1 PROPERTY
  MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

target_link_libraries(ToolboxTest1 PUBLIC CrossPlatform RteFsUtils gtest_main)
target_include_directories(ToolboxTest1 PUBLIC ./src)

add_definitions(-DEXTN="")
if(WIN32)
  add_definitions(-DEXTN=".exe")
endif()

add_definitions(-DTEST_FOLDER="${CMAKE_CURRENT_SOURCE_DIR}/")

add_test(NAME ToolboxTest1
         COMMAND ToolboxTest1 --gtest_output=xml:test_reports/toolboxtest1-${SYSTEM}${ARCH}.xml
         WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
