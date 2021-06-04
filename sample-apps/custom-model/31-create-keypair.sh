#!/bin/bash
set -eo pipefail
mkdir -p certificates
aws ec2 create-key-pair --key-name panorama-ec2 --query 'KeyMaterial' --output text > certificates/panorama-ec2.pem
chmod 400 certificates/panorama-ec2.pem
