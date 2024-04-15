# components.cmake

# component ARM::CMSIS:CORE@6.0.0
add_library(ARM_CMSIS_CORE_6_0_0 INTERFACE)
target_include_directories(ARM_CMSIS_CORE_6_0_0 INTERFACE
  ${CMSIS_PACK_ROOT}/ARM/CMSIS/6.0.0/CMSIS/Core/Include
)
target_include_directories(ARM_CMSIS_CORE_6_0_0 INTERFACE
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_INCLUDE_DIRECTORIES>
)
target_compile_definitions(ARM_CMSIS_CORE_6_0_0 INTERFACE
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_DEFINITIONS>
)

# component ARM::Device:Startup&C Startup@2.2.0
add_library(ARM_Device_Startup_C_Startup_2_2_0 OBJECT
  "${SOLUTION_ROOT}/project/RTE/Device/ARMCM0/startup_ARMCM0.c"
  "${SOLUTION_ROOT}/project/RTE/Device/ARMCM0/system_ARMCM0.c"
)
target_include_directories(ARM_Device_Startup_C_Startup_2_2_0 PUBLIC
  ${CMSIS_PACK_ROOT}/ARM/Cortex_DFP/1.0.0/Device/ARMCM0/Include
)
target_include_directories(ARM_Device_Startup_C_Startup_2_2_0 PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_INCLUDE_DIRECTORIES>
)
target_compile_definitions(ARM_Device_Startup_C_Startup_2_2_0 PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_DEFINITIONS>
)
target_compile_options(ARM_Device_Startup_C_Startup_2_2_0 PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_OPTIONS>
)

# component ARM::RteTest:LanguageAndScope@0.9.9
add_library(ARM_RteTest_LanguageAndScope_0_9_9 OBJECT
  "${SOLUTION_ROOT}/pack/LanguageAndScope/Dummy1.c"
  "${SOLUTION_ROOT}/pack/LanguageAndScope/Dummy2.cpp"
)
target_include_directories(ARM_RteTest_LanguageAndScope_0_9_9
  PRIVATE
    $<$<COMPILE_LANGUAGE:C,CXX>:
      ${SOLUTION_ROOT}/pack/LanguageAndScope/Hidden
      ${SOLUTION_ROOT}/pack/LanguageAndScope/Private
    >
  PUBLIC
    $<$<COMPILE_LANGUAGE:C>:
      ${SOLUTION_ROOT}/pack/LanguageAndScope/Public
    >
    $<$<COMPILE_LANGUAGE:C,CXX>:
      ${SOLUTION_ROOT}/pack/LanguageAndScope/Visible
    >
)
target_include_directories(ARM_RteTest_LanguageAndScope_0_9_9 PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_INCLUDE_DIRECTORIES>
)
target_compile_definitions(ARM_RteTest_LanguageAndScope_0_9_9 PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_DEFINITIONS>
)
target_compile_options(ARM_RteTest_LanguageAndScope_0_9_9 PUBLIC
  $<TARGET_PROPERTY:${CONTEXT},INTERFACE_COMPILE_OPTIONS>
)
