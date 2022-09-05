#!/bin/bash

# -------------------------------------------------------
# Copyright (c) 2020-2021 Arm Limited. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
# -------------------------------------------------------

# Version: 1.0
# Date: 2020-06-04
# This script runs the installer
#
# Pre-requisites:
# - bash shell (for Windows: install git for Windows)

usage() {
  echo "Usage:"
  echo "  $(basename $0) [<TestOutput> <args>]"
  echo ""
}

if [ $# -eq 0 ]; then
  echo "error: no argument passed"
  usage
  exit 1
fi

# arguments
for i in "$@"
do
  case "$i" in
    --testoutput=*)
      testoutdir="${i#*=}"
      shift
    ;;
    *)
      args+="$i "
    ;;
  esac
done

if [ ! -d "${testoutdir}" ]; then
  echo "error: directory ${testoutdir} does not exist"
  exit 1
fi

# check if CI_TOOLBOX_INSTALLER is set
if [ -z ${CI_TOOLBOX_INSTALLER+x} ]; then
  echo "error: CI_TOOLBOX_INSTALLER is not set"
  exit 1
fi

echo "Using installer: ${CI_TOOLBOX_INSTALLER}"
installer="${CI_TOOLBOX_INSTALLER}"

# check if CI_PACK_ROOT is set
install_config=install_config.def
> ${install_config}

echo "${testoutdir}/Installation" > ${install_config}
if [[ `uname -s` != "Linux" && `uname -s` != "Darwin" ]]
  then
  # windows
  echo "/$(echo $CI_PACK_ROOT | sed -e 's/\\/\//g' -e 's/://g')" >> ${install_config}
  echo "/$(echo $CI_ARMCC6_TOOLCHAIN_ROOT | sed -e 's/\\/\//g' -e 's/://g')" >> ${install_config}
  echo "/$(echo $CI_ARMCC5_TOOLCHAIN_ROOT | sed -e 's/\\/\//g' -e 's/://g')" >> ${install_config}
  echo "/$(echo $CI_GCC_TOOLCHAIN_ROOT | sed -e 's/\\/\//g' -e 's/://g')" >> ${install_config}
else
  echo "$CI_PACK_ROOT" >> ${install_config}
  echo "$CI_ARMCC6_TOOLCHAIN_ROOT" >> ${install_config}
  echo "$CI_ARMCC5_TOOLCHAIN_ROOT" >> ${install_config}
  echo "$CI_GCC_TOOLCHAIN_ROOT" >> ${install_config}
fi
cat ${install_config}

# Run cbuild installer
dos2unix ${install_config}
"${installer}" ${args} < ${install_config}
if [ $? -ne 0 ]
  then
  exit 1
fi

exit 0
