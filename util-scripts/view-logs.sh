#!/bin/bash
# device id
if [ -f "device-id.txt" ]; then
    DEVICE_ID=$(cat device-id.txt)
else
    echo "device-id.txt not found. Use 5-deploy.sh to choose a device and deploy the sample application"
fi
# existing application instance id
if [ -f "application-id.txt" ]; then
    APPLICATION_ID=$(cat application-id.txt)
else
    echo "application-id.txt not found. Use 5-deploy.sh to choose a device and deploy the sample application"
fi
GROUP="/aws/panorama/devices/MY_DEVICE_ID/applications/MY_APPLICATION_ID"
GROUP=${GROUP/MY_DEVICE_ID/$DEVICE_ID}
GROUP=${GROUP/MY_APPLICATION_ID/$APPLICATION_ID}
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