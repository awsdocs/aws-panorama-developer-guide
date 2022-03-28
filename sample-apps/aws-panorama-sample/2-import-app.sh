#!/bin/bash
set -eo pipefail
# download sample model
MODEL_ASSET=fd1aef48acc3350a5c2673adacffab06af54c3f14da6fe4a8be24cac687a386e.tar.gz
if [ ! -f "assets/${MODEL_ASSET}" ]; then
    curl -L https://github.com/awsdocs/aws-panorama-developer-guide/releases/download/v1.0-ga/${MODEL_ASSET} -o assets/${MODEL_ASSET}
fi
# rename directories
panorama-cli import-application
ACCOUNT_ID=$(ls packages | grep -Eo '[0-9]{12}' | head -1)
ACCOUNT_EX=123456789012
sed -i "s/${ACCOUNT_EX}/${ACCOUNT_ID}/ig" graphs/my-app/*.json