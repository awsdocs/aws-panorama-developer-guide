#!/bin/bash
set -eo pipefail
IP_ADDRESS=$(aws cloudformation describe-stacks --stack-name panorama-ec2-instance --query 'Stacks[0].Outputs[?OutputKey==`publicIp`].OutputValue' --output text)
KEYPAIR_NAME=panorama-ec2
PROJECT_NAME=${PWD##*/}
if [ -f bucket-name.txt ]; then
    ARTIFACT_BUCKET=$(cat bucket-name.txt)
    echo "Project download command:"
    echo "   aws s3 sync s3://$ARTIFACT_BUCKET/$PROJECT_NAME $PROJECT_NAME"
else
    echo "ERROR bucket-name.txt not found."
fi
ssh -i certificates/$KEYPAIR_NAME.pem ubuntu@$IP_ADDRESS