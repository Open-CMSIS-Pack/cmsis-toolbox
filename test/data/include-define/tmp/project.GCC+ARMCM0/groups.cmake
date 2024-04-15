# groups.cmake

# group Source1
add_library(Group_Source1 OBJECT
  "${SOLUTION_ROOT}/project/source1.c"
)
target_include_directories(Group_Source1 PUBLIC
  ${SOLUTION_ROOT}/project/inc1
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_INCLUDE_DIRECTORIES>
)
target_compile_definitions(Group_Source1 PUBLIC
  $<$<COMPILE_LANGUAGE:C,CXX>:
    DEF1=1
  >
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_DEFINITIONS>
)
target_compile_options(Group_Source1 PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_OPTIONS>
)

# group Source2
add_library(Group_Source1_Source2 OBJECT
  "${SOLUTION_ROOT}/project/source2.c"
)
target_include_directories(Group_Source1_Source2 PUBLIC
  ${SOLUTION_ROOT}/project/inc2
  $<LIST:REMOVE_ITEM,$<TARGET_PROPERTY:Group_Source1,INTERFACE_INCLUDE_DIRECTORIES>,
    ${SOLUTION_ROOT}/project/inc1
  >
)
target_compile_definitions(Group_Source1_Source2 PUBLIC
  $<$<COMPILE_LANGUAGE:C,CXX>:
    DEF2=1
  >
  $<LIST:FILTER,$<TARGET_PROPERTY:Group_Source1,INTERFACE_COMPILE_DEFINITIONS>,EXCLUDE,^DEF1.*>
)
target_compile_options(Group_Source1_Source2 PUBLIC
  $<TARGET_PROPERTY:Group_Source1,INTERFACE_COMPILE_OPTIONS>
)

# group Main
add_library(Group_Main OBJECT
  "${SOLUTION_ROOT}/project/main.c"
)
target_include_directories(Group_Main PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_INCLUDE_DIRECTORIES>
)
target_compile_definitions(Group_Main PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_DEFINITIONS>
)
target_compile_options(Group_Main PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_OPTIONS>
)
set_source_files_properties("${SOLUTION_ROOT}/project/main.c" PROPERTIES
  INCLUDE_DIRECTORIES ${SOLUTION_ROOT}/project/inc2
  COMPILE_DEFINITIONS DEF2
)

# group Headers
add_library(Group_Headers INTERFACE)
target_include_directories(Group_Headers INTERFACE
  ${SOLUTION_ROOT}/project/inc3
)
target_include_directories(Group_Headers INTERFACE
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_INCLUDE_DIRECTORIES>
)
target_compile_definitions(Group_Headers INTERFACE
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_DEFINITIONS>
)
