#!/bin/bash
set -eo pipefail
PROJECT_NAME=${PWD##*/}
if [ -f bucket-name.txt ]; then
    ARTIFACT_BUCKET=$(cat bucket-name.txt)
    rm -rf code/model/__pycache__
    aws s3 sync . s3://$ARTIFACT_BUCKET/$PROJECT_NAME
else
    echo "ERROR bucket-name.txt not found."
fi