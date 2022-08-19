#!/bin/bash

# -------------------------------------------------------
# Copyright (c) 2020-2022 Arm Limited. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
# -------------------------------------------------------

# This scripts creates the self-extracting CMSIS Toolbox Installer
#
# Pre-requisites:
# - bash shell (for Windows: install git for Windows)

# header
echo "Generate CMSIS-Toolbox Installer"

# usage
usage() {
  echo "Usage:"
  echo "  create_installer.sh --input=<DistDir> --output=<InstallerDir> --version=<Version>"
  echo ""
  echo "  <DistDir>      : CMSIS-Toolbox Distribution directory"
  echo "  <InstallerDir> : Installer output directory"
  echo "  <Version>      : CMSIS-Toolbox version"
}

# arguments
if [ $# -eq 0 ]
then
  usage
  exit 0
fi

# arguments
for i in "$@"
do
  case "$i" in
    --input=*)
      distdir="${i#*=}"
      shift
    ;;
    --output=*)
      output="${i#*=}"
      shift
    ;;
    --version=*)
      version="${i#*=}"
      shift
    ;;
    *)
      usage
      exit 0
    ;;
  esac
done

archive_name=cmsis-toolbox.tar.gz
script_name=install.sh

installer_name=cmsis-toolbox.sh

# compress
tar czf ${archive_name} -C ${distdir} .
if [ $? -ne 0 ]
  then
  echo "Error: compressing failed"
  exit 1
fi

cp ${script_name} script
timestamp=$(date +%Y-%m-%dT%H:%M:%S)
githash=$(git rev-parse HEAD)
sed -e "s|version=.*|version=${version}|"\
    -e "s|timestamp=.*|timestamp=${timestamp}|"\
    -e "s|githash=.*|githash=${githash}|"\
    script > temp.$$ && mv temp.$$ script

mkdir -p ${output}
cat script ${archive_name} > ${output}/${installer_name}
if [ $? -ne 0 ]
  then
  echo "Error: concatenating failed"
  exit 1
fi

chmod +x ${output}/${installer_name}
rm -rf ${archive_name} script

echo "CMSIS Tools Installer self-extracting ${installer_name} was created!"

exit 0
