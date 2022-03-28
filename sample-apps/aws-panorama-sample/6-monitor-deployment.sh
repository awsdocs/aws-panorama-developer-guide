#!/bin/bash
set -eo pipefail
if [ -f "application-id.txt" ]; then
    APPLICATION_ID=$(cat application-id.txt)
fi
if [ -f "device-id.txt" ]; then
    DEVICE_ID=$(cat device-id.txt)
fi
QUERY="ApplicationInstances[?ApplicationInstanceId==\`APPLICATION_ID\`]"
QUERY=${QUERY/APPLICATION_ID/$APPLICATION_ID}
MONITOR_CMD="aws panorama list-application-instances --device-id ${DEVICE_ID} --query ${QUERY}"
MONITOR_CMD=${MONITOR_CMD/QUERY/$QUERY}
while true; do
    $MONITOR_CMD
    sleep 60
done

