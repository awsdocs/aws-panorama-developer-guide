#!/bin/bash
set -eo pipefail
TEMPLATE_NAME=aws-panorama-sample
STACK_NAME=panorama-$TEMPLATE_NAME
aws cloudformation deploy --template-file $TEMPLATE_NAME.yml --stack-name $STACK_NAME --capabilities CAPABILITY_NAMED_IAM