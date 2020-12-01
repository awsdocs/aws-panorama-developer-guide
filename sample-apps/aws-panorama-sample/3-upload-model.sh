#!/bin/bash
set -eo pipefail
BUCKET=$(cat bucket-name.txt)
MODEL_ARCHIVE=ssd_512_resnet50_v1_voc.tar.gz
if [ -f $MODEL_ARCHIVE ]; then
    aws s3 cp $MODEL_ARCHIVE s3://$BUCKET
    echo "Uploaded model: s3://$BUCKET/$MODEL_ARCHIVE"
else
    echo "Model file not found: $MODEL_ARCHIVE"
fi
