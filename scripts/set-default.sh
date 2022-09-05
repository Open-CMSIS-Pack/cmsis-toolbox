#!/bin/bash

# -------------------------------------------------------
# Copyright (c) 2022 Arm Limited. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
# -------------------------------------------------------

case $1 in
  'Windows')
    # windows
    compiler6_default_path="C:/Keil_v5/ARM/ARMCLANG/bin"
    compiler5_default_path="C:/Keil_v5/ARM/ARMCC/bin"
    gcc_default_path="C:/Program Files (x86)/Arm GNU Toolchain arm-none-eabi/11.2 2022.02/bin"
    iar_default_path="C:/Program Files (x86)/IAR Systems/Embedded Workbench 8.4/arm/bin"
    extension=".exe"
    ;;
  'Linux' | 'Darwin')
    # linux/macos
    compiler6_default_path=~/ArmCompilerforEmbedded6.18/bin
    compiler5_default_path=~/ARM_Compiler_5.06u7/bin
    gcc_default_path=~/gcc-arm-11.2-2022.02-x86_64-arm-none-eabi/bin
    iar_default_path=/opt/iarsystems/bxarm/arm/bin
    extension=""
    ;;
esac

# update toolchain config files
script="$2/AC6.6.18.0.cmake"
sed -e "s|set(TOOLCHAIN_ROOT.*|set(TOOLCHAIN_ROOT \"${compiler6_default_path}\")|" "${script}" > temp.$$ && mv temp.$$ "${script}"
sed -e "s|set(EXT.*|set(EXT ${extension})|" "${script}" > temp.$$ && mv temp.$$ "${script}"

script="$2/AC5.5.6.7.cmake"
sed -e "s|set(TOOLCHAIN_ROOT.*|set(TOOLCHAIN_ROOT \"${compiler5_default_path}\")|" "${script}" > temp.$$ && mv temp.$$ "${script}"
sed -e "s|set(EXT.*|set(EXT ${extension})|" "${script}" > temp.$$ && mv temp.$$ "${script}"

script="$2/GCC.11.2.1.cmake"
sed -e "s|set(TOOLCHAIN_ROOT.*|set(TOOLCHAIN_ROOT \"${gcc_default_path}\")|" "${script}" > temp.$$ && mv temp.$$ "${script}"
sed -e "s|set(EXT.*|set(EXT ${extension})|" "${script}" > temp.$$ && mv temp.$$ "${script}"

script="$2/IAR.8.50.6.cmake"
sed -e "s|set(TOOLCHAIN_ROOT.*|set(TOOLCHAIN_ROOT \"${iar_default_path}\")|" "${script}" > temp.$$ && mv temp.$$ "${script}"
sed -e "s|set(EXT.*|set(EXT ${extension})|" "${script}" > temp.$$ && mv temp.$$ "${script}"

exit 0
