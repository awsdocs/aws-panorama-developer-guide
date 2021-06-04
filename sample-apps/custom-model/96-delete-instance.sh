#!/bin/bash
set -eo pipefail
TEMPLATE=ec2-instance
if [[ $# -eq 1 ]] ; then
    TEMPLATE=$1
fi
STACK=panorama-$TEMPLATE
while true; do
    read -p "Delete stack $STACK? (y/n)" response
    case $response in
        [Yy]* ) aws cloudformation delete-stack --stack-name $STACK; break;;
        [Nn]* ) break;;
        * ) echo "Response must start with y or n.";;
    esac
done
