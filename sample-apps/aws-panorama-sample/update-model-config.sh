#!/bin/bash
set -eo pipefail
ACCOUNT_ID=$(ls packages | grep -Eo '[0-9]{12}' | head -1)
MODEL_ASSET=fd1aef48acc3350a5c2673adacffab06af54c3f14da6fe4a8be24cac687a386e
MODEL_PACKAGE=SQUEEZENET_PYTORCH_V1
panorama-cli add-raw-model --model-asset-name model_asset --model-local-path assets/${MODEL_ASSET}.tar.gz --descriptor-path packages/${ACCOUNT_ID}-${MODEL_PACKAGE}-1.0/descriptor.json --packages-path packages/${ACCOUNT_ID}-${MODEL_PACKAGE}-1.0
cp packages/${ACCOUNT_ID}-${MODEL_PACKAGE}-1.0/package.json packages/${ACCOUNT_ID}-${MODEL_PACKAGE}-1.0/package.json.bup