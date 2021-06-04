#!/bin/bash
set -eo pipefail
MODEL_NAME=${PWD##*/}
STACK_NAME=panorama-${PWD##*/}
BUCKET=$(cat bucket-name.txt)
MODEL_URI=$(cat model-uri.txt)
FUNCTION_NAME=$(aws cloudformation describe-stack-resource --stack-name $STACK_NAME --logical-resource-id function --query 'StackResourceDetail.PhysicalResourceId' --output text)
echo "FUNCTION NAME"
echo $FUNCTION_NAME
echo "MODEL NAME"
echo $MODEL_NAME
echo "MODEL OBJECT URI"
echo $MODEL_URI
