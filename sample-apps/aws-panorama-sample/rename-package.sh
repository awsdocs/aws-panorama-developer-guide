#!/bin/bash
set -eo pipefail
OLD=$1
NEW=$2
ACCOUNT_ID=$(ls packages | grep -Eo '[0-9]{12}' | head -1)
mv packages/${ACCOUNT_ID}-${OLD}-1.0 packages/${ACCOUNT_ID}-${NEW}-1.0
sed -i "s/$OLD/$NEW/ig" packages/${ACCOUNT_ID}-${NEW}-1.0/package.json graphs/aws-panorama-sample/graph.json
