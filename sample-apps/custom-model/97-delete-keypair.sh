#!/bin/bash
set -eo pipefail
KEYPAIR=panorama-ec2
while true; do
    read -p "Delete keypair $KEYPAIR? (y/n)" response
    case $response in
        [Yy]* ) aws ec2 delete-key-pair --key-name $KEYPAIR; rm certificates/$KEYPAIR.pem; rmdir certificates; break;;
        [Nn]* ) break;;
        * ) echo "Response must start with y or n.";;
    esac
done
