# components.cmake

# component ARM::CMSIS:CORE@6.0.0
add_library(ARM_CMSIS_CORE_6_0_0 INTERFACE)
target_include_directories(ARM_CMSIS_CORE_6_0_0 INTERFACE
  $<LIST:REMOVE_ITEM,$<TARGET_PROPERTY:${CONTEXT},INTERFACE_INCLUDE_DIRECTORIES>,
    ${SOLUTION_ROOT}/project/inc1
  >
)
target_compile_definitions(ARM_CMSIS_CORE_6_0_0 INTERFACE
  $<LIST:FILTER,$<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_DEFINITIONS>,EXCLUDE,^DEF1.*>
)

# component ARM::Device:Startup&C Startup@2.2.0
add_library(ARM_Device_Startup_C_Startup_2_2_0 OBJECT
  "${SOLUTION_ROOT}/project/RTE/Device/ARMCM0/startup_ARMCM0.c"
  "${SOLUTION_ROOT}/project/RTE/Device/ARMCM0/system_ARMCM0.c"
)
target_include_directories(ARM_Device_Startup_C_Startup_2_2_0 PUBLIC
  ${SOLUTION_ROOT}/project/inc2
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_INCLUDE_DIRECTORIES>
)
target_compile_definitions(ARM_Device_Startup_C_Startup_2_2_0 PUBLIC
  $<$<COMPILE_LANGUAGE:C,CXX>:
    DEF2=1
  >
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_DEFINITIONS>
)
target_compile_options(ARM_Device_Startup_C_Startup_2_2_0 PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_OPTIONS>
)
