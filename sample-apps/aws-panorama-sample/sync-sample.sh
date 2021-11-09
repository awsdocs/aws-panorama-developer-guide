#!/bin/bash
set -eo pipefail
ACCOUNT_ID=$(ls packages | grep -Eo '[0-9]{12}' | head -1)
ACCOUNT_EX=123456789012
mv packages/${ACCOUNT_ID}-SAMPLE_CODE-1.0 packages/${ACCOUNT_EX}-SAMPLE_CODE-1.0
cp packages/${ACCOUNT_EX}-SAMPLE_CODE-1.0/package.json.bup packages/${ACCOUNT_EX}-SAMPLE_CODE-1.0/package.json
mv packages/${ACCOUNT_ID}-SQUEEZENET_PYTORCH_V1-1.0 packages/${ACCOUNT_EX}-SQUEEZENET_PYTORCH_V1-1.0
cp packages/${ACCOUNT_EX}-SQUEEZENET_PYTORCH_V1-1.0/package.json.bup packages/${ACCOUNT_EX}-SQUEEZENET_PYTORCH_V1-1.0/package.json
sed -i "s/${ACCOUNT_ID}/${ACCOUNT_EX}/ig" graphs/aws-panorama-sample/graph.json
cp -r packages graphs aws-panorama-sample.yml .gitignore *.sh ../aws-panorama-sample/