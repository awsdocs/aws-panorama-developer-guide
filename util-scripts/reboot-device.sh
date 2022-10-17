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

if [[ $# -eq 1 ]] ; then
    DEVICE_ID=${1}
else
    choose_device
fi
while true; do
    read -p "Reboot device $DEVICE_ID? (y/n)" response
    case $response in
        [Yy]* ) aws panorama create-job-for-devices --device-ids ${DEVICE_ID} --job-type REBOOT; break;;
        [Nn]* ) exit;;
        * ) echo "Response must start with y or n.";;
    esac
done
