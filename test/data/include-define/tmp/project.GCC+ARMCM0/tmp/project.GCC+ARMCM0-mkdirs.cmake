# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/tmp/project.GCC+ARMCM0"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/tmp/1"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/tmp/project.GCC+ARMCM0"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/tmp/project.GCC+ARMCM0/tmp"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/tmp/project.GCC+ARMCM0/src/project.GCC+ARMCM0-stamp"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/tmp/project.GCC+ARMCM0/src"
  "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/tmp/project.GCC+ARMCM0/src/project.GCC+ARMCM0-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/tmp/project.GCC+ARMCM0/src/project.GCC+ARMCM0-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "C:/Sandbox/forked/cmsis-toolbox/test/data/include-define/tmp/project.GCC+ARMCM0/src/project.GCC+ARMCM0-stamp${cfgdir}") # cfgdir has leading slash
endif()
