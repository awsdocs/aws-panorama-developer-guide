#!/bin/bash
set -eo pipefail
# Deregisters old application package versions. Each patch version corresponds to a package manifest
# in an Amazon S3 access point managed by AWS Panorama. Deletes the manifest file, but not binary
# assets such as container images. Binary assets can be used by multiple patch versions. Verify that
# no in-use manifests reference binary assets before deleting them from the access point.
if [[ $# -eq 1 ]] ; then
    PACKAGE_NAME=$1
else
    echo "Usage: ./cleanup-patches.sh <package-name>"
    exit 1
fi
PACKAGE_LIST=$(aws panorama list-packages)
while [ -x ${PACKAGE_ID} ]; do
    PACKAGE_ID=$(echo "${PACKAGE_LIST}" | jq -r --arg PACKAGE_NAME "${PACKAGE_NAME}" '.Packages[] | select (.PackageName == $PACKAGE_NAME) | .PackageId')
    NEXT_TOKEN=$(echo "${PACKAGE_LIST}" | jq -r '.NextToken')
    if [ -x ${PACKAGE_ID} ]; then
        if [ "${NEXT_TOKEN}" = "null" ]; then
            echo "Package not found."
            exit 1
        fi
        PACKAGE_LIST=$(aws panorama list-packages --next-token ${NEXT_TOKEN})
    fi
done
PACKAGE=$(aws panorama describe-package --package-id ${PACKAGE_ID})
BUCKET=$(echo "${PACKAGE}" | jq -r '.StorageLocation.Bucket')
MANI_PREFIX=$(echo "${PACKAGE}" | jq -r '.StorageLocation.ManifestPrefixLocation')
BINARY_PREFIX=$(echo "${PACKAGE}" | jq -r '.StorageLocation.BinaryPrefixLocation')
MANIS=$(aws s3api list-objects --bucket ${BUCKET} --prefix ${MANI_PREFIX})
PATCH_DATES=($((echo ${MANIS} | jq -r '.Contents |=sort_by(.LastModified) | [.Contents[].LastModified] | @sh') | tr -d \'\"))
MANI_PATHS=($((echo ${MANIS} | jq -r '.Contents |=sort_by(.LastModified) | [.Contents[].Key] | @sh') | tr -d \'\"))
PATCH_ID_REGEX='([A-Za-z0-9]{64})\.json'
PACKAGE_VERSION_REGEX='/manifests/([0-9]\.[0-9])/'
get_patch_id() {
    PATH=$1
    if [[ ${PATH} =~ ${PATCH_ID_REGEX} ]]; then
        PATCH_ID=${BASH_REMATCH[1]}
        echo ${PATCH_ID}
    fi
}
get_package_version() {
    PATH=$1
    if [[ ${PATH} =~ ${PACKAGE_VERSION_REGEX} ]]; then
        PACKAGE_VERSION=${BASH_REMATCH[1]}
        echo ${PACKAGE_VERSION}
    fi
}
echo "PATCH VERSIONS"
for (( c=0; c<${#PATCH_DATES[@]}; c++ ))
do
    PATCH_ID=$(get_patch_id ${MANI_PATHS[${c}]})
    PACKAGE_VERSION=$(get_package_version ${MANI_PATHS[${c}]})
    echo "${PATCH_DATES[${c}]} : Version ${PACKAGE_VERSION}.${PATCH_ID}"
done
while [ -x ${NUM_VERSIONS} ]; do
    echo "Deregister how many old versions?"
    read NUM_VERSIONS
done
if [[ "${NUM_VERSIONS}" -ge "${#PATCH_DATES[@]}" ]]; then
    echo "Only ${#PATCH_DATES[@]} patch versions available."
    exit 1
fi
for (( c=0; c<${NUM_VERSIONS}; c++ ))
do
    PATCH_ID=$(get_patch_id ${MANI_PATHS[${c}]})
    PACKAGE_VERSION=$(get_package_version ${MANI_PATHS[${c}]})
    echo "DEREGISTERING ${PATCH_ID}"
    echo "aws panorama deregister-package-version --package-id ${PACKAGE_ID} --package-version ${PACKAGE_VERSION} --patch-version ${PATCH_ID}"
    aws panorama deregister-package-version --package-id ${PACKAGE_ID} --package-version ${PACKAGE_VERSION} --patch-version ${PATCH_ID}
    echo "SAVING COPY OF MANIFEST"
    aws s3 cp s3://${BUCKET}/${MANI_PATHS[${c}]} .
    echo "DELETING MANIFEST FROM AMAZON S3"
    echo "aws s3api delete-object --bucket ${BUCKET} --key ${MANI_PATHS[${c}]}"
    aws s3api delete-object --bucket ${BUCKET} --key ${MANI_PATHS[${c}]}
    echo ""
done
echo "Package manifests deregistered and deleted. Find assets referenced by patch versions"
echo "in local copy of manifests. Assets might be used by other registered patch versions."
echo "To see all assets and remaining manifests in Amazon S3, run the following commands."
echo "aws s3 ls s3://${BUCKET}/${MANI_PREFIX}/${PACKAGE_VERSION}/"
echo "aws s3 ls s3://${BUCKET}/${BINARY_PREFIX}/"