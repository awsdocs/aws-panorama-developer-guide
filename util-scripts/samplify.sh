#!/usr/bin/env bash
set -eo pipefail
CODE_PACKAGE=SAMPLE_CODE
MODEL_PACKAGE=SQUEEZENET_PYTORCH
ACCOUNT_ID=$(ls packages | grep -Eo '[0-9]{12}' | head -1)
ACCOUNT_EX=123456789012
mv packages/${ACCOUNT_ID}-${CODE_PACKAGE}-1.0 packages/${ACCOUNT_EX}-${CODE_PACKAGE}-1.0
cp packages/${ACCOUNT_EX}-${CODE_PACKAGE}-1.0/package.json.bup packages/${ACCOUNT_EX}-${CODE_PACKAGE}-1.0/package.json
mv packages/${ACCOUNT_ID}-${MODEL_PACKAGE}-1.0 packages/${ACCOUNT_EX}-${MODEL_PACKAGE}-1.0
cp packages/${ACCOUNT_EX}-${MODEL_PACKAGE}-1.0/package.json.bup packages/${ACCOUNT_EX}-${MODEL_PACKAGE}-1.0/package.json
sed -i "s/${ACCOUNT_ID}/${ACCOUNT_EX}/ig" graphs/my-app/*.json
cp graphs/my-app/override.json.bup graphs/my-app/override.json