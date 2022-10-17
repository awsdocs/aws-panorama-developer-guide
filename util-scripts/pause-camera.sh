#!/usr/bin/env bash
set -eo pipefail

hash jq 2>/dev/null || {
    echo >&2 "This script uses jq. Download at https://stedolan.github.io/jq/"
    exit 1
}

choose_camera() {
    echo "Getting nodes..."
    INSTANCE_ID=$1
    DEVICES=$(aws panorama list-application-instance-node-instances --application-instance-id $INSTANCE_ID)
    NODE_NAMES=($((echo ${DEVICES} | jq -r '[.NodeInstances[].PackageName] | @sh') | tr -d \'\"))
    NODE_STATUSES=($((echo ${DEVICES} | jq -r '[.NodeInstances[].CurrentStatus] | @sh') | tr -d \'\"))
    if [ -x ${NODE_NAMES} ]; then
        echo "No nodes found for application instance $INSTANCE_ID."
        exit
    fi
    for (( c=0; c<${#NODE_NAMES[@]}; c++ ))
    do
        printf "%s: %-24s %s\n" "${c}" "${NODE_NAMES[${c}]}" "${NODE_STATUSES[${c}]}"
    done
    echo "Choose a node"
    read D_INDEX
    echo "Signalling node ${NODE_NAMES[${D_INDEX}]}"
    COMMAND=PAUSE
    if [[ ${NODE_STATUSES[${D_INDEX}]} =~ "PAUSED" ]]; then
        COMMAND=RESUME
    fi
    CAMERA=${NODE_NAMES[${D_INDEX}]}
}

print_usage() {
    echo "Usage: ./pause-camera.sh                 (with application-id.txt in folder)"
    echo "Usage: ./pause-camera.sh <application-instance> <stream-name> <PAUSE|RESUME>"
    exit 1
}

if [[ $# -eq 3 ]] ; then
    APPLICATION_ID=$1
    CAMERA=$2
    COMMAND=$3
elif [[ $# -eq 0 ]] ; then
    if [ -f "application-id.txt" ]; then
        APPLICATION_ID=$(cat application-id.txt)
        choose_camera $APPLICATION_ID
    else
        print_usage
    fi
else
    print_usage
fi
SIGNAL='[{"NodeInstanceId": "MY_CAMERA", "Signal": "MY_COMMAND"}]'
SIGNAL=${SIGNAL/MY_CAMERA/$CAMERA}
SIGNAL=${SIGNAL/MY_COMMAND/$COMMAND}
set -x
aws panorama signal-application-instance-node-instances --application-instance-id ${APPLICATION_ID} --node-signals "${SIGNAL}"
