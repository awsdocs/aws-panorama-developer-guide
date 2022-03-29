#!/bin/bash
# device id
if [[ $# -eq 2 ]] ; then
    DEVICE_ID=$1
    APPLICATION_ID=$2
elif [ -f "device-id.txt" ]; then
    DEVICE_ID=$(cat device-id.txt)
else
    echo "device-id.txt not found. Use the deploy script to choose a device and deploy the sample application."
    echo "Or provide a device ID and application instance ID."
    echo "    $ ./view-logs.sh <device-id> <application-instance-id>"
    exit 1
fi
# existing application instance id
if [ -x $APPLICATION_ID ]; then
    if [ -f "application-id.txt" ]; then
        APPLICATION_ID=$(cat application-id.txt)
    else
        echo "application-id.txt not found. Use the deploy script to choose a device and deploy the sample application."
    fi
fi
GROUP="/aws/panorama/devices/MY_DEVICE_ID/applications/MY_APPLICATION_ID"
GROUP=${GROUP/MY_DEVICE_ID/$DEVICE_ID}
GROUP=${GROUP/MY_APPLICATION_ID/$APPLICATION_ID}
echo "Getting logs for group ${GROUP}."
#set -x
while true
do
    LOGS=$(aws logs get-log-events --log-group-name ${GROUP} --log-stream-name code_node --limit 150)
    readarray -t ENTRIES < <(echo $LOGS | jq -c '.events[].message')
    for ENTRY in "${ENTRIES[@]}"; do
        echo "$ENTRY" | tr -d \"
    done
    sleep 20
done