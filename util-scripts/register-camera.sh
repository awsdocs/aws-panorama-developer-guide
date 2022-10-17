#!/usr/bin/env bash
set -eo pipefail
if [[ $# -eq 3 ]] ; then
    NAME=$1
    USERNAME=$2
    URL=$3
else
    echo "Usage: ./register-camera.sh <stream-name> <username> <rtsp-url>"
    exit 1
fi
echo "Enter camera stream password: "
read PASSWORD
TEMPLATE='{"Username":"MY_USERNAME","Password":"MY_PASSWORD","StreamUrl": "MY_URL"}'
TEMPLATE=${TEMPLATE/MY_USERNAME/$USERNAME}
TEMPLATE=${TEMPLATE/MY_PASSWORD/$PASSWORD}
TEMPLATE=${TEMPLATE/MY_URL/$URL}
echo ${TEMPLATE}
JOB_ID=$(aws panorama create-node-from-template-job --template-type RTSP_CAMERA_STREAM --output-package-name ${NAME} --output-package-version "1.0" --node-name ${NAME} --template-parameters "${TEMPLATE}" --output text)
echo "Job ID: ${JOB_ID}"
echo "..."
sleep 8
set -x
aws panorama describe-node-from-template-job --job-id ${JOB_ID}