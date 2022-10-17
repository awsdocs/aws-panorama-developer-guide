#!/usr/bin/env bash
set -eo pipefail

hash jq 2>/dev/null || {
    echo >&2 "This script uses jq. Download at https://stedolan.github.io/jq/"
    exit 1
}

choose_device() {
    echo "Getting devices..."
    DEVICES=$(aws panorama list-devices)
    DEVICE_NAMES=($((echo ${DEVICES} | jq -r '.Devices |=sort_by(.LastUpdatedTime) | [.Devices[].Name] | @sh') | tr -d \'\"))
    DEVICE_IDS=($((echo ${DEVICES} | jq -r '.Devices |=sort_by(.LastUpdatedTime) | [.Devices[].DeviceId] | @sh') | tr -d \'\"))
    if [ -x ${DEVICE_IDS} ]; then
        echo "No devices found. Provision a device with the management console or"
        echo "use the provision-device.sh script under util-scripts/ in this repository."
        exit
    fi
    for (( c=0; c<${#DEVICE_NAMES[@]}; c++ ))
    do
        echo "${c}: ${DEVICE_IDS[${c}]}     ${DEVICE_NAMES[${c}]}"
    done
    echo "Choose a device"
    read D_INDEX
    DEVICE_ID=${DEVICE_IDS[${D_INDEX}]}
}

version_is_newer() {
    NEW_VERSION=$1
    NEW_MAJ=$(echo $NEW_VERSION | cut -d "." -f 1)
    NEW_MIN=$(echo $NEW_VERSION | cut -d "." -f 2)
    NEW_PAT=$(echo $NEW_VERSION | cut -d "." -f 3)
    OLD_VERSION=$2
    if [ ${OLD_VERSION} = "NOT_AVAILABLE" ]; then
        echo "TRUE"
        exit
    fi
    OLD_MAJ=$(echo $OLD_VERSION | cut -d "." -f 1)
    OLD_MIN=$(echo $OLD_VERSION | cut -d "." -f 2)
    OLD_PAT=$(echo $OLD_VERSION | cut -d "." -f 3)
    if [ ${NEW_MAJ} -gt ${OLD_MAJ} ]; then
        echo "TRUE"
    elif [ ${NEW_MIN} -gt ${OLD_MIN} ]; then
        echo "TRUE"
    elif [ ${NEW_PAT} -gt ${OLD_PAT} ]; then
        echo "TRUE"
    else
        echo "FALSE"
    fi
}

apply_update() {
    DEVICE_ID=$1
    NEW_VERSION=$2
    CONFIG='{"OTAJobConfig": {"ImageVersion": "NEW_VERSION"}}'
    CONFIG=${CONFIG/NEW_VERSION/$NEW_VERSION}
    aws panorama create-job-for-devices --device-ids ${DEVICE_ID} --device-job-config "${CONFIG}" --job-type OTA
}

if [[ $# -eq 1 ]] ; then
    DEVICE_ID=${1}
else
    choose_device
fi

echo "Checking ${DEVICE_ID} for updates."
DEVICE=$(aws panorama describe-device --device-id ${DEVICE_ID})

OLD_VERSION=$(echo $DEVICE | jq -r .CurrentSoftware)
NEW_VERSION=$(echo $DEVICE | jq -r .LatestSoftware)
IS_NEWER=$(version_is_newer ${NEW_VERSION} ${OLD_VERSION})

if [ ${IS_NEWER} = "TRUE" ]; then
    echo "A new version is available for device ${DEVICE_ID}: ${OLD_VERSION} -> ${NEW_VERSION}"
    while true; do
        read -p "Apply update? (y/n)" response
        case $response in
            [Yy]* ) apply_update ${DEVICE_ID} ${NEW_VERSION}; break;;
            [Nn]* ) exit;;
            * ) echo "Response must start with y or n.";;
        esac
    done
else
    echo "Device is up-to-date."
fi
