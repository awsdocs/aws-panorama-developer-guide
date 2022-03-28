#!/bin/bash
set -eo pipefail
if [[ $# -eq 3 ]] ; then
    NAME=$1
    GRAPH_PATH=$2
    OVERRIDE_PATH=$3
else
    NAME=${PWD##*/}
    GRAPH_PATH="graphs/my-app/graph.json"
    OVERRIDE_PATH="graphs/my-app/override.json"
fi
# device id
if [ -f "device-id.txt" ]; then
    DEVICE_ID=$(cat device-id.txt)
    echo "Deploying to device ${DEVICE_ID}"
else
    echo "Getting devices..."
    DEVICES=$(aws panorama list-devices)
    DEVICE_NAMES=($((echo ${DEVICES} | jq -r '.Devices |=sort_by(.LastUpdatedTime) | [.Devices[].Name] | @sh') | tr -d \'\"))
    DEVICE_IDS=($((echo ${DEVICES} | jq -r '.Devices |=sort_by(.LastUpdatedTime) | [.Devices[].DeviceId] | @sh') | tr -d \'\"))
    for (( c=0; c<${#DEVICE_NAMES[@]}; c++ ))
    do
        echo "${c}: ${DEVICE_IDS[${c}]}     ${DEVICE_NAMES[${c}]}"
    done
    echo "Choose a device"
    read D_INDEX
    echo "Deploying to device ${DEVICE_IDS[${D_INDEX}]}"
    echo -n ${DEVICE_IDS[${D_INDEX}]} > device-id.txt
    DEVICE_ID=$(cat device-id.txt)
fi
# existing application instance id
if [ -f "application-id.txt" ]; then
    EXISTING_APPLICATION=$(cat application-id.txt)
    REPLACE_ARG="--application-instance-id-to-replace=${EXISTING_APPLICATION}"
    echo "Replacing application instance ${EXISTING_APPLICATION}"
fi
# application manifest
GRAPH=$(cat ${GRAPH_PATH} | tr -d '\n' | tr -d '[:blank:]')
MANIFEST="$(jq --arg value "${GRAPH}" '.PayloadData="\($value)"' <<< {})"
##echo "MANIFEST: ${MANIFEST}"
# manifest override
OVERRIDE=$(cat ${OVERRIDE_PATH} | tr -d '\n' | tr -d '[:blank:]')
MANIFEST_OVERRIDE="$(jq --arg value "${OVERRIDE}" '.PayloadData="\($value)"' <<< {})"
##echo "MANIFEST_OVERRIDE: ${MANIFEST_OVERRIDE}"
# application role
STACK_NAME=panorama-${NAME}
ROLE_ARN=$(aws cloudformation describe-stacks --stack-name panorama-${PWD##*/} --query 'Stacks[0].Outputs[?OutputKey==`roleArn`].OutputValue' --output text)
if [[ -z "${ROLE_ARN}" ]]; then
    echo "Application role is not available. Run 1-create-role.sh to create."
    while true; do
        read -p "Continue without AWS SDK functionality? (y/n)" response
        case $response in
            [Yy]* ) break;;
            [Nn]* ) exit 1;;
            * ) echo "Response must start with y or n.";;
        esac
    done
else
    ROLE_ARG="--runtime-role-arn=${ROLE_ARN}"
fi
APPLICATION_ID=$(aws panorama create-application-instance ${REPLACE_ARG} --manifest-payload="${MANIFEST}" --default-runtime-context-device=${DEVICE_ID} --name=${NAME} --description="command-line deploy" --tags client=sample --manifest-overrides-payload="${MANIFEST_OVERRIDE}" ${ROLE_ARG} --output text)
echo "New application instance ${APPLICATION_ID}"
echo -n $APPLICATION_ID > application-id.txt