#!/bin/bash
set -eo pipefail
ARTIFACT_BUCKET=$(cat bucket-name.txt)
TEMPLATE_NAME=${PWD##*/}
STACK_NAME=panorama-$TEMPLATE_NAME
aws cloudformation package --template-file $TEMPLATE_NAME.yml --s3-bucket $ARTIFACT_BUCKET --output-template-file out.yml
aws cloudformation deploy --template-file out.yml --stack-name $STACK_NAME --capabilities CAPABILITY_NAMED_IAM --parameter-overrides bucketName=$ARTIFACT_BUCKET
rm out.yml