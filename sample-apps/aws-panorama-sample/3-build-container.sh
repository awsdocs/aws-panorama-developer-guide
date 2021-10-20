#!/bin/bash
set -eo pipefail

ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
panorama-cli build-container --container-asset-name code_asset --package-path packages/${ACCOUNT_ID}-SAMPLE_CODE-1.0
