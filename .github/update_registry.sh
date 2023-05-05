#!/bin/bash

function usage() {
    echo "Usage: update_registry <registry> <version>"
    echo "  registry    Path to the vcpkg registry to update."
    echo "  version     Release version to add to registry."
}

if [[ $1 == '-h' || $1 == '--help' ]]; then
    usage
    exit 0
elif [[ $# != 2 ]]; then
    echo "Error: Invalid number of command line arguments ($# given, 2 required)!" >&2
    echo "" >&2
    usage
    exit 1
fi

DIRNAME=$(dirname $0)
REGISTRY=$(realpath $1)

if [ ! -d ${REGISTRY} ]; then
    echo "Error: Path to registry does not exist!" >&2
    echo "" >&2
    usage
    exit 1
fi

if [ ! -f ${REGISTRY}/index.yaml ]; then
    echo "Error: No valid registry found at ${REGISTRY}!" >&2
    echo "" >&2
    usage
    exit 1
fi

if [[ ! "$2" =~ [[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+ ]]; then
    echo "Error: No valid version identifier '$2'!" >&2
    echo "" >&2
    usage
    exit 1
fi

export CTOOLS_VERSION="$2"

echo "Downloading checksum file for CMSIS-Toobox ${CTOOLS_VERSION} ..."
curl -sLO https://github.com/Open-CMSIS-Pack/cmsis-toolbox/releases/download/${CTOOLS_VERSION}/cmsis-toolbox-checksums.txt

export CTOOLS_WINDOWS_AMD64_SHA=$(grep cmsis-toolbox-windows-amd64.zip cmsis-toolbox-checksums.txt | cut -d\  -f1)
export CTOOLS_WINDOWS_ARM64_SHA=$(grep cmsis-toolbox-windows-arm64.zip cmsis-toolbox-checksums.txt | cut -d\  -f1)
export CTOOLS_LINUX_AMD64_SHA=$(grep cmsis-toolbox-linux-amd64.tar.gz cmsis-toolbox-checksums.txt | cut -d\  -f1)
export CTOOLS_LINUX_ARM64_SHA=$(grep cmsis-toolbox-linux-arm64.tar.gz cmsis-toolbox-checksums.txt | cut -d\  -f1)
export CTOOLS_DARWIN_AMD64_SHA=$(grep cmsis-toolbox-darwin-amd64.tar.gz cmsis-toolbox-checksums.txt | cut -d\  -f1)
export CTOOLS_DARWIN_ARM64_SHA=$(grep cmsis-toolbox-darwin-arm64.tar.gz cmsis-toolbox-checksums.txt | cut -d\  -f1)

echo "Generating vcpkg registry description into '${REGISTRY}/tools/open-cmsis-pack/ctools-${CTOOLS_VERSION}.json' ..."
envsubst < ${DIRNAME}/ctools.json.in > ${REGISTRY}/tools/open-cmsis-pack/ctools-${CTOOLS_VERSION}.json

echo "Regenerating vcpkg registry index at '${REGISTRY}' ..."

function regen() {
    . <(curl -sL https://aka.ms/vcpkg-init.sh)
    vcpkg x-regenerate ${REGISTRY}
}

regen

exit 0
