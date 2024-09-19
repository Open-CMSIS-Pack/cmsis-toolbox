cmake_minimum_required(VERSION 3.22)
project(cmsis-toolbox NONE)

set(TOOLBOX_ROOT "" CACHE PATH "CMSIS-Toolbox Root")
set(TOOLBOX_VERSION "" CACHE STRING "CMSIS-Toolbox Version")

if(TOOLBOX_ROOT STREQUAL "")
  message(SEND_ERROR "TOOLBOX_ROOT not defined")
endif()
if(TOOLBOX_VERSION STREQUAL "")
  message(SEND_ERROR "TOOLBOX_VERSION not defined")
endif()

# install cmsis-toolbox files in /usr/lib/cmsis-toolbox
set(CPACK_PACKAGING_INSTALL_PREFIX "/usr")
install(DIRECTORY ${TOOLBOX_ROOT}/
  FILE_PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
  DESTINATION lib/${CMAKE_PROJECT_NAME})

# create symlinks and install them in /usr/bin
execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory
  ${CMAKE_CURRENT_BINARY_DIR}/symlink)
file(GLOB_RECURSE EXECUTABLES ${TOOLBOX_ROOT}/bin/*)
foreach(EXECUTABLE ${EXECUTABLES})
  cmake_path(GET EXECUTABLE FILENAME NAME)
  execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
    ${CPACK_PACKAGING_INSTALL_PREFIX}/lib/${CMAKE_PROJECT_NAME}/bin/${NAME}
    ${CMAKE_CURRENT_BINARY_DIR}/symlink/${NAME})
endforeach()
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/symlink/ DESTINATION bin)

# set debian package info
set(CPACK_GENERATOR "DEB")
set(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)
set(CPACK_DEBIAN_PACKAGE_NAME ${CMAKE_PROJECT_NAME})
set(CPACK_DEBIAN_PACKAGE_VERSION ${TOOLBOX_VERSION})
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "CMSIS-Toolbox command-line tools")
set(CPACK_PACKAGE_DESCRIPTION
"The CMSIS-Toolbox uses software packs for device/board support and access
reusable software components. The operation is controlled via intuitive csolution
project files in YAML format. The overall application is defined in the
*.csolution.yml file and contains one or more projects that can utilize
pre-configured software layers. The build engine CMake/Ninja calls the C/C++
compiler toolchain that generates the Build Output.")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Daniel Brondani - Arm Ltd. <daniel.brondani@arm.com>")
set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://github.com/Open-CMSIS-Pack/cmsis-toolbox")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "cmake (>= 3.27), ninja-build (>=1.11.1)")

include(CPack)
