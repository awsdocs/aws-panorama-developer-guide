#!/bin/bash
set -eo pipefail
MODEL_NAME=aws-panorama-sample-model
MODEL_ARCHIVE=ssd_512_resnet50_v1_voc.tar.gz
BUCKET=$(cat bucket-name.txt)
MODEL_URI=s3://$BUCKET/$MODEL_ARCHIVE
VERSION=$(aws cloudformation describe-stack-resource --stack-name aws-panorama-sample --logical-resource-id version --query 'StackResourceDetail.PhysicalResourceId' --output text)
echo "FUNCTION VERSION ARN"
echo $VERSION
echo "MODEL NAME"
echo $MODEL_NAME
echo "MODEL OBJECT URI"
echo $MODEL_URI
