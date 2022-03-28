#!/bin/bash
set -eo pipefail
CODE_PACKAGE=SAMPLE_CODE
ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
panorama-cli build-container --container-asset-name code_asset --package-path packages/${ACCOUNT_ID}-${CODE_PACKAGE}-1.0
