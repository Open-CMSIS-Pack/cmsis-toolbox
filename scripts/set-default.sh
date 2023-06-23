#!/bin/bash

# -------------------------------------------------------
# Copyright (c) 2022 Arm Limited. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
# -------------------------------------------------------

case $1 in
  'Windows')
    # windows
    extension=".exe"
    ;;
  'Linux' | 'Darwin')
    # linux/macos
    extension=""
    ;;
esac

# update toolchain config files
script="$2/AC6.6.18.0.cmake"
sed -e "s|^  set(EXT.*|  set(EXT ${extension})|" "${script}" > temp.$$ && mv temp.$$ "${script}"

script="$2/GCC.10.3.1.cmake"
sed -e "s|^  set(EXT.*|  set(EXT ${extension})|" "${script}" > temp.$$ && mv temp.$$ "${script}"

script="$2/IAR.9.32.1.cmake"
sed -e "s|^  set(EXT.*|  set(EXT ${extension})|" "${script}" > temp.$$ && mv temp.$$ "${script}"

exit 0
