#!/bin/bash
set -eo pipefail
if [ -f "application-id.txt" ]; then
    APPLICATION_ID=$(cat application-id.txt)
else
    echo "application-id.txt not found."
fi
aws panorama remove-application-instance --application-instance-id ${APPLICATION_ID}
echo "Removed application instance ${APPLICATION_ID}."
rm application-id.txt