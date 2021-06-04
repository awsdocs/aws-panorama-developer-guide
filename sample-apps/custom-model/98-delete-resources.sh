#!/bin/bash
set -eo pipefail
TEMPLATE=${PWD##*/}
if [[ $# -eq 1 ]] ; then
    TEMPLATE=$1
fi
STACK_NAME=panorama-$TEMPLATE
while true; do
    read -p "Delete stack $STACK_NAME? (y/n)" response
    case $response in
        [Yy]* ) aws cloudformation delete-stack --stack-name $STACK_NAME; break;;
        [Nn]* ) break;;
        * ) echo "Response must start with y or n.";;
    esac
done
