# CMSIS Build CMakeLists generated on 2024-04-15T10:25:24

cmake_minimum_required(VERSION 3.22)

# Target options

set(TARGET project)
set(CPU Cortex-M0)
set(PRJ_DIR "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project")
set(OUT_DIR "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/out/project/ARMCM0/GCC")
set(INT_DIR "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/tmp/project/ARMCM0/GCC")
set(FPU NO_FPU)
set(CC_FLAGS_GLOBAL "-std=gnu11 -masm-syntax-unified -fomit-frame-pointer -ffunction-sections -fdata-sections")
set(CXX_FLAGS_GLOBAL "-masm-syntax-unified -fomit-frame-pointer -ffunction-sections -fdata-sections")
set(LD_FLAGS_GLOBAL "--specs=nano.specs --specs=rdimon.specs -Wl,-Map=\"C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/out/project/ARMCM0/GCC/project.elf.map\" -Wl,--gc-sections")
set(LD_SCRIPT "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/Device/ARMCM0/ARMCM0_gcc.ld")

set(DEFINES
  ARMCM0
  _RTE_
)

set(DEFINES_C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/main.c
  ARMCM0
  _RTE_
  DEF2
)

set(DEFINES_C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/source1.c
  ARMCM0
  _RTE_
  DEF1=1
)

set(DEFINES_C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/source2.c
  ARMCM0
  _RTE_
  DEF1=1
  DEF2=1
)

set(DEFINES_C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/Device/ARMCM0/startup_ARMCM0.c
  ARMCM0
  _RTE_
  DEF2=1
)

set(DEFINES_C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/Device/ARMCM0/system_ARMCM0.c
  ARMCM0
  _RTE_
  DEF2=1
)

set(INC_PATHS
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/_GCC_ARMCM0"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/CMSIS/6.0.0/CMSIS/Core/Include"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/Cortex_DFP/1.0.0/Device/ARMCM0/Include"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/inc3"
)

set(INC_PATHS_C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/main.c
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/inc2"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/_GCC_ARMCM0"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/CMSIS/6.0.0/CMSIS/Core/Include"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/Cortex_DFP/1.0.0/Device/ARMCM0/Include"
)

set(INC_PATHS_C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/source1.c
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/inc1"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/_GCC_ARMCM0"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/CMSIS/6.0.0/CMSIS/Core/Include"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/Cortex_DFP/1.0.0/Device/ARMCM0/Include"
)

set(INC_PATHS_C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/source2.c
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/inc2"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/_GCC_ARMCM0"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/CMSIS/6.0.0/CMSIS/Core/Include"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/Cortex_DFP/1.0.0/Device/ARMCM0/Include"
)

set(INC_PATHS_C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/Device/ARMCM0/startup_ARMCM0.c
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/inc2"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/_GCC_ARMCM0"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/CMSIS/6.0.0/CMSIS/Core/Include"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/Cortex_DFP/1.0.0/Device/ARMCM0/Include"
)

set(INC_PATHS_C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/Device/ARMCM0/system_ARMCM0.c
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/inc2"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/_GCC_ARMCM0"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/CMSIS/6.0.0/CMSIS/Core/Include"
  "C:/Users/soumeh01/AppData/Local/Arm/Packs/ARM/Cortex_DFP/1.0.0/Device/ARMCM0/Include"
)

set(CC_SRC_FILES
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/Device/ARMCM0/startup_ARMCM0.c"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/RTE/Device/ARMCM0/system_ARMCM0.c"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/main.c"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/source1.c"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/project/source2.c"
)

# Toolchain config map

set(REGISTERED_TOOLCHAIN_ROOT "C:/Program Files (x86)/GNU Arm Embedded Toolchain/10 2020-q4-major/bin")
set(REGISTERED_TOOLCHAIN_VERSION "10.3.1")
set(TOOLCHAIN_VERSION_MIN "10.3.1")
include ("C:/Sandbox/Test/cmsis-toolbox/etc/GCC.10.3.1.cmake")
include ("C:/Sandbox/Test/cmsis-toolbox/etc/CMSIS-Build-Utils.cmake")

# Setup project

project(${TARGET} LANGUAGES C)

cbuild_get_running_toolchain(TOOLCHAIN_ROOT TOOLCHAIN_VERSION C)

# Global Flags

cbuild_get_system_includes(CC_SYS_INC_PATHS_LIST CC_SYS_INC_PATHS)
set(CMAKE_C_FLAGS "${CC_CPU} ${CC_FLAGS} ${CC_FLAGS_GLOBAL} ${CC_SYS_INC_PATHS}")
set(CMAKE_C_LINK_FLAGS "${LD_CPU} ${_LS}\"${LD_SCRIPT}\" ${LD_FLAGS_GLOBAL} ${LD_FLAGS}")

# File Includes, Defines and Options

foreach(SRC ${CC_SRC_FILES})
  string(REPLACE " " "?" S ${SRC})
  if(DEFINED INC_PATHS_${S})
    set(INC_PATHS_LOCAL "${INC_PATHS_${S}}")
    set_source_files_properties(${SRC} PROPERTIES INCLUDE_DIRECTORIES "${INC_PATHS_LOCAL}")
  endif()
  get_source_file_property(FILE_FLAGS ${SRC} COMPILE_FLAGS)
  if(FILE_FLAGS STREQUAL "NOTFOUND")
    set(FILE_FLAGS)
  endif()
  if(DEFINED DEFINES_${S})
    cbuild_set_defines(CC DEFINES_${S})
    string(APPEND FILE_FLAGS " ${DEFINES_${S}}")
  else()
    string(APPEND FILE_FLAGS " ${CC_DEFINES}")
  endif()
  set_source_files_properties(${SRC} PROPERTIES COMPILE_FLAGS "${FILE_FLAGS}")
endforeach()

# Compilation Database

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_custom_target(database COMMAND ${CMAKE_COMMAND} -E copy_if_different "${INT_DIR}/compile_commands.json" "${OUT_DIR}")

# Setup Target

add_executable(${TARGET} ${CC_SRC_FILES})
set_target_properties(${TARGET} PROPERTIES PREFIX "" SUFFIX ".elf" OUTPUT_NAME "project")
set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${OUT_DIR} LINK_DEPENDS ${LD_SCRIPT})
target_include_directories(${TARGET} PUBLIC ${INC_PATHS})
