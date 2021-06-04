#!/bin/bash
set -eo pipefail
TEMPLATE=ec2-instance
if [[ $# -eq 1 ]] ; then
    TEMPLATE=$1
fi
STACK=panorama-$TEMPLATE
echo "Creating stack $STACK"
aws cloudformation deploy --template-file $TEMPLATE.yml --stack-name $STACK --capabilities CAPABILITY_NAMED_IAM
