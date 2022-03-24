#!/bin/bash
set -eo pipefail
if [[ $# -eq 1 ]] ; then
    NAME=$1
else
    echo "Usage: ./deregister-camera.sh <node-name>"
    exit 1
fi
QUERY='Nodes[?Name==`MY_CAMERA`].PackageId'
QUERY=${QUERY/MY_CAMERA/$NAME}
PACKAGE_ID=$(aws panorama list-nodes --category MEDIA_SOURCE --query ${QUERY} --output text)
QUERY='Nodes[?Name==`MY_CAMERA`].PatchVersion'
QUERY=${QUERY/MY_CAMERA/$NAME}
PATCH_ID=$(aws panorama list-nodes --category MEDIA_SOURCE --query ${QUERY} --output text)
set -x
aws panorama deregister-package-version --package-id ${PACKAGE_ID} --package-version "1.0" --patch-version ${PATCH_ID}